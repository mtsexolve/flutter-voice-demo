import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../core/telecom/telecom_manager_interface.dart';

part 'dialer_event.dart';
part 'dialer_state.dart';

class DialerBloc extends Bloc<DialerEvent, DialerState> {

  final ITelecomManager telecomManager;
  DialerBloc({
    required this.telecomManager
  }) : super(const DialerState.initial()) {
    on<DialerButtonPressedEvent>((event, emit) {_addDigitToEnteredNumber(event.digit, emit);});
    on<RemoveDigitEvent>((event, emit) {_removeDigitFromEnteredNumber(emit);});
    on<RemoveAllDigitsEvent>((event, emit) {_removeAllDigitsFromEnteredNumber(emit);});
    on<CreateCallEvent>((event, emit) {_call(state.enteredNumber);});
  }

  _addDigitToEnteredNumber(String digit, Emitter emit) {
    emit(
      DialerState(
        enteredNumber: state.enteredNumber + digit,
      )
    );
  }

  _removeDigitFromEnteredNumber(Emitter emit) {
    emit(
      DialerState(
        enteredNumber: state.enteredNumber.substring(0, state.enteredNumber.length - 1),
      )
    );
  }

  _removeAllDigitsFromEnteredNumber(Emitter emit) {
    emit(
      DialerState(
        enteredNumber: state.enteredNumber.replaceAll(state.enteredNumber, ""),
      )
    );
  }

  _call(String number) {
    telecomManager.makeCall(number: number);
    log('dialerBloc: call($number)');
  }

}
