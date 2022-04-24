import 'package:bloc/bloc.dart';
import 'package:testing_bloc/api/login_api.dart';
import 'package:testing_bloc/api/notes_api.dart';
import 'package:testing_bloc/bloc/actions.dart';
import 'package:testing_bloc/bloc/app_state.dart';
import 'package:testing_bloc/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NoteApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      // start loading
      emit(
        const AppState(
          isLoading: true,
          loginErrors: null,
          loginHandle: null,
          fetchedNotes: null,
        ),
      );

      // log the user in
      final loginHandle = await loginApi.login(
        email: event.email,
        password: event.password,
      );
      emit(
        AppState(
          isLoading: false,
          loginErrors: loginHandle == null ? LoginErrors.invalidHandle : null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ),
      );
    });

    on<LoadNoteAction>((event, emit) async {
      // loading the notes
      emit(
        AppState(
          isLoading: true,
          loginErrors: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null,
        ),
      );

      // load the notes
      final loginHandler = state.loginHandle;
      if (loginHandler != const LoginHandle.foobar()) {
        emit(
          AppState(
            isLoading: false,
            loginErrors: LoginErrors.invalidHandle,
            loginHandle: state.loginHandle,
            fetchedNotes: null,
          ),
        );
      } else {
        /// we have a valid loginhandler and want to fetch notes
        final notes = await notesApi.getNotes(
          loginHandle: loginHandler!,
        );
        emit(
          AppState(
            isLoading: false,
            loginErrors: null,
            loginHandle: state.loginHandle,
            fetchedNotes: notes,
          ),
        );
      }
    });
  }
}
