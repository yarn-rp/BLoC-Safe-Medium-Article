part of 'counter_bloc.dart';

MapEntry<Edge, TransitionFunction> incrementHandlerFromInitial = MapEntry(
  Edge(IncrementCounter, CounterInitial),
  (event, state) async* {
    int currentAdditionsOperations =
        state is CounterIncremented ? state.consecutivesAdditionsOperations : 0;
    yield CounterIncremented(state.count + 1, currentAdditionsOperations + 1);
  },
);

MapEntry<Edge, TransitionFunction> incrementHandlerFromCounterIncremented =
    MapEntry(
  Edge(IncrementCounter, CounterIncremented),
  (event, state) async* {
    int currentAdditionsOperations =
        state is CounterIncremented ? state.consecutivesAdditionsOperations : 0;
    yield CounterIncremented(state.count + 1, currentAdditionsOperations + 1);
  },
);

MapEntry<Edge, TransitionFunction> incrementHandlerFromCounterDecremented =
    MapEntry(
  Edge(IncrementCounter, CounterDecremented),
  (event, state) async* {
    int currentAdditionsOperations =
        state is CounterIncremented ? state.consecutivesAdditionsOperations : 0;
    yield CounterIncremented(state.count + 1, currentAdditionsOperations + 1);
  },
);

MapEntry<Edge, TransitionFunction> decrementHandlerFromCounterIncremented =
    MapEntry(
  Edge(DecrementCounter, CounterIncremented),
  (event, state) async* {
    /// calculates the floor number of consecutivesAdditionsOperations divided by 2
    int decrement =
        ((state as CounterIncremented).consecutivesAdditionsOperations / 2)
            .floor();
    yield CounterDecremented(state.count - decrement);
  },
);
