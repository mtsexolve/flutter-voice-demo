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
  final List<AudioRouteData>? audioRoutes;
  final CallScreenView callScreenView;
  final String enteredDtmfSequence;

  CallScreenState(
    this._calls, {
    required this.selectedCallId,
    required this.audioRoutes,
    required this.callScreenView,
    required this.enteredDtmfSequence,
  });

  CallScreenState.copy({
      required this.selectedCallId,
      required CallScreenState copied,
      List<AudioRouteData>? audioRoutes,
      CallScreenView? callScreenView,
      List<CallItemState>? calls,
      String? enteredDtmfSequence,
    }
  ) : audioRoutes = audioRoutes ?? copied.audioRoutes,
      _calls = calls ?? copied.calls,
      callScreenView = callScreenView ?? copied.callScreenView,
      enteredDtmfSequence = enteredDtmfSequence ?? copied.enteredDtmfSequence {
        log("CallScreenState.copy: preffered call view state = $callScreenView, copied = ${copied.callScreenView} ");
      }


}

enum CallScreenView{ call, dtmf, transfer}

