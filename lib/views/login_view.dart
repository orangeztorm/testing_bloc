import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:testing_bloc/views/email_textfield.dart';
import 'package:testing_bloc/views/login_button.dart';
import 'package:testing_bloc/views/password_textfield.dart';

class LoginView extends HookWidget {
  final OnLoginTapped onLoginTapped;
  const LoginView({
    Key? key,
    required this.onLoginTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          EmailTextField(emailController: emailController),
          PasswordTextField(passwordController: passwordController),
          LoginButton(
            emailController: emailController,
            passwordController: passwordController,
            onLoginTapped: onLoginTapped,
          )
        ],
      ),
    );
  }
}
