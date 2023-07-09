import 'package:flutter/material.dart';

import '../../utils/constants/strings/strings.dart';

class AuthFormField extends StatelessWidget {
  const AuthFormField({
    super.key,
    required this.textController, required this.textInputType, required this.label, required this.obscureText,
  });

  final TextEditingController textController;
  final TextInputType textInputType;
  final String label;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: TextField(
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          controller: textController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            label: Text(
              Strings.emailAuth,
              style: TextStyle(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(7))),
            hintText: Strings.emailAuth,
          ),
        ));
  }
}