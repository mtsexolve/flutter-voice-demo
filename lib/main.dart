import 'dart:developer';
import 'dart:io';

import 'package:exolve_voice_sdk/communicator/configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_voice_example/core/telecom/telecom_manager.dart';
import 'package:flutter_voice_example/features/dialer/dialer_bloc.dart';
import 'package:flutter_voice_example/features/settings/settings_bloc.dart';
import 'package:flutter_voice_example/features/selector/selector_bloc.dart';
import 'constants/colors_mts.dart';
import 'constants/strings_mts.dart';
import 'features/bottom_navigation/bottom_navigation_bloc.dart';
import 'features/call/call_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_voice_example/features/selector/selector.dart';
import 'package:provider/provider.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  if(await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  if(await Permission.microphone.isDenied) {
    await Permission.microphone.request();
  }
  if(Platform.isAndroid && await Permission.phone.isDenied) {
    await Permission.phone.request();
  }


  TelecomManager().getSettings().then((settings) {
    log("main: App settings loaded");
    TelecomManager().initializeCallClient(
        configuration: Configuration(
          logConfiguration: LogConfiguration(logLevel: LogLevel.debug),
          enableSipTrace: true,
          enableNotifications: true,
          enableSecureConnection: false,
          enableDetectCallLocation: settings.isDetectCallLocationEnabled,
          androidTelecomIntegrationMode:  AndroidTelecomIntegrationMode.selfManagedService,
          notifyInForeground: true,
          callKitConfiguration: CallKitConfiguration(
            includeInRecents: true,
            dtmfEnabled: false
          ),
          androidNotificationConfiguration: AndroidNotificationConfiguration(
            enableRingtone: settings.isRingtoneEnabled
          )
        )
    ).then((value) {
      runApp(const MyApp());
    });
  });

}

class MyApp extends StatelessWidget {
  final connectionStatus = "Status";
  const MyApp({
    super.key,
  });

   @override
  Widget build(BuildContext context) {
    return _homeScreenScaffold(context);
  }

  Widget _homeScreenScaffold(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: ColorsMts.white,
        textTheme: const TextTheme(
          titleSmall: TextStyle(
            color: ColorsMts.mtsTextGrey,
            fontFamily: 'mtscompact',
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
          titleLarge: TextStyle(
            color: ColorsMts.black,
            fontFamily: 'mtscompact',
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
          titleMedium: TextStyle(
            color: ColorsMts.black,
            fontFamily: 'mtscompact',
            fontWeight: FontWeight.w400,
            fontSize: 17,
          ),
          bodyMedium: TextStyle(
            color: ColorsMts.black,
            fontFamily: 'mtscompact',
            fontWeight: FontWeight.w300,
            fontSize: 17,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ColorsMts.mtsRed),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                color: ColorsMts.white,
                fontFamily: 'mtscompact',
                fontWeight: FontWeight.w700,
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.red),
                )
            )
          )
        )
      ),
      home: MultiProvider(
        providers: [
          Provider<SettingsBloc>(
            create: (_) => SettingsBloc(telecomManager: TelecomManager()),
          ),
          Provider<DialerBloc>(
              create: (_) => DialerBloc(telecomManager: TelecomManager())
          ),
          Provider<SelectorBloc>(
            create: (_) => SelectorBloc(telecomManager: TelecomManager()),
          ),
          Provider<CallBloc>(
              create: (_) => CallBloc(telecomManager: TelecomManager()),
          ),
          Provider<BottomNavigationBloc>(
            create: (_) => BottomNavigationBloc(),
          ),
        ],
        child: _homeScreenBody(context),
      ),
    );
  }

  Widget _homeScreenBody(BuildContext context) {
     return Scaffold(
       appBar: _appBar(context),
       resizeToAvoidBottomInset: false,
       body: const SafeArea(
           child: SelectorView()
       )
     );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      title: BlocBuilder<SelectorBloc, SelectorState>(
        builder: (context, state) {
          if (state.hasOngoingCall && state.selectorOverride == SelectorOverride.dialer) {
            return Align(
                alignment: Alignment.center,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.transparent),
                    side: MaterialStateProperty.all(BorderSide.none),
                    overlayColor: MaterialStateProperty.all(
                        ColorsMts.mtsBgGrey),
                  ),
                  onPressed: () {
                    context.read<SelectorBloc>().add(const BackToCallScreenEvent());
                  },
                  child: Text(
                      StringsMts.dialerBackToCall,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                  )
              ),
            );
          } else {
            return BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                return Text(
                    "Registration state: ${state.registrationState
                    .toString()
                    .split(".")
                    .last
                    .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
                      return '${match.group(1)} ${match.group(2)}';
                    })
                    .toLowerCase()}",
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium,
                );
              },
            );
          }
        },
      ),
      centerTitle: false,
      backgroundColor: ColorsMts.white,
    );
  }

  }
