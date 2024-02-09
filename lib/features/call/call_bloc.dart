import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exolve_voice_sdk/call/call_state.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_voice_example/core/common_ui/event_handler.dart';
import 'package:flutter_voice_example/core/telecom/telecom_manager.dart';
import 'package:flutter_voice_example/core/telecom/telecom_manager_interface.dart';
import 'package:flutter_voice_example/features/utils/call_mapper.dart';
import 'package:exolve_voice_sdk/call/call_event.dart';
import 'package:permission_handler/permission_handler.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<Event, CallScreenState> {
  final ITelecomManager telecomManager;
  StreamSubscription<CallEvent>? _eventSubscription;

  CallBloc({required this.telecomManager})
    : super(CallScreenState(
      [...telecomManager.getCalls().map((element) => CallMapper.toPresenter(mappied: element))],
      selectedCallId: telecomManager.getCalls().first.id,
      speaker: false,
      dtmfKeyboardState: DtmfKeyboardState.inactive,
      enteredDtmfSequence: ""
    )) {
    on<ScreenEvent>((event, emit) {event..setEmitter(emit)..handle();});
    on<TelecomEvent>((event, emit) {_onTelecomEvent(event.event, emit);});
    _eventSubscription = telecomManager.subscribeOnCallEvents()?.listen((event) {
      add(TelecomEvent(event: event));
    });
  }

  _onTelecomEvent(CallEvent event, Emitter emitter) {
    emitter(
      CallScreenState.copy(
        copied: state,
        selectedCallId: event is CallNewEvent
          ? event.call.id
          : (event is CallDisconnectedEvent
            ? (event.call.id == state.selectedCallId ? telecomManager.getCalls().lastOrNull?.id : state.selectedCallId)
            : state.selectedCallId),
        speaker: state.speaker,
        calls: _updateCallsList(event),
        dtmfKeyboardState: event is CallNewEvent
            ? DtmfKeyboardState.inactive
            : (event is CallDisconnectedEvent
              ? (event.call.id == state.selectedCallId ? DtmfKeyboardState.inactive : state.dtmfKeyboardState)
              : state.dtmfKeyboardState),
        enteredDtmfSequence: event is CallNewEvent
            ? ""
            : (event is CallDisconnectedEvent
              ? (event.call.id == state.selectedCallId ? "" : state.enteredDtmfSequence)
              : state.enteredDtmfSequence),
    ));
    log('call_bloc: onTelecomEvent: after emit: state.list =${state.calls} emitter=${emitter.hashCode}');
  }

  List<CallItemState> _updateCallsList(CallEvent event) {
    final newList = List<CallItemState>.from(state.calls);
    if (event is CallDisconnectedEvent || event is CallErrorEvent) {
      newList.removeWhere((element) => element.callId == event.call.id);
    } else {
      state.calls.indexWhere((element) => element.callId == event.call.id) != -1
          ? (){
        final replaceableIndex =
            newList.indexWhere((element) => element.callId == event.call.id);
        newList[replaceableIndex] = CallMapper.toPresenter(mappied: event.call);
        }() : (){
          newList.add(CallMapper.toPresenter(mappied: event.call));
        }();
    }
    log('call_bloc: onTelecomEvent: updateCallsList: after update ${newList.toString()}');
    return newList;
  }

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    log('close hash = ${super.hashCode}');
    return super.close();
  }

}
