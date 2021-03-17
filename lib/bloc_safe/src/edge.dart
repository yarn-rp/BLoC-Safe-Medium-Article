part of 'bloc_safe.dart';

class Edge<TypeEvent extends Type, TypeState extends Type> {
  final TypeEvent tEvent;
  final TypeState tState;

  Edge(this.tEvent, this.tState);
}
