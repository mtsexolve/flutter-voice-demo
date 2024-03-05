import 'dart:async';
import 'dart:core';
import 'dart:developer';
//import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exolve_voice_sdk/communicator/registration/registration_event.dart';
import 'package:exolve_voice_sdk/communicator/registration/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_voice_example/core/telecom/telecom_manager_interface.dart';
import 'package:flutter_voice_example/features/utils/registration_mapper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/models/account.dart';
import '../../core/share/share_provider.dart';
import 'package:flutter_voice_example/constants/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  final ITelecomManager telecomManager;
  StreamSubscription<RegistrationEvent>? _registrationSubscription;
  StreamSubscription<String>? _pushTokenSubscription;

  SettingsBloc({required this.telecomManager})
      : super(const SettingsState.initial("", ""))
  {

    telecomManager.getAccount().then((account) {
      log("SettingsBloc: getAccountUseCase when bloc starts");
      account != null ? add(AccountDataIsLoadedEvent(data: account))
          : log("SettingsBloc: getAccountUseCase when bloc starts: account is empty ");
    });

    telecomManager.getVersionInfo().then((versionInfo) {
      log("SettingsBloc: getVersionInfo when bloc starts");
      add(VersionInfoLoadedEvent(data: 'SDK ver.${versionInfo.buildVersion} env:${(versionInfo.environment.isNotEmpty)? versionInfo.environment : "default"}'));
    });

    on<VersionInfoLoadedEvent>((event,emit) async {
      log("SettingsBloc: VersionInfoLoadedEvent when bloc starts");
      emit(SettingsState.copy(copied: state, sdkVersionDescriprion: event.data));
    });

    on<AccountDataIsLoadedEvent>((event,emit) async {
      log("SettingsBloc: AccountDataIsLoadedEvent when bloc starts: ");
      emit(SettingsState.copy(copied: state, login: event.data.login, password: event.data.password));
    });

    on<RegistrationReceivedEvent>((event,emit) async {
      log("SettingsBloc: RegistrationReceivedEvent");
      emit(SettingsState.copy(
          copied: state,
          registrationState: RegistrationMapper.fromRegistrationEventToState(event: event.state)
      ));

      if (event.state is RegistrationErrorEvent) {
        var e = event.state as RegistrationErrorEvent;
        Fluttertoast.showToast(
            msg: "Error: \"${e.message}\" (${e.error})",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 14.0);
      }
    });

    on<RegistrationReceivedState>((event,emit) async {
      log("SettingsBloc: RegistrationReceivedState");
      emit(SettingsState.copy(copied: state, registrationState: event.state));
    });

    on<PushTokenEvent>((event,emit) async {
      log("SettingsBloc: PushTokenEvent");
      emit(SettingsState.copy(copied: state, pushToken: event.pushToken));
    });

    on<ActivateSipAccountEvent>((event, emit) async {
      var account = Account(login: state.login, password: state.password);
      telecomManager.saveAccount(account);
      _register(account: account);
    });

    on<DeactivateAccountEvent>((event, emit) async {
      _unregister();
    });

    on<ShareLogsEvent>((event, emit) async {
      _shareLogs(event.context);
    });

    on<TextFieldChangedEvent>((event, emit) async {
      emit(SettingsState(
        registrationState: state.registrationState,
        pushToken: state.pushToken,
        login: event.name == "login" ? event.inputText : state.login,
        password: event.name == "password" ? event.inputText : state.password,
      ));
    });

    _registrationSubscription = telecomManager.subscribeOnRegistrationEvents()?.listen((event) {
      log("SettingsBloc: registration subscription event received, event = $event");
      add(RegistrationReceivedEvent(state: event));
    });

    _pushTokenSubscription = telecomManager.subscribeOnPushTokenEvents()?.listen((token) {
      if (token.isNotEmpty) {
        log("SettingsBloc: push token received");
        add(PushTokenEvent(pushToken: token));
      }
    });

    _retrievePushToken();
  } // SettingsBloc constructor

  Future<void> _retrievePushToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final token = prefs.getString(Keys.tokenPreferencesKey) ?? "";
    if (token.isNotEmpty) {
      log('SettingsBloc: push token retrieved: $token');
      add(PushTokenEvent(pushToken: token));
    }
  }

  Future<void> _register({required Account account,}) async {
    log("SettingsBloc: register account $account");
    telecomManager.register(account: account);
  }

  Future<void> _unregister() async {
    log("SettingsBloc: unregister");
    telecomManager.unregister();
  }

  Future<void> _shareLogs(BuildContext context) async {
    log("SettingsBloc: shareLogs");
    await ShareProvider().share(context).then(
      (message) { Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 14.0);
      }
    );
  }

  @override
  Future<void> close() {
    _registrationSubscription?.cancel();
    _pushTokenSubscription?.cancel();
    return super.close();
  }

}
