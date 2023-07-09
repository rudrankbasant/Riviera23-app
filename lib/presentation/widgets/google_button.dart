import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../cubit/auth/auth_cubit.dart';
import '../../utils/constants/strings/asset_paths.dart';
import '../../utils/constants/strings/strings.dart';

class GoogleSignIn extends StatelessWidget {
  const GoogleSignIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<AuthCubit>(context).signInWithGoogle(context);
      },
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AssetPaths.googleLogo),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    Strings.googleAuth,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
