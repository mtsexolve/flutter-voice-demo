import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(const BottomNavigationState.initial()){
    on<TabChangedEvent>((event, emit) {
      emit(BottomNavigationState(
          currentIndex: event.newIndex,
          shouldShowNavBar: state.shouldShowNavBar
      ));
    });

    on<ShouldShowNavBarEvent>((event, emit) {
      emit(BottomNavigationState(
          currentIndex: state.currentIndex,
          shouldShowNavBar: event.shouldShowNavBar
      ));
    });
  }
}
