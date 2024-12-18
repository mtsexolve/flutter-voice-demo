part of 'call_bloc.dart';

class CallItemState {

  final String callId;
  final String number;
  final String formattedNumber;
  final bool? active;
  final bool muted;
  final bool isOutDirection;
  final bool isInConference;
  final CallState callState;
  final int startTime;
  final double qualityRating;

  const CallItemState({
    required this.callId,
    required this.number,
    required this.formattedNumber,
    required this.active,
    required this.muted,
    required this.isOutDirection,
    required this.isInConference,
    required this.callState,
    required this.startTime,
    required this.qualityRating,
  });

  CallItemState.copy({
      required CallItemState copied,
      String? callId,
      String? number,
      String? formattedNumber,
      bool? active,
      bool? muted,
      bool? isInConference,
      bool? isOutDirection,
      CallState? callState,
      int? startTime,
      double? qualityRating,
    }) : callId = callId ?? copied.callId,
      number = number ?? copied.number,
      formattedNumber = formattedNumber ?? copied.formattedNumber,
      active = active ?? copied.active,
      muted = muted ?? copied.muted,
      isOutDirection = isOutDirection ?? copied.isOutDirection,
      isInConference = isInConference ?? copied.isInConference,
      callState = callState ?? copied.callState,
      startTime = startTime ?? copied.startTime,
      qualityRating = qualityRating ?? copied.qualityRating;
}

class CallScreenState {
  final List<CallItemState> _calls;
  List<CallItemState> get calls => List.unmodifiable(_calls);

  final String? selectedCallId;
  final bool speaker;
  final DtmfKeyboardState dtmfKeyboardState;
  final String enteredDtmfSequence;

  CallScreenState(
    this._calls, {
    required this.selectedCallId,
    required this.speaker,
    required this.dtmfKeyboardState,
    required this.enteredDtmfSequence,
  });

  CallScreenState.copy({
      required this.selectedCallId,
      required CallScreenState copied,
      bool? speaker,
      DtmfKeyboardState? dtmfKeyboardState,
      List<CallItemState>? calls,
      String? enteredDtmfSequence,
    }
  ) : speaker = speaker ?? copied.speaker,
      _calls = calls ?? copied.calls,
      dtmfKeyboardState = dtmfKeyboardState ?? copied.dtmfKeyboardState,
      enteredDtmfSequence = enteredDtmfSequence ?? copied.enteredDtmfSequence {
        log("CallScreenState.copy: preffered dtmf state = $dtmfKeyboardState, copied = ${copied.dtmfKeyboardState} ");
      }


}

enum DtmfKeyboardState{ active, inactive}

