import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_voice_example/features/settings/settings_bloc.dart';
import 'package:exolve_voice_sdk/communicator/registration/registration_state.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/colors_mts.dart';
import '../../constants/strings_mts.dart';
import '../../core/common_ui/data_field.dart';
import '../../core/common_ui/switch_styled.dart';

class Settings extends StatelessWidget {
  const Settings({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return _accountController();
  }

  Widget _accountController() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child:BlocBuilder<SettingsBloc, SettingsState>(
        builder : (context, state) {
          log('settings: _accountController: state: $state');
          return Column(
            children: [
              DataField(
                text: state.login,
                label: StringsMts.settingsLogin,
                hint: StringsMts.settingsLoginHint,
                name: "login",
              ),
              const SizedBox(height: 24,),
              DataField(
                text: state.password,
                label: StringsMts.settingsPassword,
                hint: StringsMts.settingsPasswordHint,
                name: "password"
              ),
              const SizedBox(height: 24,),
              _activationControlButton(
                context: context,
                state: state.registrationState,
                activateEvent: ActivateSipAccountEvent(),
                deactivateEvent: DeactivateAccountEvent(),
              ),
              _optionsSwitchBlock(context: context),
              const Spacer(),
              _pushTokenFrame(context: context, token: state.pushToken),
              _versionInfoLabel(context: context, sdkVersionDescriprion: state.sdkVersionDescriprion),
              _sendLogsButton(context: context),
            ]
          );
        }
      )
    );
  }

  Widget _activationControlButton({required BuildContext context,
    required RegistrationState state,
    required SettingsEvent activateEvent,
    required SettingsEvent deactivateEvent}) {
    final isRegistered = state == RegistrationState.registered;
    final event = isRegistered ? deactivateEvent : activateEvent;
    final text = isRegistered ? StringsMts.settingsDeactivate :StringsMts.settingsActivate;
    return FractionallySizedBox(
      alignment: Alignment.topCenter,
      widthFactor: 0.5,
      child: Container(
        height: 50,
        child: TextButton(
          onPressed: () {
            context.read<SettingsBloc>().add(event);
          },
          style: Theme.of(context).textButtonTheme.style,
          child: Text(
            text,
            style: const TextStyle(
                fontFamily: 'mtswide',
                fontWeight: FontWeight.w400,
                color: ColorsMts.white,
                fontSize: 18
            ),
          ),
        ),
      ),
    );
  }

  Widget _optionsSwitchBlock({required BuildContext context}) {
    return Row(
        children: [
          SwitchStyled(
            labelText:StringsMts.callLocationSwitchLabel,
            onChanged: (bool enabled){
              context.read<SettingsBloc>().add(SettingsDetectCallLocationEvent(enabled: enabled));
            },
            value: context.read<SettingsBloc>().state.isDetectCallLocationEnabled,
          ),
          Visibility(
            visible: Platform.isAndroid,
            child: SwitchStyled(
              labelText:StringsMts.ringtoneSwitchLabel,
              onChanged: (bool enabled){
                context.read<SettingsBloc>().add(SettingsRingtoneEvent(enabled: enabled));
              },
              value: context.read<SettingsBloc>().state.isRingtoneEnabled ,
            ),
          )
        ]
    );
  }

  Widget _pushTokenFrame({required BuildContext context, required String token}) {
    return Column(
      children: [
        const Row(
          children: [
            Text(StringsMts.settingsPushToken),
            Spacer()
          ]
        ),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: token));
            Fluttertoast.showToast(
                msg: StringsMts.settingsPushTokenCopied,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.grey,
                textColor: Colors.black,
                fontSize: 14.0);
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 5.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Text(token,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: 'mtswide',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          )
        )
      ]
    );
  }

  Widget _versionInfoLabel({required BuildContext context,required  String? sdkVersionDescriprion}) {
    return Row(
        children: [
          Builder(
              builder: (BuildContext context) {
                if (sdkVersionDescriprion == null) {
                  return Container();
                }
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: Text('${sdkVersionDescriprion}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'mtswide',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )
                );
              }
          )
        ]
    );
  }

  Widget _sendLogsButton({required BuildContext context}) {
    return Row(
        children: [
          FutureBuilder<String>(future: _getPackageName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return Text('${snapshot.data}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'mtswide',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              );
            }
          ),
          const Spacer(),
          Builder(
              builder: (BuildContext context) {
                return TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: BorderSide.none
                    ),
                    onPressed: () {
                      var event = ShareLogsEvent(context: context);
                      context.read<SettingsBloc>().add(event);
                    },
                    child: const Text(
                      StringsMts.settingsSendLogs,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                      )
                    )
                );
              }
          )
        ]
    );
  }

  Future<String> _getPackageName() async {
    final info = await PackageInfo.fromPlatform();
    return info.packageName;
  }
} // class Settings
