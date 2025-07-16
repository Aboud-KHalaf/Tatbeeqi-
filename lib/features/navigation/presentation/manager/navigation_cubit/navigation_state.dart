import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  final int index;
  final int timestamp;

  NavigationState(this.index) : timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [index, timestamp];
}

class NavigationInitial extends NavigationState {
  NavigationInitial() : super(0);
}

class NavigationIndexChanged extends NavigationState {
  NavigationIndexChanged(super.index);
}