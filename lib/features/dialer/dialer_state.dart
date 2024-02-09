part of 'dialer_bloc.dart';

@immutable
class DialerState extends Equatable {
  final String enteredNumber;

  const DialerState.initial({
    this.enteredNumber = "",
  });

  const DialerState({
    required this.enteredNumber,
  });

  @override
  List<Object?> get props => [
    enteredNumber
  ];

  @override
  bool? get stringify => true;
}


