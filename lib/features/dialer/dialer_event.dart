part of 'dialer_bloc.dart';

@immutable
abstract class DialerEvent {}

class DialerButtonPressedEvent extends DialerEvent {
  final String digit;
  DialerButtonPressedEvent({required this.digit});
}

class CreateCallEvent extends DialerEvent {}

class RemoveDigitEvent extends DialerEvent {}

class RemoveAllDigitsEvent extends DialerEvent {}

