import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc_medium_article/bloc_safe/src/bloc_safe.dart';

part 'counter_event.dart';
part 'counter_state.dart';
part 'counter_transitions.dart';

typedef TransitionFunction<S extends CounterState, E extends CounterEvent>
    = Stream<CounterState> Function(E event, S state);

class CounterBloc extends BlocSafe<CounterEvent, CounterState> {
  final int initialCount;
  CounterBloc(this.initialCount) : super(CounterInitial(initialCount));

  @override
  Map<Edge, TransitionFunction> buildTransitions() {
    Map<Edge, TransitionFunction> transitions = {};
    transitions.addEntries([
      incrementHandlerFromInitial,
      incrementHandlerFromCounterIncremented,
      decrementHandlerFromCounterIncremented,
      incrementHandlerFromCounterDecremented,
    ]);
    return transitions;
  }
}
