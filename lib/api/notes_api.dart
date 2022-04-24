import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc/models.dart';

@immutable
abstract class NoteApiProtocol {
  const NoteApiProtocol();

  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  });
}

@immutable
class NotesApi implements NoteApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandle == const LoginHandle.foobar() ? mockNotes : null,
      );
}
