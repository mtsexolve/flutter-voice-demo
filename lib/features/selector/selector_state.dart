part of 'selector_bloc.dart';

enum SelectorOverride {
  none (0),   // show Dialer or CallScreen with normal logic
  dialer (1); // show Dialer to place new call

  const SelectorOverride(this.value);
  final int value;
}

@immutable
class SelectorState extends Equatable {
  final bool hasOngoingCall;
  final SelectorOverride selectorOverride;

  const SelectorState.initial({
    required this.hasOngoingCall,
    this.selectorOverride = SelectorOverride.none
  });

  const SelectorState({
    required this.hasOngoingCall,
    required this.selectorOverride
  });

  @override
  List<Object?> get props => [
    hasOngoingCall,
    selectorOverride
  ];

  @override
  bool? get stringify => true;
}


