import 'dart:developer';

enum TelecomEventType {
  callNew,
  callHold,
  callResume,
  callTerminate,
  callMute
}

class TelecomEvent {
  final String callId;
  final TelecomEventType type;

  TelecomEvent(this.callId, this.type) {
    log('TelecomEvent emerged: $type $callId');
  }
}