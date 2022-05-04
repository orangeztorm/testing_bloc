import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testing_bloc/firebase_options.dart';
import 'package:testing_bloc/views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(
    const App(),
  );
}

