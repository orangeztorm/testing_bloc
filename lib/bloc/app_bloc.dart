import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc/auth/auth_error.dart';
import 'package:testing_bloc/bloc/app_event.dart';
import 'package:testing_bloc/bloc/app_state.dart';
import 'package:testing_bloc/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    // app initialize
    on<AppEventInitialize>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
      } else {
        // get user images
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggenIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      }
    });

// go to registration view
    on<AppEventGoToRegistration>((event, emit) {
      emit(
        const AppStateisInRegistrationView(
          isLoading: false,
        ),
      );
    });

    // log user in
    on<AppEventLogin>((event, emit) async {
      // loading
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );

      // log the user in
      try {
        final email = event.email;
        final password = event.password;
        final userCredentials =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredentials.user!;
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggenIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    // go to login view
    on<AppEventGoToLogin>(
      (event, emit) => emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      ),
    );

    // registarting the user
    on<AppEventRegister>((event, emit) async {
      // start loading
      emit(
        const AppStateisInRegistrationView(
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        // register user
        final credentials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        emit(
          AppStateLoggenIn(
            user: credentials.user!,
            images: const [],
            isLoading: true,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateisInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    // logging user out
    on<AppEventLogOut>((event, emit) async {
      // start loading
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      // log the user out
      await FirebaseAuth.instance.signOut();
      // log the user out from the ui
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });

    // handle account deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      // log user out if we dont have valid user
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
        return;
      }
      // starts the loading process
      emit(
        AppStateLoggenIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
        ),
      );

      // delete user folder
      try {
        // delete user folder
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          await item.delete().catchError((_) {});
        }

        // delete the folder
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});

        // delete the user
        await user.delete();

        // log the user out
        await FirebaseAuth.instance.signOut();
        // log the user out from the ui
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggenIn(
            user: user,
            images: state.images ?? [],
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      } on FirebaseException catch (_) {
        // we might not be able to delete the folder
        // log the user out
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      }
    });

    on<AppEventToUploadImage>((event, emit) async {
      final user = state.user;
      // log user out if we dont have valid user
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
        return;
      }
      // starts the loading process
      emit(
        AppStateLoggenIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
        ),
      );

      final file = File(event.filePathToUpload);
      await uploadImage(
        file: file,
        userId: user.uid,
      );

      // after upload is complete grab the latest doce refrence
      final images = await _getImages(user.uid);
      emit(
        AppStateLoggenIn(
          user: user,
          images: images,
          isLoading: false,
        ),
      );
    });
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
