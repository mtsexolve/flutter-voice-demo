import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exolve_voice_sdk/communicator/registration/registration_event.dart';
import 'package:exolve_voice_sdk/communicator/registration/registration_state.dart';
import 'package:exolve_voice_sdk/communicator/configuration_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_voice_example/core/telecom/telecom_manager_interface.dart';
import 'package:flutter_voice_example/features/utils/registration_mapper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/models/account.dart';
import 'package:flutter_voice_example/constants/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_voice_example/features/utils/request_permission.dart';
import 'package:permission_handler/permission_handler.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {

  final ITelecomManager telecomManager;
  StreamSubscription<RegistrationEvent>? _registrationSubscription;
  StreamSubscription<String>? _pushTokenSubscription;
  final ConfigurationManager configurationManager = ConfigurationManager();

  AccountBloc({required this.telecomManager})
      : super(const AccountState.initial("", ""))
  {

    telecomManager.getAccount().then((account) {
      log("AccountBloc: getAccountUseCase when bloc starts");
      account != null ? add(AccountDataIsLoadedEvent(data: account))
          : log("AccountBloc: getAccountUseCase when bloc starts: account is empty ");
    });

    on<AccountDataIsLoadedEvent>((event,emit) async {
      log("AccountBloc: AccountDataIsLoadedEvent when bloc starts: ");
      emit(AccountState.copy(copied: state, login: event.data.login, password: event.data.password));
    });

    on<RegistrationReceivedEvent>((event,emit) async {
      log("AccountBloc: RegistrationReceivedEvent");
      emit(AccountState.copy(
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
      log("AccountBloc: RegistrationReceivedState");
      emit(AccountState.copy(copied: state, registrationState: event.state));
    });

    on<PushTokenEvent>((event,emit) async {
      log("AccountBloc: PushTokenEvent");
      emit(AccountState.copy(copied: state, pushToken: event.pushToken));
    });

    on<ActivateSipAccountEvent>((event, emit) async {
      var account = Account(login: state.login, password: state.password);
      telecomManager.saveAccount(account);
      _register(account: account);
    });

    on<DeactivateAccountEvent>((event, emit) async {
      _unregister();
    });

    on<TextFieldChangedEvent>((event, emit) async {
      emit(AccountState(
        registrationState: state.registrationState,
        pushToken: state.pushToken,
        login: event.name == "login" ? event.inputText : state.login,
        password: event.name == "password" ? event.inputText : state.password
      ));
    });

    _registrationSubscription = telecomManager.subscribeOnRegistrationEvents()?.listen((event) {
      log("AccountBloc: registration subscription event received, event = $event");
      add(RegistrationReceivedEvent(state: event));
    });

    _pushTokenSubscription = telecomManager.subscribeOnPushTokenEvents()?.listen((token) {
      if (token.isNotEmpty) {
        log("AccountBloc: push token received");
        add(PushTokenEvent(pushToken: token));
      }
    });

    _retrieveVoipPushToken();
  } // AccountBloc constructor

  Future<void> _retrieveVoipPushToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final token = prefs.getString(Keys.tokenPreferencesKey) ?? "";
    if (token.isNotEmpty) {
      log('AccountBloc: push token retrieved: $token');
      add(PushTokenEvent(pushToken: token));
    }
  }

  Future<void> _register({required Account account,}) async {
    log("AccountBloc: register account $account");

    telecomManager.getSettings().then((settings) {
      if(settings.isDetectLocationEnabled){
        requestPermission(Permission.locationWhenInUse).then((status){
          telecomManager.register(account: account);
        });
      } else {
        telecomManager.register(account: account);
      }
    });
  }

  Future<void> _unregister() async {
    log("AccountBloc: unregister");
    telecomManager.unregister();
  }

  @override
  Future<void> close() {
    _registrationSubscription?.cancel();
    _pushTokenSubscription?.cancel();
    return super.close();
  }
}
