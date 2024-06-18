import 'package:exolve_voice_sdk/communicator/registration/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_voice_example/core/models/settings.dart';
import 'package:flutter_voice_example/features/dialer/dialer_bloc.dart';
import 'package:flutter_voice_example/features/settings/settings_bloc.dart';

import '../../core/common_ui/dial_keyboard.dart';

class Dialer extends StatelessWidget {
  const Dialer({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          bottom: 16 ,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<DialerBloc, DialerState>(builder: (context, state) {
              return Text(
                state.enteredNumber,
                style: const TextStyle(
                  fontFamily: 'mtswide',
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              );
            }),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: 8,
              ),
              child: DialKeyboard(dialButtonPressed: (String digit){context.read<DialerBloc>().add(DialerButtonPressedEvent(digit: digit));},),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 52,
                  width: 52,
                ),
                Container(
                  height: 92,
                  width: 92,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child:
                  IconButton(
                    onPressed: () {
                      if(context.read<SettingsBloc>().state.registrationState!=RegistrationState.registered) {
                        return;
                      }
                      context.read<DialerBloc>().add(CreateCallEvent());
                    },
                    icon: SvgPicture.asset(
                      'assets/images/ic_btn_call.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 52,
                  width: 52,
                  child: GestureDetector(
                    onLongPress: () {context.read<DialerBloc>().add(RemoveAllDigitsEvent());},
                    child: IconButton(
                      onPressed: () {context.read<DialerBloc>().add(RemoveDigitEvent());},
                      icon: SvgPicture.asset(
                      'assets/images/ic_btn_remove_digit.svg',
                      fit: BoxFit.fill,
                      )
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}
