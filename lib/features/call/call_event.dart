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

class DtmfKeyboardStateChangedEvent extends ScreenEvent {
  CallScreenState state;
  DtmfKeyboardState dtmfKeyboardState;
  DtmfKeyboardStateChangedEvent({required this.state, required this.dtmfKeyboardState});
  @override
  Emitter<CallScreenState>? emitter;

  @override
  handle() {
    log("call_event: Dtmf state is = $dtmfKeyboardState, current state is ${state.dtmfKeyboardState}, emitter = ${emitter.hashCode}");
    //emitter!(CallScreenState.copy(copied: state, selectedCallId: state.selectedCallId, dtmfKeyboardState: dtmfKeyboardState));
    emitter!(CallScreenState.copy(
        copied: state,
        selectedCallId: state.selectedCallId,
        dtmfKeyboardState: dtmfKeyboardState,
        enteredDtmfSequence: ""
    ));

  }

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

}

class SpeakerScreenEvent extends ScreenEvent {
  @override
  Emitter<CallScreenState>? emitter;
  final CallScreenState state;
  SpeakerScreenEvent({required this.state});

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() {
    log("call_event: SpeakerScreenEvent: emitter = ${emitter.hashCode}");
    emitter!(CallScreenState.copy(copied: state, speaker: !state.speaker, selectedCallId: state.selectedCallId));
    TelecomManager().setSpeaker(setSpeakerOn: !state.speaker);
  }
}

class TransferButtonClickedEvent extends ScreenEvent {
  final CallScreenState state;
  TransferButtonClickedEvent({required this.state});

  @override
  Emitter<CallScreenState>? emitter;

  @override
  setEmitter(Emitter<CallScreenState> emitter) {
    this.emitter = emitter;
  }

  @override
  handle() async {
    log("call_event: TransferEvent:");
    final status =  await Permission.contacts.request();
    if(status.isGranted){
      log("call_event: TransferEvent: contact permissions is granted");
      Contact? contact = await FlutterContactPicker().selectContact();
      TelecomManager().transfer(
          callId: state.selectedCallId ?? "",
          targetNumber: contact?.phoneNumbers?.first.replaceAll(RegExp(r'[^0-9]'),'') ?? "none"
      );
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

class TelecomEvent implements Event{
  final CallEvent event;
  TelecomEvent({required this.event}) {
    log('TelecomEvent emerged: Event $event for ${event.call.toString()}');
  }
}
