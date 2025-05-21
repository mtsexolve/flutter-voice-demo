import 'package:exolve_voice_sdk/communicator/registration/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_voice_example/core/models/settings.dart';
import 'package:flutter_voice_example/features/account/account_bloc.dart';
import 'package:flutter_voice_example/features/call/call_bloc.dart';
import 'package:flutter_voice_example/features/dialer/dialer_bloc.dart';
import 'package:flutter_voice_example/features/dialer/dialer_bloc_manager.dart';
import 'package:flutter_voice_example/features/settings/settings_bloc.dart';
import 'package:flutter_voice_example/constants/colors_mts.dart';
import 'package:flutter_voice_example/constants/themes_mts.dart';
import 'package:flutter/cupertino.dart';

import '../../core/common_ui/dial_keyboard.dart';

class Dialer extends StatelessWidget {

  const Dialer({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = context.read<DialerBlocManager>();
    final id = (key as ValueKey?)?.value?.toString() ?? 'call';
    final bloc = manager.get(id);
    final bool isTransferDialer = (id == 'transfer');

    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<DialerBloc, DialerState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.enteredNumber,
                style: const TextStyle(
                  fontFamily: 'mtswide',
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: 8,
                ),
                child: DialKeyboard(
                  dialButtonPressed: (String digit) {
                    context
                        .read<DialerBloc>()
                        .add(DialerButtonPressedEvent(digit: digit));
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 52,
                    width: 52,
                    child: GestureDetector(
                      child: IconButton(
                          onPressed: () {
                            context
                                .read<DialerBloc>()
                                .add(ContactPickerClickedEvent());
                          },
                          icon: SvgPicture.asset(
                            'assets/images/ic_btn_contacts.svg',
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                  Container(
                    height: 92,
                    width: 92,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (isTransferDialer) {
                          final selectedCallId =
                              context.read<CallBloc>().state.selectedCallId;
                          if (selectedCallId != null) {
                            context
                                .read<DialerBloc>()
                                .add(TransferCallEvent(callId: selectedCallId));
                          }
                        } else {
                          if (context
                                  .read<AccountBloc>()
                                  .state
                                  .registrationState !=
                              RegistrationState.registered) {
                            return;
                          }
                          context.read<DialerBloc>().add(CreateCallEvent());
                        }
                      },
                      icon: (isTransferDialer)
                          ? Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Color(0xFF26CD58),
                                  shape: BoxShape.circle),
                              child: SvgPicture.asset(
                                  'assets/images/ic_dialer_transfer.svg',
                                  width: 32,
                                  height: 32),
                            )
                          : SvgPicture.asset('assets/images/ic_btn_call.svg',
                              fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(
                    height: 52,
                    width: 52,
                    child: GestureDetector(
                      onLongPress: () {
                        context.read<DialerBloc>().add(RemoveAllDigitsEvent());
                      },
                      child: IconButton(
                          onPressed: () {
                            context.read<DialerBloc>().add(RemoveDigitEvent());
                          },
                          icon: SvgPicture.asset(
                            'assets/images/ic_btn_remove_digit.svg',
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                ],
              ),
              if (isTransferDialer)
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<CallBloc>().add(CallScreenViewChangedEvent(
                          state: context.read<CallBloc>().state,
                          callScreenView: CallScreenView.call));
                    },
                    style: ThemesMts.callKeyGrey,
                    child: Transform.rotate(
                      angle: -90 * 3.14 / 180,
                      child: const Icon(
                        CupertinoIcons.back,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
      }),
    );
  }
}
