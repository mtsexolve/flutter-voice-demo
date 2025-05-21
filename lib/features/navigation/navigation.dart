import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_voice_example/features/dialer/dialer.dart';
import 'package:flutter_voice_example/features/settings/settings.dart';
import 'package:flutter_voice_example/features/account/account.dart';
import 'package:flutter_voice_example/features/bottom_navigation/bottom_navigation.dart';
import 'package:flutter_voice_example/features/bottom_navigation/bottom_navigation_bloc.dart';

class NavigationView extends StatelessWidget {
  final List<StatelessWidget> screens = const [
    Dialer(key: ValueKey('call')),
    Account(),
    Settings()
  ];

  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          var i = state.currentIndex;
          return Column(
            children: [
              Expanded(
                child: screens[i]
              ),
              BottomNavigation(currentIndex: i)
            ]
          );
        }
    );
  }
}

