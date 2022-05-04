import 'package:flutter/material.dart' show BuildContext;
import 'package:testing_bloc/auth/auth_error.dart';
import 'package:testing_bloc/dialog/generic_dialog.dart';

Future<void> showAuthErrorDialog({
  required BuildContext context,
  required AuthError authError,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {
      'Ok': true,
    },
  );
}
