import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc/api/login_api.dart';
import 'package:testing_bloc/api/notes_api.dart';
import 'package:testing_bloc/bloc/actions.dart';
import 'package:testing_bloc/bloc/app_state.dart';
import 'package:testing_bloc/dialogs/generic_dialog.dart';
import 'package:testing_bloc/dialogs/loading_screen.dart';
import 'package:testing_bloc/models.dart';
import 'package:testing_bloc/strings.dart';
import 'package:testing_bloc/views/list_iteraable.dart';
import 'package:testing_bloc/views/login_view.dart';

import 'bloc/app_bloc.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(loginApi: LoginApi(), notesApi: NotesApi()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homepage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // loading screen

            LoadingScreen loading = LoadingScreen.instance();

            if (appState.isLoading) {
              loading.show(
                context: context,
                text: pleaseWait,
              );
            } else {
              loading.hide();
            }

            // display multiple errors

            final loginErrors = appState.loginErrors;
            if (loginErrors != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialog,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }

            // if we are logged in but have no fetched notes, fetch them now

            if (appState.isLoading == false &&
                appState.loginErrors == null &&
                appState.loginHandle == const LoginHandle.foobar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNoteAction(),
                  );
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
