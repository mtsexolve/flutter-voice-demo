import 'package:flutter/material.dart';
import '../../constants/colors_mts.dart';


class DialKeyboard extends StatelessWidget {
  final Function dialButtonPressed;
  const DialKeyboard({Key? key, required this.dialButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DialKey(digit: "1", dialButtonPressed: dialButtonPressed,),
                DialKey(digit: "2", dialButtonPressed: dialButtonPressed,),
                DialKey(digit: "3", dialButtonPressed: dialButtonPressed,),
              ]
          ),
          const SizedBox(height: 16),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DialKey(digit: "4", dialButtonPressed: dialButtonPressed,),
                DialKey(digit: "5", dialButtonPressed: dialButtonPressed,),
                DialKey(digit: "6", dialButtonPressed: dialButtonPressed,),
              ]
          ),
          const SizedBox(height: 16),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DialKey(digit: "7", dialButtonPressed: dialButtonPressed,),
                DialKey(digit: "8", dialButtonPressed: dialButtonPressed,),
                DialKey(digit: "9", dialButtonPressed: dialButtonPressed,),
              ]
          ),
          const SizedBox(height: 16,),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DialKey(digit: "*", dialButtonPressed: dialButtonPressed,),
                DialKey(digit: "0", dialButtonPressed: dialButtonPressed,),
                DialKey(digit: "#", dialButtonPressed: dialButtonPressed,),]
          ),
        ]
    );
  }
}
class DialKey extends StatelessWidget {
  final String digit;
  final Function dialButtonPressed;
  const DialKey({super.key, required this.digit, required this.dialButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      height: 72,
      width: 72,
      child: OutlinedButton(
        onPressed: () {
          dialButtonPressed(digit);
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all(const CircleBorder()),
            backgroundColor: MaterialStateProperty.all(ColorsMts.mtsBgGrey),
            side: MaterialStateProperty.all(
                const BorderSide(color: ColorsMts.mtsBgGrey)),
            overlayColor: MaterialStateProperty.all(Colors.grey.shade300)
        ),
        child: Text(
          digit,
          style: const TextStyle(
            color: ColorsMts.black,
            fontFamily: 'mtswide',
            fontWeight: FontWeight.w500,
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}