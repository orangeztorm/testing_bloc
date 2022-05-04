import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc/bloc/app_bloc.dart';
import 'package:testing_bloc/bloc/app_event.dart';
import 'package:testing_bloc/bloc/app_state.dart';
import 'package:testing_bloc/dialog/show_auth_errror_dialog.dart';
import 'package:testing_bloc/loading/loading_screen.dart';
import 'package:testing_bloc/views/login_view.dart';
import 'package:testing_bloc/views/photo_gallary_view.dart';
import 'package:testing_bloc/views/register_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading',
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final authError = appState.authError;
            if (authError != null) {
              showAuthErrorDialog(
                context: context,
                authError: authError,
              );
            }
          },
          builder: (context, appState) {
            print(appState);
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggenIn) {
              return const FlutterGalleryView();
            } else if (appState is AppStateisInRegistrationView) {
              return const RegisterView();
            } else {
              // this should never happend
              return Container();
            }
          },
        ),
      ),
    );
  }
}
