import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc/api/login_api.dart';
import 'package:testing_bloc/api/notes_api.dart';
import 'package:testing_bloc/bloc/actions.dart';
import 'package:testing_bloc/bloc/app_bloc.dart';
import 'package:testing_bloc/bloc/app_state.dart';
import 'package:test/test.dart';
import 'package:testing_bloc/models.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 2'),
];


void main() {
  blocTest<AppBloc, AppState>(
    'Initial State of the bloc.',
    build: () => AppBloc(
      loginApi: const DummyLoginApi.empty(),
      notesApi: const DummyNotesApi.empty(),
    ),
    verify: (appState) => expect(
      appState.state,
      const AppState.empty(),
    ),
  );

  blocTest<AppBloc, AppState>(
    'can we login with correct credentials',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@baz.com',
        acceptedPassword: 'dooo',
        handleToReturn: LoginHandle(token: 'ABC'),
      ),
      notesApi: const DummyNotesApi.empty(),
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'foo@baz.com',
        password: 'dooo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginErrors: null,
        loginHandle: LoginHandle(token: 'ABC'),
        fetchedNotes: null,
      ),
    ],
  );
}

@immutable
class Note {
  final String title;

  const Note({
    required this.title,
  });

  @override
  String toString() => 'Note -- title = $title';
}


@immutable
class DummyNotesApi implements NoteApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle,
  });

  const DummyNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.foobar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle,}) async {
     if (loginHandle == acceptedLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }

  
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToReturn = const LoginHandle.foobar();

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.handleToReturn,
  });

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToReturn;
    } else {
      return null;
    }
  }
}


