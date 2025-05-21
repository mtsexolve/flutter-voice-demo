import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_voice_example/features/settings/settings_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../constants/colors_mts.dart';
import '../../constants/strings_mts.dart';
import '../../core/common_ui/switch_styled.dart';

class Settings extends StatelessWidget {
  const Settings({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child:BlocBuilder<SettingsBloc, SettingsState>(
        builder : (context, state) {
          log('settings: _accountController: state: $state');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _optionsSwitchBlock(context: context),
              const Spacer(),
              _versionInfoLabel(context: context, sdkVersionDescriprion: state.sdkVersionDescriprion),
              _sendLogsButton(context: context),
            ]
          );
        }
      )
    );
  }




  Widget _optionsSwitchBlock({required BuildContext context}) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchStyled(
            labelText:StringsMts.locationSwitchLabel,
            onChanged: (bool enabled){
              context.read<SettingsBloc>().add(SettingsDetectLocationEvent(enabled: enabled));
            },
            value: context.read<SettingsBloc>().state.isDetectLocationEnabled,
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
