import 'package:flutter/material.dart';

import '../../utils/constants/strings/strings.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.showConfirmPassword,
  });

  final bool showConfirmPassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: const Color(0xff466FFF),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showConfirmPassword
                    ? const Text(
                        Strings.signupAuth,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const Text(
                        Strings.signInAuth,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ));
  }
}
