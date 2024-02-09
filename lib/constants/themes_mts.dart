import 'package:flutter/material.dart';
import 'package:flutter_voice_example/constants/colors_mts.dart';

class ThemesMts {

  static final callKeyGrey = ButtonStyle(
    fixedSize: MaterialStateProperty.all(const Size.square(72)),
    shape: MaterialStateProperty.all(const CircleBorder()),
    backgroundColor: MaterialStateProperty.all(ColorsMts.mtsBgGrey),
    side: MaterialStateProperty.all(const BorderSide(color: ColorsMts.mtsBgGrey)),
    overlayColor: MaterialStateProperty.all(Colors.grey.shade300)
  );

  static final callKeyRed = ButtonStyle(
    fixedSize: MaterialStateProperty.all(const Size.square(72)),
    shape: MaterialStateProperty.all(const CircleBorder()),
    backgroundColor: MaterialStateProperty.all(ColorsMts.mtsRed),
    side: MaterialStateProperty.all(const BorderSide(color: ColorsMts.mtsBgGrey)),
    overlayColor: MaterialStateProperty.all(Colors.grey.shade300)
  );

}