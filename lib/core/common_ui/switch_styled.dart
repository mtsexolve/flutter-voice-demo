import 'package:flutter/material.dart';

class SwitchStyled extends StatelessWidget {
  final String labelText;
  final Function onChanged;
  final bool value;
  const SwitchStyled({
    super.key,
    required this.labelText,
    required this.onChanged,
    required this.value,
    });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "$labelText ",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Switch.adaptive(
          value: value,
          applyCupertinoTheme: true,
          onChanged: (bool value) {
            this.onChanged(value);
          },
        ),
      ],
    );
  }
}
