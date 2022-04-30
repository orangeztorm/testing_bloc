import 'package:testing_bloc/bloc/app_bloc.dart';

class BottomBloc extends AppBloc {
  BottomBloc({
    required Iterable<String> urls,
    Duration? waitBerforeLoading,
  }) : super(
          urls: urls,
          waitBeforeLoading: waitBerforeLoading,
        );
}
