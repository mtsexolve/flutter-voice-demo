import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:exolve_voice_sdk/call/call_event.dart';
import 'package:exolve_voice_sdk/call/call_user_action.dart';
import 'package:exolve_voice_sdk/call/call_pending_event.dart';
import '../../core/telecom/telecom_manager_interface.dart';
import 'package:meta/meta.dart';
import 'package:flutter_voice_example/features/utils/request_permission.dart';
import 'package:permission_handler/permission_handler.dart';

part 'selector_event.dart';
part 'selector_state.dart';

class SelectorBloc extends Bloc<SelectorEvent, SelectorState> {
  StreamSubscription<CallEvent>? _eventSubscription;
  final ITelecomManager telecomManager;
  SelectorBloc({required this.telecomManager})
      : super(SelectorState.initial(
            hasOngoingCall: telecomManager.getCalls().isNotEmpty)) {
    on<BackToCallScreenEvent>((event, emit) {
      _backToCallScreen(emit);
    });
    on<SetSelectorOverride>((event, emit) {
      _setSelectorOverride(emit, event.selectorOverride);
    });

    _eventSubscription =
        telecomManager.subscribeOnCallEvents()?.listen((event) {
      if (event is CallNewEvent) {
        add(const BackToCallScreenEvent());
        return;
      }

      if (event is CallErrorEvent) {
        Fluttertoast.showToast(
            msg: "Error: \"${event.message}\" (${event.error})",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 14.0);
      }

      if (event is CallUserActionRequiredEvent) {
        if (event.userAction == CallUserAction.enableLocationProvider &&
            event.pendingEvent == CallPendingEvent.acceptCall) {
          return;
        }
        checkPermission(Permission.locationWhenInUse).then((status){
          String toastMessage;
          switch (event.userAction) {
            case CallUserAction.needsLocationAccess:
              toastMessage =
                  "No location access for ${(event.pendingEvent == CallPendingEvent.acceptCall) ? "accept" : "answering"} call.";
              break;
            case CallUserAction.enableLocationProvider:
              toastMessage =
                  "Disabled access to geolocation in notification panel";
              break;
            default:
              toastMessage = "action is null";
              break;
          }
          if(status != PermissionStatus.granted || event.userAction == CallUserAction.enableLocationProvider){
            Fluttertoast.showToast(
            msg: toastMessage,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 14.0);
          } 
        });
      }

      final haveCalls = telecomManager.getCalls().isNotEmpty;
      if (state.hasOngoingCall != haveCalls) {
        emit(SelectorState(
            hasOngoingCall: haveCalls,
            selectorOverride: state.selectorOverride));
      }
    });
  }

  _setSelectorOverride(Emitter emit, SelectorOverride selectorOverride) {
    emit(SelectorState(
        hasOngoingCall: state.hasOngoingCall,
        selectorOverride: selectorOverride));
  }

  _backToCallScreen(Emitter emit) {
    log('selector_bloc back to call screen');
    emit(SelectorState(
        hasOngoingCall: telecomManager.getCalls().isNotEmpty,
        selectorOverride: SelectorOverride.none));
  }

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    return super.close();
  }
}
