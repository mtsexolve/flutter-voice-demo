import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/themes_mts.dart';
import '../../core/common_ui/dial_keyboard.dart';
import 'call_bloc.dart';

class Dtmf extends StatelessWidget {
  final CallScreenState state;
  const Dtmf({Key? key, required this.state}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          state.enteredDtmfSequence,
          style: const TextStyle(
            fontFamily: 'mtswide',
            fontWeight: FontWeight.w500,
            fontSize: 31,
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
          child: DialKeyboard(dialButtonPressed: (String key){
            context.read<CallBloc>().add(DtmfKeyboardKeyPressedEvent(
                state: state,
                callId: state.selectedCallId ?? "",
                sequence: key
            ));
          }),
        ),
    //    const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            context.read<CallBloc>().add(DtmfKeyboardStateChangedEvent(
                state: state, dtmfKeyboardState: DtmfKeyboardState.inactive
            ));
          },
          style: ThemesMts.callKeyGrey,
          child: Transform.rotate(
            angle: -90 * 3.14 / 180,
            child: const Icon(CupertinoIcons.back, color: Colors.black,size: 32 ,),
          ),
        ),
      ],
    );
  }

}