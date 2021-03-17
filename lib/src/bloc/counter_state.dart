/* part of 'counter_bloc.dart';

@immutable
abstract class CounterState {
  final int count;

  CounterState(this.count);
}

class CounterInitial extends CounterState {
  CounterInitial(int initialCount) : super(initialCount);
}

class CounterIncremented extends CounterState {
  final int consecutivesAdditionsOperations;
  CounterIncremented(int count, this.consecutivesAdditionsOperations)
      : super(count);
}

class CounterDecremented extends CounterState {
  CounterDecremented(int count) : super(count);
}
 */