part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {}

class ActivateSipAccountEvent extends AccountEvent{}

class RegistrationReceivedEvent extends AccountEvent{
  final RegistrationEvent state;
  RegistrationReceivedEvent({required this.state});
}

class RegistrationReceivedState extends AccountEvent{
  final RegistrationState state;
  RegistrationReceivedState({required this.state});
}

class DeactivateSipAccountEvent extends AccountEvent {}

class DeactivateAccountEvent extends AccountEvent {}

class AccountDataIsLoadedEvent extends AccountEvent {
  final Account data;
  AccountDataIsLoadedEvent({required this.data});
}

class TextFieldChangedEvent extends AccountEvent {
  final String name;
  final String inputText;
  TextFieldChangedEvent({required this.name, required this.inputText});
}

class PushTokenEvent extends AccountEvent{
  final String pushToken;
  PushTokenEvent({required this.pushToken});
}