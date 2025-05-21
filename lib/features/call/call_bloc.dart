import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:exolve_voice_sdk/call/call_statistics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exolve_voice_sdk/call/call_state.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:flutter_voice_example/core/common_ui/event_handler.dart';
import 'package:flutter_voice_example/core/telecom/telecom_manager.dart';
import 'package:flutter_voice_example/core/telecom/telecom_manager_interface.dart';
import 'package:flutter_voice_example/features/utils/call_mapper.dart';
import 'package:exolve_voice_sdk/communicator/audioroute/audioroute.dart';
import 'package:exolve_voice_sdk/communicator/audioroute/audioroute_event.dart';
import 'package:exolve_voice_sdk/call/call_event.dart';
import 'package:permission_handler/permission_handler.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<Event, CallScreenState> {
  final ITelecomManager telecomManager;
  StreamSubscription<CallEvent>? _eventSubscription;
  StreamSubscription<AudioRouteEvent>? _audioRouteEventSubscription;
  Timer? _everySecond;


  CallBloc({required this.telecomManager})
    : super(CallScreenState(
      [...telecomManager.getCalls().map((element) => CallMapper.toPresenter(mappied: element))],
      selectedCallId: telecomManager.getCalls().first.id,
      audioRoutes: null,
      callScreenView: CallScreenView.call,
      enteredDtmfSequence: ""
    )) {

    on<ScreenEvent>((event, emit) async { event.setEmitter(emit); await event.handle();});
    on<TelecomEvent>((event, emit) {_onTelecomEvent(event.event, emit);});

    var isAudioRoutesFirstAppeared = true;

    on<LoadChangedAudioRoutes>((event, emit) async { 
      final audioRoutes = await telecomManager.getAudioRoutes();

      if((audioRoutes?.isNotEmpty ?? false) && isAudioRoutesFirstAppeared) {
        var bluetoohAudioRoutes = audioRoutes!.where((audioRouteData) => audioRouteData.route == AudioRoute.bluetooth);
        if (bluetoohAudioRoutes.isNotEmpty) {
          final isBluetoothDisabled = bluetoohAudioRoutes.every((audioRouteData) => audioRouteData.isActive == false);
          if (isBluetoothDisabled) {
            TelecomManager().setAudioRoute(audioRouteData: bluetoohAudioRoutes.first);
          }
        }
        isAudioRoutesFirstAppeared = false;
      }

      emit(CallScreenState.copy(
          copied: state,
          selectedCallId: state.selectedCallId,
          audioRoutes: audioRoutes)
      );
    });

    _eventSubscription = telecomManager.subscribeOnCallEvents()?.listen((event) {
      add(TelecomEvent(event: event));
    });
    _audioRouteEventSubscription = telecomManager.subscribeOnAudioRouteEvents()?.listen((event) {
      log("call_bloc: subscribeOnAudioRouteEvents");
      if(event is AudioRouteChangedEvent){
        for(var i = 0; i < event.routes.length; i++){
          log('call_bloc: subscribeOnAudioRouteEvents: ${event.routes[i].route} ${event.routes[i].name} ${event.routes[i].isActive}');
        }
        add(LoadChangedAudioRoutes());
      }
    });

    add(LoadChangedAudioRoutes());

    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      add(TimerScreenEvent(state: state));

      if(state.audioRoutes?.isEmpty ?? true) {
        add(LoadChangedAudioRoutes());
      }
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
        audioRoutes: state.audioRoutes,
        calls: _updateCallsList(event),
        callScreenView: event is CallNewEvent
            ? CallScreenView.call
            : (event is CallDisconnectedEvent
              ? (event.call.id == state.selectedCallId ? CallScreenView.call : state.callScreenView)
              : state.callScreenView),
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
      final replaceableIndex = state.calls.indexWhere((element) => element.callId == event.call.id);
      if( replaceableIndex != -1 ) {
        newList[replaceableIndex] = CallMapper.toPresenter(mappied: event.call,oldState: newList[replaceableIndex]);
        if( event is CallConnectedEvent && newList[replaceableIndex].startTime < 0 ) {
          newList[replaceableIndex] = CallItemState.copy(copied: newList[replaceableIndex], startTime: DateTime.now().millisecondsSinceEpoch);
        }
      } else {
        newList.add(CallMapper.toPresenter(mappied: event.call));
      }
    }
    log('call_bloc: onTelecomEvent: updateCallsList: after update ${newList.toString()}');
    return newList;
  }

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    _audioRouteEventSubscription?.cancel();
    _everySecond?.cancel();
    log('close hash = ${super.hashCode}');
    return super.close();
  }

}
