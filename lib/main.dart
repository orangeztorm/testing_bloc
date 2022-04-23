import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc/bloc/bloc_action.dart';
import 'package:testing_bloc/bloc/person.dart';
import 'package:testing_bloc/bloc/person_bloc.dart';

void main() {
  runApp(const MyApp());
}

extension SubScript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}


Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => PesronBloc(),
        child: const MyHomePage(),
      ),
    );
  }
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home page'),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                context.read<PesronBloc>().add(const LoadPersonActions(
                      url: person1Url,
                      loader: getPersons
                    ));
              },
              child: const Text('load json 1'),
            ),
            TextButton(
              onPressed: () {
                context.read<PesronBloc>().add(const LoadPersonActions(
                     url: person2Url,
                      loader: getPersons
                    ));
              },
              child: const Text('load json 2'),
            ),
            BlocBuilder<PesronBloc, FetchResult?>(
              buildWhen: (previous, current) {
                return previous?.persons != current?.persons;
              },
              builder: (context, fetchedResult) {
                final persons = fetchedResult?.persons;
                if (persons == null) {
                  return const SizedBox();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: persons.length,
                    itemBuilder: (context, index) {
                      final person = persons[index]!;
                      return ListTile(
                        title: Text(person.name),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ));
  }
}
