import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_voice_example/constants/colors_mts.dart';

import '../../features/settings/settings_bloc.dart';

class DataField extends StatelessWidget {
  final String name;
  final String label;
  final String hint;
  final String text;

  const DataField({
    super.key,
    required this.name,
    required this.label,
    required this.hint,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8,),
        TextFormField(
          initialValue: text,
          onChanged: (text) {
            context.read<SettingsBloc>().add(TextFieldChangedEvent(name: name, inputText: text));
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorsMts.mtsBgGrey,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorsMts.mtsGrey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.titleSmall,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            focusedBorder:OutlineInputBorder(
              borderSide: const BorderSide(color: ColorsMts.mtsGrey, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          style: Theme.of(context).textTheme.bodyMedium,
          cursorColor: ColorsMts.black,
        ),
      ],
    );
  }

}
