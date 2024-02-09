part of 'bottom_navigation_bloc.dart';

class BottomNavigationState implements Equatable {
  final int currentIndex;
  final bool shouldShowNavBar;
  const BottomNavigationState({required this.currentIndex, required this.shouldShowNavBar});
  const BottomNavigationState.initial() :
    currentIndex = 0,
    shouldShowNavBar = true;
  @override
  List<Object> get props => [currentIndex];

  @override
  bool? get stringify => true;
}