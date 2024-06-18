import 'package:exolve_voice_sdk/communicator/configuration.dart';
import 'package:exolve_voice_sdk/communicator/version_info.dart';
import 'package:exolve_voice_sdk/call/call_event.dart';
import 'package:exolve_voice_sdk/call/call.dart';
import 'package:exolve_voice_sdk/communicator/registration/registration_event.dart';
import 'package:exolve_voice_sdk/communicator/registration/registration_state.dart';
import '../models/account.dart';
import '../models/settings.dart';

interface class ITelecomManager {

  Future<void> initializeCallClient({required Configuration configuration}) async {
    throw UnimplementedError('initializeCallClient() has not been implemented.');
  }

  Stream<RegistrationEvent>? subscribeOnRegistrationEvents() {
    throw UnimplementedError('subscribeOnRegistrationEvents() has not been implemented.');
  }

  Stream<String>? subscribeOnPushTokenEvents() {
    throw UnimplementedError('subscribeOnPushTokenEvents() has not been implemented.');
  }

  Stream<CallEvent>? subscribeOnCallEvents() {
    throw UnimplementedError('subscribeOnCallEvents() has not been implemented.');
  }

  Future<RegistrationState> getRegistrationState() {
    throw UnimplementedError('getRegistrationState() has not been implemented.');
  }

  Future<VersionInfo> getVersionInfo() async {
    throw UnimplementedError('getVersionInfo() has not been implemented.');
  }

  Future<void> register({required Account account}) async {
    throw UnimplementedError('register() has not been implemented.');
  }

  Future<void> unregister() async {
    throw UnimplementedError('unregister() has not been implemented.');
  }

  saveAccount(Account account) async {
    throw UnimplementedError('saveAccount() has not been implemented.');
  }

  Future<Account?> getAccount() async {
    throw UnimplementedError('getAccount() has not been implemented.');
  }

  saveSettings(Settings settings) async {
    throw UnimplementedError('saveSettings() has not been implemented.');
  }

  Future<Settings> getSettings() async {
    throw UnimplementedError('getSettings() has not been implemented.');
  }

  Future<void> makeCall({required String number}) async {
    throw UnimplementedError('makeCall() has not been implemented.');
  }

  Future<void> accept({required String callId}) async {
    throw UnimplementedError('accept() has not been implemented.');
  }

  Future<void> terminate({required String callId}) async {
    throw UnimplementedError('terminate() has not been implemented.');
  }

  Future<void> hold({required String callId}) async {
    throw UnimplementedError('hold() has not been implemented.');
  }

  Future<void> resume({required String callId}) async {
    throw UnimplementedError('resume() has not been implemented.');
  }

  Future<void> transfer({required String callId, required String targetNumber }) async {
    throw UnimplementedError('transfer() has not been implemented.');
  }

  Future<void> sendDtmf({required String callId, required String sequence,}) async {
    throw UnimplementedError('sendDtmf() has not been implemented.');
  }

  Future<void> createConference({required String callId, required String otherCallId}) async {
    throw UnimplementedError('createConference() has not been implemented.');
  }

  Future<void> addToConference({required String callId }) async {
    throw UnimplementedError('addToConference() has not been implemented.');
  }

  Future<void> removeFromConference({required String callId }) async {
    throw UnimplementedError('removeFromConference() has not been implemented.');
  }

  Future<void> mute({required String callId }) async {
    throw UnimplementedError('mute() has not been implemented.');
  }

  Future<void> unmute({required String callId }) async {
    throw UnimplementedError('unMute() has not been implemented.');
  }

  Future<void> setSpeaker({required bool setSpeakerOn }) async {
    throw UnimplementedError('setSpeaker() has not been implemented.');
  }

  List<Call> getCalls() {
    throw UnimplementedError('getCalls() has not been implemented.');
  }

}
