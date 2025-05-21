import 'dart:core';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exolve_voice_sdk/communicator/configuration_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_voice_example/core/telecom/telecom_manager_interface.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/models/settings.dart';
import '../../core/share/share_provider.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  final ITelecomManager telecomManager;

  final ConfigurationManager configurationManager = ConfigurationManager();

  SettingsBloc({required this.telecomManager})
      : super(const SettingsState.initial())
  {

    telecomManager.getSettings().then((settings) {
      log("SettingsBloc: getSettingsUseCase when bloc starts");
      add(SettingsDetectLocationEvent(enabled: settings.isDetectLocationEnabled));
      add(SettingsRingtoneEvent(enabled: settings.isRingtoneEnabled));
    });

    telecomManager.getVersionInfo().then((versionInfo) {
      log("SettingsBloc: getVersionInfo when bloc starts");
      add(VersionInfoLoadedEvent(data: 'SDK ver.${versionInfo.buildVersion} env:${(versionInfo.environment.isNotEmpty)? versionInfo.environment : "default"}'));
    });

    on<VersionInfoLoadedEvent>((event,emit) async {
      log("SettingsBloc: VersionInfoLoadedEvent when bloc starts");
      emit(SettingsState.copy(copied: state, sdkVersionDescriprion: event.data));
    });

    on<ShareLogsEvent>((event, emit) async {
      _shareLogs(event.context);
    });

    on<SettingsDetectLocationEvent>((event, emit) async {
      telecomManager.saveSettings(Settings(
        isRingtoneEnabled:  state.isRingtoneEnabled,
        isDetectLocationEnabled: event.enabled
      ));
      configurationManager.setDetectLocationEnabled(event.enabled);
      emit(SettingsState.copy(copied: state, isDetectLocationEnabled: event.enabled));
    });

    on<SettingsRingtoneEvent>((event, emit) async {
      telecomManager.saveSettings(Settings(
        isRingtoneEnabled: event.enabled,
        isDetectLocationEnabled: state.isDetectLocationEnabled
      ));
      configurationManager.setAndroidRingtoneEnabled(event.enabled);
      emit(SettingsState.copy(copied: state, isRingtoneEnabled: event.enabled));
    });
  } // SettingsBloc constructor

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
  
}
