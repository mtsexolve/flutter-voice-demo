part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();
  @override
  List<Object> get props => [];
}

class TabChangedEvent extends BottomNavigationEvent {
  final int newIndex;
  const TabChangedEvent(this.newIndex);
  @override
  List<Object> get props => [newIndex];
}

class ShouldShowNavBarEvent extends BottomNavigationEvent {
  final bool shouldShowNavBar;
  const ShouldShowNavBarEvent({required this.shouldShowNavBar});
  @override
  List<Object> get props => [shouldShowNavBar];
}
