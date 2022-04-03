import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {Key? key,
      required this.onChanged,
      required this.prefixIcon,
      required this.labelText,
      bool? isPassword})
      : obscureText = isPassword ?? false,
        super(key: key);

  final ValueChanged<String> onChanged;
  final Icon prefixIcon;
  final String labelText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon,
        labelText: labelText,
      ),
    );
  }
}
