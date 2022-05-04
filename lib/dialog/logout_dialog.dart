import 'package:flutter/material.dart' show BuildContext;
import 'package:testing_bloc/dialog/generic_dialog.dart';

Future<bool> showLogoutAccountDialog<bool>(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to logout!',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
