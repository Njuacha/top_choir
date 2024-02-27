import 'package:flutter/material.dart';

class CommonInputField extends StatelessWidget {
  const CommonInputField({
    super.key,
    required this.textController,
    required this.label,
    this.text,
  });

  final TextEditingController textController;
  final String label;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
          initialValue: text,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          controller: textController,
          decoration: InputDecoration(
              border: const UnderlineInputBorder(), labelText: label)),
    );
  }
}