import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edge.dart';

/// {@template bloc}
/// Takes a `Stream` of `Events` as input
/// and transforms them into a `Stream` of `States` as output.
/// It's build on top of BLoC.
/// {@endtemplate}
abstract class BlocSafe<Event, State> extends Bloc<Event, State> {
  BlocSafe(State initialState) : super(initialState);

  @protected
  Map<Edge, Stream<State> Function(Event event, State state)>
      get _transitions => buildTransitions();

  @protected
  bool _isValidEdge(Edge edge, State state, Event event) {
    print('Es valida la arista:(${edge.tEvent}, ${edge.tState})?');
    print(
        'Voy a comparar las aristas: ${edge.tEvent} == ${event.runtimeType} = ${edge.tEvent == event.runtimeType}');
    print(
        'Voy a comparar los estados: ${edge.tState} == ${state.runtimeType} = ${edge.tState == state.runtimeType}');
    print(edge.tEvent == event.runtimeType && edge.tState == state.runtimeType);
    //TODO : replace this code with reflection to work with inherited classes
    return edge.tEvent == event.runtimeType && edge.tState == state.runtimeType;
  }

  /// Must be implemented when a class extends [BlocSafe].
  /// When an event is emmited, [mapEventToState] will try to get the correct edge to make a transition.
  /// If you don't want this behavior, just override [mapEventToState] like in [Bloc].
  Map<Edge, Stream<State> Function(Event event, State state)>
      buildTransitions();

  Stream<State> _walkFromState(
    Event event,
  ) async* {
    State currentState = state;
    for (var transition in _transitions.entries) {
      if (_isValidEdge(transition.key, currentState, event)) {
        yield* transition.value(event, currentState);
      }
    }
  }

  @override
  Stream<State> mapEventToState(
    Event event,
  ) =>
      _walkFromState(event);
}
