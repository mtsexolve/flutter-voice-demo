import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_voice_example/constants/strings_mts.dart';
import 'package:flutter_voice_example/features/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:flutter_voice_example/constants/colors_mts.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final List<BottomNavigationBarItem> barItems;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    this.barItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.dialpad),
        label: StringsMts.dialerTabLabel,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: StringsMts.settingsTabLabel,
      ),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: ColorsMts.mtsRed,
      unselectedItemColor: ColorsMts.mtsGrey,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'mtscompact',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: ColorsMts.mtsRed,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'mtscompact',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: ColorsMts.grey,
      ),
      onTap: (index) {
        context.read<BottomNavigationBloc>().add(TabChangedEvent(index));
      },
      items: barItems,
    );
  }

}

