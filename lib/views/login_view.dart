import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:testing_bloc/bloc/app_bloc.dart';
import 'package:testing_bloc/bloc/app_event.dart';
import 'package:testing_bloc/extensions/if_debugging.dart';

class LoginView extends HookWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
      text: 'taiwokenny45@gmail.com'.ifDebugging,
    );
    final passwordController = useTextEditingController(
      text: 'testerone'.ifDebugging,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
              decoration: const InputDecoration(
                hintText: 'Enter your email...',
              ),
            ),
            TextField(
              controller: passwordController,
              autocorrect: false,
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              obscuringCharacter: '◉',
              decoration: const InputDecoration(
                hintText: 'Enter your password...',
              ),
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                context.read<AppBloc>().add(
                      AppEventLogin(
                        email: email,
                        password: password,
                      ),
                    );
              },
              child: const Text(
                'Login',
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(
                     const AppEventGoToRegistration(),
                    );
              },
              child: const Text(
                'Not registered yet. register here!',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
