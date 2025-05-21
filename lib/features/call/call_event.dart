part of 'call_bloc.dart';

abstract class Event {}

abstract class ScreenEvent implements ScreenEventHandler<CallScreenState>, Event{}



class UnMuteScreenEvent extends ScreenEvent {
  @override
  Emitter<CallScreenState>? emitter;
  final CallScreenState state;
  final String callId;
  UnMuteScreenEvent({required this.callId, required this.state});

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() {
    log("call_event: UnmuteScreenEvent: callId: $callId");
    emitter!(CallScreenState.copy(
      copied: state,
      selectedCallId: state.selectedCallId,
      calls: state.calls.map<CallItemState>((item) {
        return callId == item.callId
            ? CallItemState.copy(copied: item, muted: !item.muted)
            : CallItemState.copy(copied: item);
        }).toList(),
      ));
    TelecomManager().unmute(callId: callId);
  }
}

class MuteScreenEvent extends ScreenEvent {
  @override
  Emitter<CallScreenState>? emitter;
  final CallScreenState state;
  final String callId;
  MuteScreenEvent({required this.callId, required this.state});

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() {
    log("call_event: MuteScreenEvent: callId: $callId");
    emitter!(CallScreenState.copy(
      copied: state,
      selectedCallId: state.selectedCallId,
      calls: state.calls.map<CallItemState>((item) {
        return callId == item.callId
            ? CallItemState.copy(copied: item, muted: !item.muted)
            : CallItemState.copy(copied: item);
      }).toList(),
    ));
    TelecomManager().mute(callId: callId);
  }
}

class DtmfKeyboardKeyPressedEvent extends ScreenEvent {
  CallScreenState state;
  @override
  Emitter<CallScreenState>? emitter;
  final String sequence;
  final String callId;
  DtmfKeyboardKeyPressedEvent({required this.callId, required this.sequence, required this.state});

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() {
    log("call_event: DtmfScreenEvent: callId: $callId");
    emitter!(CallScreenState.copy(copied: state, selectedCallId: state.selectedCallId, enteredDtmfSequence: state.enteredDtmfSequence + sequence));
    TelecomManager().sendDtmf(callId: callId, sequence: sequence);
  }
}

class CallScreenViewChangedEvent extends ScreenEvent {
  CallScreenState state;
  CallScreenView callScreenView;
  CallScreenViewChangedEvent({required this.state, required this.callScreenView});
  @override
  Emitter<CallScreenState>? emitter;

  @override
  handle() {
    log("call_event: CallScreenViewChangedEvent state is = $callScreenView, current state is ${state.callScreenView}, emitter = ${emitter.hashCode}");
    //emitter!(CallScreenState.copy(copied: state, selectedCallId: state.selectedCallId, callScreenView: callScreenView));
    emitter!(CallScreenState.copy(
        copied: state,
        selectedCallId: state.selectedCallId,
        callScreenView: callScreenView,
        enteredDtmfSequence: ""
    ));

  }

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

}

class LoadChangedAudioRoutes extends Event {}

class AudioRouteChangedScreenEvent extends ScreenEvent {
  @override
  Emitter<CallScreenState>? emitter;
  final CallScreenState state;
  final String name;
  AudioRouteChangedScreenEvent({required this.state, required this.name});

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() {
    log("call_event: AudioRouteChangedScreenEvent: emitter = ${emitter.hashCode}");
    if (state.audioRoutes != null) {
      final index = state.audioRoutes!.indexWhere((audioRouteData) => audioRouteData.name == name);
      if (index >= 0) {
        TelecomManager().setAudioRoute(audioRouteData: state.audioRoutes![index]);
      }
    }
  }
}

class TerminateScreenEvent extends ScreenEvent {
  @override
  Emitter<CallScreenState>? emitter;
  final String callId;
  TerminateScreenEvent({required this.callId});

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() {
    log("call_event: TerminateScreenEvent: callId: $callId");
    TelecomManager().terminate(callId: callId);
  }
}

class HoldScreenEvent extends ScreenEvent {
  @override
  Emitter<CallScreenState>? emitter;
  final String callId;
  HoldScreenEvent({required this.callId,});

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() {
    log("call_event: HoldScreenEvent: callId: $callId");
    TelecomManager().hold(callId: callId);
  }
}

class ResumeScreenEvent extends ScreenEvent {
  @override
  Emitter<CallScreenState>? emitter;
  final String callId;
  ResumeScreenEvent({required this.callId});

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() {
    log("call_event: ResumeScreenEvent: callId: $callId");
    TelecomManager().resume(callId: callId);
  }
}

class SelectScreenEvent extends ScreenEvent {
  @override
  Emitter<CallScreenState>? emitter;
  final CallScreenState state;
  final String callId;
  SelectScreenEvent({required this.callId, required this.state});

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() {
    log("call_event: SelectScreenEvent: callId: $callId");
    emitter!(CallScreenState.copy(copied: state, selectedCallId: callId));
  }
}

class AcceptScreenEvent extends ScreenEvent {
  @override
  Emitter<CallScreenState>? emitter;
  final String callId;
  AcceptScreenEvent({required this.callId});

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() {
    log("call_event: AcceptScreenEvent: callId: $callId");
    TelecomManager().accept(callId: callId);
  }
}

class TimerScreenEvent extends ScreenEvent {
  @override
  Emitter<CallScreenState>? emitter;
  final CallScreenState state;
  TimerScreenEvent({required this.state});

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() async {
    log("call_event: TimerScreenEvent");
    var futures = <Future>[];
    for (var call in state.calls) {
      futures.add(TelecomManager().getStatistics(callId: call.callId));
    }
    var stats = await Future.wait(futures);
    var calls = <CallItemState>[];
    for (var i = 0; i < stats.length; i++) {
      if (stats[i] == null) {
        calls.add(CallItemState.copy(copied: state.calls[i]));
      } else {
        log("call_event: TimerScreenEvent ${state.calls[i]} Call stats." +
            "maxRating = ${stats[i].maxRating} " +
            "minRating = ${stats[i].minRating} " +
            "averageRating = ${stats[i].averageRating} " +
            "currentRating = ${stats[i].currentRating} " +
            "sentPackets = ${stats[i].sentPackets} " +
            "receivedPackets = ${stats[i].receivedPackets} " +
            "lostPackets = ${stats[i].lostPackets} ");
        calls.add(CallItemState.copy(
            copied: state.calls[i], qualityRating: stats[i].currentRating));
      }
    }
    emitter!(CallScreenState.copy(
        copied: state, selectedCallId: state.selectedCallId, calls: calls));
  }
}

class TelecomEvent implements Event{
  final CallEvent event;
  TelecomEvent({required this.event}) {
    log('TelecomEvent emerged: Event $event for ${event.call.toString()}');
  }
}
