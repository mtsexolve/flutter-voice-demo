import 'package:exolve_voice_sdk/call/call_state.dart';
import 'package:exolve_voice_sdk/communicator/audioroute/audioroute.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_voice_example/features/selector/selector_bloc.dart';
import 'package:flutter_voice_example/features/dialer/dialer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_voice_example/constants/colors_mts.dart';
import 'package:flutter_voice_example/constants/themes_mts.dart';
import 'package:flutter_voice_example/features/call/call_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/svg.dart';

import 'dtmf.dart';

part 'call_item.dart';
part 'call_control_panel.dart';


class CallScreen extends StatelessWidget {
  const CallScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallBloc, CallScreenState>(builder: (context, state) {
      log("call_screen: state of call screen is ${state.callScreenView}");

      Widget view;
      switch (state.callScreenView) {
        case CallScreenView.call:
          view = Column(
                  children: [
                    Expanded(
                      flex: 10, // 20%
                      child: CallsList(state: state,)
                    ),
                    const CallsControlPanel()
                  ]
                );
          break;
        case CallScreenView.dtmf:    
          view = Dtmf(state: state);
          break;
        case CallScreenView.transfer:    
          view = Dialer(key: ValueKey('transfer'));
          break;
        default:
          view = Text('');
          break;
      }

      return Padding(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5
        ),
        child: view
      );
    });
  }
}

class CallsList extends StatelessWidget {
  final CallScreenState state;
  const CallsList({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: state.calls.length,
      itemBuilder: (BuildContext context, int index) {
        return CallItem(index);
      }
    );
  }
}

