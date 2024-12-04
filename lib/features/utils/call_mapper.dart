import 'dart:developer';
import 'package:exolve_voice_sdk/call/call_state.dart';
import 'package:flutter_voice_example/features/call/call_bloc.dart';
import 'package:exolve_voice_sdk/call/call.dart';

class CallMapper {
  static CallItemState toPresenter({ required Call mappied , CallItemState? oldState }) {
    log("CallMapper: toPresenter: mappied call = ${mappied.toString()}, id = ${mappied.id}"
        "\n  number = ${mappied.number}, formattedNumber = ${mappied.formattedNumber}, active = ${mappied.callState == CallState.connected} \n"
        " muted = ${mappied.isMuted}"
        " isOut = ${mappied.isOutDirection} \n  isInCOnf = ${mappied.isInConference}"
        " callstate = ${mappied.callState}");
    return CallItemState(
      callId: mappied.id ?? "none",
      number: mappied.number ?? "none",
      formattedNumber: mappied.formattedNumber ?? "none",
      active: mappied.callState == CallState.connected,
      muted: mappied.isMuted ?? false,
      isOutDirection: mappied.isOutDirection ?? false,
      isInConference: mappied.isInConference ?? false,
      callState: mappied.callState ?? CallState.error,
      startTime: oldState != null ? oldState.startTime : -1,
      qualityRating: oldState != null ? oldState.qualityRating : -1,
    );

  }
}