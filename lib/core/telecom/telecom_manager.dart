import 'dart:async';
import 'dart:developer';
import 'package:exolve_voice_sdk/call/call_event.dart';
import 'package:exolve_voice_sdk/call/call_pending_event.dart';
import 'package:exolve_voice_sdk/call/call_user_action.dart';
import 'package:exolve_voice_sdk/communicator/call_client.dart';
import 'package:exolve_voice_sdk/communicator/configuration.dart';
import 'package:exolve_voice_sdk/communicator/registration/registration_event.dart';
import 'package:exolve_voice_sdk/communicator/registration/registration_state.dart';
import 'package:exolve_voice_sdk/communicator/audioroute/audioroute.dart';
import 'package:exolve_voice_sdk/communicator/audioroute/audioroute_event.dart';
import 'package:exolve_voice_sdk/communicator/version_info.dart';
import 'package:exolve_voice_sdk/call/call_statistics.dart';
import 'package:flutter_voice_example/core/store/account_repository.dart';
import 'package:flutter_voice_example/core/store/settings_repository.dart';
import 'package:flutter_voice_example/core/telecom/telecom_manager_interface.dart';
import 'package:flutter_voice_example/features/utils/request_permission.dart';
import 'package:exolve_voice_sdk/call/call.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/account.dart';
import '../models/settings.dart';

class TelecomManager implements ITelecomManager {

  final CallClient callClient = CallClient();
  final StreamController<CallEvent> _callStreamController = StreamController<CallEvent>();
  final StreamController<RegistrationEvent> _registrationStreamController = StreamController<RegistrationEvent>();
  final StreamController<String> _pushTokenStreamController = StreamController<String>();
  final StreamController<AudioRouteEvent> _audioRouteStreamController = StreamController<AudioRouteEvent>();
  Stream<CallEvent>? _callsStream;
  Stream<RegistrationEvent>? _registrationStream;
  Stream<String>? _pushTokenStream;
  Stream<AudioRouteEvent>? _audioRoutesStream;
  final List<Call> _calls = [];
  StreamSubscription<CallEvent>? callsSubscription;
  StreamSubscription<RegistrationEvent>? registrationSubscription;
  StreamSubscription<String>? pushTokenSubscription;
  StreamSubscription<AudioRouteEvent>? audioRoutesSubscription;

  static final TelecomManager _instance = TelecomManager.initial();
  factory TelecomManager() {
    return _instance;
  }

  TelecomManager.initial() {
    log('TelecomManager: initial, callsSubscription = $callsSubscription');
    configureSubscriptionOnCallsEvents();
    configureSubscriptionOnRegistrationEvents();
    configureSubscriptionOnPushTokenEvents();
    configureSubscriptionOnAudioRoutesEvents();
  }

  void configureSubscriptionOnRegistrationEvents() {
    registrationSubscription ??= callClient
      .subscribeOnRegistrationEvents()
      .listen((event) {
        log('TelecomManager: configure Subscription On Registration Events: listen: receive event = $event');
        _registrationStreamController.sink.add(event);
    });
    _registrationStream ??=_registrationStreamController.stream.asBroadcastStream();
  }

  void configureSubscriptionOnPushTokenEvents() {
    pushTokenSubscription ??= callClient
      .subscribeOnPushTokenEvents()
      .listen((token) {
        log('TelecomManager: token changed: $token');
        _pushTokenStreamController.sink.add(token);
      });
    _pushTokenStream ??= _pushTokenStreamController.stream.asBroadcastStream();
  }

  void configureSubscriptionOnCallsEvents() {
    callsSubscription ??= callClient
        .subscribeOnCallEvents()
        .listen((event) {
            log(
                'TelecomManager: configureSubscriptionOnCallsEvents: listen: receive event = $event'
                    ' id = ${event.call.id} with call state = ${event.call.callState}');
            handleCallEvent(event);
            _callStreamController.sink.add(event);
          });
    _callsStream ??= _callStreamController.stream.asBroadcastStream();
  }

  void configureSubscriptionOnAudioRoutesEvents() {
    audioRoutesSubscription ??= callClient
        .subscribeOnAudioRouteEvents()
        .listen((event) {
            log(
                'TelecomManager: configureSubscriptionOnAudioRoutesEvents: listen: receive event = $event');
            _audioRouteStreamController.sink.add(event);
          });
    _audioRoutesStream ??= _audioRouteStreamController.stream.asBroadcastStream();
  }

  @override
  List<Call> getCalls() {
    log('TelecomManager:  getCalls = ${List.unmodifiable(_calls)}');
    return List.unmodifiable(_calls);
  }

  @override
  Future<void> initializeCallClient({required Configuration configuration}) async {
    log('TelecomManager: initializeCallClient: configuration = $configuration');
    callClient.initializeCallClient(configuration: configuration);
    final calls = await callClient.getCallList();
    calls?.forEach((element) {updateCallList(call: element);});
    log('TelecomManager: initializeCallClient: getCallList = $calls');
  }

  @override
  Future<VersionInfo> getVersionInfo() async {
    log('TelecomManager: getVersionInfo');
    return callClient.getVersionInfo();
  }

  @override
  Future<void> register({required Account account}) async {
    log('TelecomManager: register: login ${account.login}, password ${account.password}');
    await unregister();
    await callClient.register(
        login: account.login ?? "",
        password: account.password ?? "",
    );
  }

  @override
  Future<void> unregister() async {
    log('TelecomManager: unregister');
    callClient.unregister();
  }

  @override
  Future<void> makeCall({required String number}) async {
    log('TelecomManager: makeCall to number = $number');
    callClient.makeCall(number: number);
  }

  @override
  Stream<RegistrationEvent>? subscribeOnRegistrationEvents() {
    log('TelecomManager: subscribeOnRegistrationEvents');
    return _registrationStream;
  }

  @override
  Stream<String>? subscribeOnPushTokenEvents() {
    log('TelecomManager: subscribeOnPushTokenEvents');
    return _pushTokenStream;
  }

  @override
  Stream<CallEvent>? subscribeOnCallEvents() {
    log('TelecomManager: subscribeOnCallEvents');
    return _callsStream;
  }

  @override
  Stream<AudioRouteEvent>? subscribeOnAudioRouteEvents() {
    log('TelecomManager: subscribeOnAudioRouteEvents');
    return _audioRoutesStream;
  }

  void handleCallEvent(CallEvent event) {
    if (event is CallErrorEvent) {
      log('TelecomManager: handleCallEvent: error');
      removeCallFromList(call: event.call);
      return;
    }

    if (event is CallDisconnectedEvent) {
      log('TelecomManager: handleCallEvent: disconnected duration = ${event.duration} isDisconnectedByUser = ${event.isDisconnectedByUser}');
      removeCallFromList(call: event.call);
      return;
    }

    if(event is CallUserActionRequiredEvent){
      log('TelecomManager: handleCallEvent: user action required');
      if (event.userAction == CallUserAction.needsLocationAccess && event.pendingEvent == CallPendingEvent.acceptCall) {
        requestPermission(Permission.locationWhenInUse).then((status){
          event.call.accept();
        });
      } else if (event.userAction == CallUserAction.enableLocationProvider && event.pendingEvent == CallPendingEvent.acceptCall) {
        event.call.accept();
      }
      return;
    }

    log('TelecomManager: handleCallEvent: $event');
    updateCallList(call: event.call);
  }

  void removeCallFromList({required Call call}) {
    _calls.removeWhere((element) => element.id == call.id);
    log('TelecomManager: removeFromCallList: call ${call.id}, ${_calls.length} calls');
  }

  void updateCallList({required Call call}) {
    int indexToReplace = _calls.indexWhere((item) => item.id == call.id);

    if (indexToReplace != -1) {
      log('TelecomManager: updateCallList: call is in the list ');
      _calls[indexToReplace] = call;
    } else {
      log('TelecomManager: updateCallList: call is not in the list ');
      _calls.add(call);
    }
    log('TelecomManager: updateCallList: call = $call'
        ' and newList =${_calls.hashCode}, indextoReplace = $indexToReplace');
  }

  @override
  Future<void> accept({required String callId}) async {
    log('TelecomManager: handleCallEvent: acceptCall $callId \n'
        'position in list is ${_calls.firstWhere((element) => element.id == callId)}');
    _calls.firstWhere((element) => element.id == callId).accept();
  }

  @override
  Future<void> addToConference({required String callId}) async {
    log('TelecomManager: handleCallEvent: addToConference $callId \n'
        'position in list is ${_calls.firstWhere((element) => element.id == callId)}');
    _calls.firstWhere((element) => element.id == callId).addToConference();
  }

  @override
  Future<void> createConference({required String callId, required String otherCallId}) async {
    log('TelecomManager: handleCallEvent: addToConference $callId and $otherCallId; \n '
        'position in list is ${_calls.firstWhere((element) => element.id == callId)} \n'
        'and position of second call is ${_calls.firstWhere((element) => element.id == otherCallId)}');
    _calls.firstWhere((element) => element.id == callId).createConference(otherCallId: otherCallId);
  }

  @override
  Future<void> removeFromConference({required String callId}) async {
    log('TelecomManager: handleCallEvent: removeFromConference $callId \n'
        'position in list is ${_calls.firstWhere((element) => element.id == callId)}');
    _calls.firstWhere((element) => element.id == callId).removeFromConference();
  }

  @override
  Future<void> sendDtmf({required String callId, required String sequence}) async {
    log('TelecomManager: handleCallEvent: send dtmf for call $callId and sequence = $sequence \n'
        'position in list is ${_calls.firstWhere((element) => element.id == callId)}');
    _calls.firstWhere((element) => element.id == callId).sendDtmf(sequence: sequence);
  }

  @override
  Future<CallStatistics?> getStatistics({required String callId}) async {
    log('TelecomManager: handleCallEvent: get statistics for $callId \n');
    return _calls.firstWhere((element) => element.id == callId).getStatistics();
  }

  @override
  Future<void> transfer({required String callId, required String targetNumber}) async {
    log('TelecomManager: handleCallEvent: transfer $callId to target = $targetNumber \n'
        'position in list is ${_calls.firstWhere((element) => element.id == callId)}');
    _calls.firstWhere((element) => element.id == callId).transfer(targetNumber: targetNumber);
  }

  @override
  Future<void> hold({required String callId}) async {
    log('TelecomManager: handleCallEvent: hold: $callId \n'
        'position in list is ${_calls.firstWhere((element) => element.id == callId)}');
    _calls.firstWhere((element) => element.id == callId).hold();
  }

  @override
  Future<void> resume({required String callId}) async {
    log('TelecomManager: handleCallEvent: resume: $callId \n'
        'position in list is ${_calls.firstWhere((element) => element.id == callId)}');
    _calls.firstWhere((element) => element.id == callId).resume();
  }

  @override
  Future<void> mute({required String callId}) async {
    log('TelecomManager: handleCallEvent: mute: $callId \n'
        'position in list is ${_calls.firstWhere((element) => element.id == callId)}');
    _calls.firstWhere((element) => element.id == callId).mute();
  }

  @override
  Future<void> unmute({required String callId}) async {
    log('TelecomManager: handleCallEvent: unMute: $callId \n'
        'position in list is ${_calls.firstWhere((element) => element.id == callId)}');
    _calls.firstWhere((element) => element.id == callId).unMute();
  }

  @override
  Future<void> terminate({required String callId}) async {
    log('TelecomManager: handleCallEvent: terminate: $callId \n'
        'position in list is ${_calls.firstWhere((element) => element.id == callId)}');
    _calls.firstWhere((element) => element.id == callId).terminate();
  }

  @override
  Future<void> setAudioRoute({required AudioRoute audioRoute}) async {
    log('TelecomManager: setAudioRoute: setAudioRoute: $audioRoute');
    return callClient.setAudioRoute(audioRoute: audioRoute);
  }

  @override
  Future<List<AudioRouteData>?> getAudioRoutes() async {
    log('TelecomManager:  getAudioRoutes = ${callClient.getAudioRoutes()}');
    return await callClient.getAudioRoutes();
  }

  void destroy() {
    callsSubscription?.cancel();
  }

  @override
  Future<Account?> getAccount() {
    return AccountRepository.getAccount();
  }

  @override
  saveAccount(Account account) {
    AccountRepository.saveAccount(account);
  }
  
  @override
  Future<Settings> getSettings() {
    return SettingsRepository.getSettings();
  }

  @override
  saveSettings(Settings settings) {
    SettingsRepository.saveSettings(settings);
  }

  @override
  Future<RegistrationState> getRegistrationState() {
    return callClient.getRegistrationState();
  }

}

