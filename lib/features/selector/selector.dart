import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_voice_example/features/selector/selector_bloc.dart';
import 'package:flutter_voice_example/features/call/call.dart';
import 'package:flutter_voice_example/features/navigation/navigation.dart';

class SelectorView extends StatelessWidget {
  final callScreen = const CallScreen();
  final navigationView = const NavigationView();

  const SelectorView({super.key});

  @override
  Widget build(BuildContext context) {
    log('NEW SELECTOR');
    return BlocBuilder<SelectorBloc, SelectorState>(builder: (context, state) {
        var showCalls = state.hasOngoingCall
            && state.selectorOverride == SelectorOverride.none;
        return showCalls ? callScreen : navigationView;
      });
  }
}
