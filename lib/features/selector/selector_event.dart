part of 'selector_bloc.dart';

@immutable
abstract class SelectorEvent {
  const SelectorEvent();
}

class BackToCallScreenEvent extends SelectorEvent {
  const BackToCallScreenEvent();
}

class SetSelectorOverride extends SelectorEvent {
  final SelectorOverride selectorOverride;
  const SetSelectorOverride({required this.selectorOverride});
}