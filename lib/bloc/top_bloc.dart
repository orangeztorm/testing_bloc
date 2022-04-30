import 'package:testing_bloc/bloc/app_bloc.dart';

class TopBloc extends AppBloc {
  TopBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
  }) : super(
          waitBeforeLoading: waitBeforeLoading,
          urls: urls,
        );
}
