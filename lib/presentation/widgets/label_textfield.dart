import 'package:flutter/material.dart';
import 'package:sns_app/core/constants/sizes.dart';

class LabelTextfield extends StatelessWidget {
  LabelTextfield({
    super.key,
    required this.labelText,
    this.errorText,
    this.obscured,
    this.textfieldChanged,
  });

  String labelText;
  String? errorText;
  bool? obscured;
  ValueChanged<String>? textfieldChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        SizedBox(
          height: getHeight(context) * 0.1,
          child: TextFormField(
            onChanged: textfieldChanged,
            obscureText: obscured ?? false,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              errorText:
                  errorText == '통과' || errorText == '' ? null : errorText,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
