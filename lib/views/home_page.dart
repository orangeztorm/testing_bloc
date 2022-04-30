import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc/bloc/bottom_bloc.dart';
import 'package:testing_bloc/bloc/top_bloc.dart';
import 'package:testing_bloc/strings.dart';
import 'package:testing_bloc/views/app_bloc_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TopBloc>(
              create: (_) => TopBloc(
                urls: images,
                waitBeforeLoading: const Duration(
                  seconds: 3,
                ),
              ),
            ),
            BlocProvider<BottomBloc>(
              create: (_) => BottomBloc(
                urls: images,
                waitBerforeLoading: const Duration(
                  seconds: 3,
                ),
              ),
            ),
          ],
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: const [
               AppBlovView<TopBloc>(),
              AppBlovView<BottomBloc>(),
            ],
          ),
        ),
      ),
    );
  }
}
