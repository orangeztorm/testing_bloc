import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:testing_bloc/bloc/bloc_action.dart';
import 'package:testing_bloc/bloc/person.dart';
import 'package:testing_bloc/bloc/person_bloc.dart';

const mockedPerson1 = [
  Person(name: 'Foo1', age: 20),
  Person(name: 'Foo2', age: 20),
  Person(name: 'Foo3', age: 20),
];

const mockedPerson2 = [
  Person(name: 'o1', age: 20),
  Person(name: 'o2', age: 20),
  Person(name: 'o3', age: 20),
];

Future<Iterable<Person>> mockGetPerson1(String _) =>
    Future.value(mockedPerson1);
Future<Iterable<Person>> mockGetPerson2(String _) =>
    Future.value(mockedPerson2);

void main() {
  group(
    'Testing bloc',
    () {
      // write our tests
      late PesronBloc bloc;

      setUp(() {
        bloc = PesronBloc();
      });

      blocTest<PesronBloc, FetchResult?>('Test initial test',
          build: () => bloc,
          verify: (bloc) => expect(
                bloc.state,
                null,
              ));

      // fetch mockperson data 1 and compare it with Fetchresult
      blocTest<PesronBloc, FetchResult?>(
          'Mock retriving persons from first iterable',
          build: () => bloc,
          act: (bloc) {
            bloc.add(const LoadPersonActions(
              url: 'dummy_url_1',
              loader: mockGetPerson1,
            ));

            bloc.add(const LoadPersonActions(
              url: 'dummy_url_1',
              loader: mockGetPerson1,
            ));
          },
          expect: () => [
                const FetchResult(
                  persons: mockedPerson1,
                  isRetrivedFromCache: false,
                ),
                const FetchResult(
                  persons: mockedPerson1,
                  isRetrivedFromCache: true,
                ),
              ]);

      // fetch mockperson data 1 and compare it with Fetchresult

      blocTest<PesronBloc, FetchResult?>(
          'Mock retriving persons from second iterable',
          build: () => bloc,
          act: (bloc) {
            bloc.add(const LoadPersonActions(
              url: 'dummy_url_2',
              loader: mockGetPerson2,
            ));

            bloc.add(const LoadPersonActions(
              url: 'dummy_url_2',
              loader: mockGetPerson2,
            ));
          },
          expect: () => [
                const FetchResult(
                  persons: mockedPerson2,
                  isRetrivedFromCache: false,
                ),
                const FetchResult(
                  persons: mockedPerson2,
                  isRetrivedFromCache: true,
                ),
              ]);
    },
  );
}
