import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc/bloc/person.dart';

const person1Url = 'http://127.0.0.1:5500/api/person1.json';
const person2Url = 'http://127.0.0.1:5500/api/person2.json';

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonActions implements LoadAction {
  final String url;
  final PersonLoader loader;

  const LoadPersonActions({required this.url, required this.loader}) : super();
}
