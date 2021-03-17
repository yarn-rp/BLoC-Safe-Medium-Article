/* import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final int initialCount;
  CounterBloc(this.initialCount) : super(CounterInitial(initialCount));

  @override
  Stream<CounterState> mapEventToState(
    CounterEvent event,
  ) async* {
    if (event is IncrementCounter) {
      int currentAdditionsOperations = state is CounterIncremented
          ? (state as CounterIncremented).consecutivesAdditionsOperations
          : 0;
      yield CounterIncremented(state.count + 1, currentAdditionsOperations + 1);
    } else if (event is DecrementCounter && state is CounterIncremented) {
      /// calculates the floor number of consecutivesAdditionsOperations divided by 2
      int decrement =
          ((state as CounterIncremented).consecutivesAdditionsOperations / 2)
              .floor();
      yield CounterDecremented(state.count - decrement);
    }
  }
}
 */