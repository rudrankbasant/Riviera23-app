import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/strings/asset_paths.dart';
import '../../constants/strings/strings.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../../utils/app_colors.dart';
import '../methods/launch_url.dart';
import '../widgets/profile_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var version = '';

  @override
  void initState() {
    super.initState();
    updateVersion();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthCubit().user;
    final Email email = Email(
      body: Strings.delAccountEmailBody(
          user.email, user.providerData[0].providerId),
      subject: Strings.delAccountEmailSubject,
      recipients: [Strings.dscEmailId],
      isHTML: false,
    );
    Future<void> requestAccountDeletion() async {
      await FlutterEmailSender.send(email);
    }

    _showDeletionDialog(context) async {
      await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          String title = Strings.accDeletionTitle;
          String message = Strings.accDeletionDesc;
          String btnLabelCancel = Strings.cancel;
          String btnLabel = Strings.deleteAccount;
          return Platform.isIOS
              ? buildiOSDialog(title, message, context, btnLabelCancel, requestAccountDeletion, btnLabel)
              : buildAndroidDialog(title, message, btnLabelCancel, context, btnLabel, requestAccountDeletion);
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context, _showDeletionDialog),
      body: buildBody(user),
    );
  }

  LayoutBuilder buildBody(User user) {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                buildUserInfo(user),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                buildMerchBanner(context),
                const SizedBox(
                  height: 40,
                ),
                buildMoreInfoHeading(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                buildEmailInfo(user),
                buildFavouriteEventButton(context),
                buildSignOutButton(context),
                Expanded(
                  child: Container(
                    color: AppColors.primaryColor,
                  ),
                ),
                buildMoreInfo(context, Strings.termsAndConditions),
                buildMoreInfo(context, Strings.getVersion(version)),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Align buildMoreInfoHeading() {
    return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(Strings.more,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontFamily:
                                GoogleFonts.getFont("Sora").fontFamily)),
                  ));
  }

  GestureDetector buildMoreInfo(BuildContext context, String text) {
    return GestureDetector(
                onTap: () {
                  launchURL(Strings.privacyPolicyLink, context);
                },
                child: Text(text,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontFamily:
                            GoogleFonts.getFont("Sora").fontFamily)),
              );
  }

  ProfileInfo buildEmailInfo(User user) {
    return ProfileInfo(
                  imgPath: AssetPaths.emailIcon,
                  infoText: user.email.toString(),
                  isButton: false);
  }

  InkWell buildSignOutButton(BuildContext context) {
    return InkWell(
                onTap: () {
                  BlocProvider.of<AuthCubit>(context)
                      .signOut(context)
                      .then((isSuccess) {
                    if (isSuccess) {
                      Navigator.of(context).pushReplacementNamed(
                        '/authentication',
                      );
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            width: 50.0,
                            height: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(AssetPaths.signOutIcon),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Text(Strings.signOut,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.getFont("Sora")
                                      .fontFamily)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: SvgPicture.asset(AssetPaths.rightArrowIcon,
                            height: 20, width: 20),
                      ),
                    ],
                  ),
                ),
              );
  }

  InkWell buildFavouriteEventButton(BuildContext context) {
    return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/events', arguments: 1);
                },
                child: const ProfileInfo(
                  imgPath: AssetPaths.favouriteIcon,
                  infoText: Strings.favEvents,
                  isButton: true,
                ),
              );
  }

  GestureDetector buildMerchBanner(BuildContext context) {
    return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/merch',
                  );
                },
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Image.asset(AssetPaths.merchBanner),
                      ),
                    )),
              );
  }

  Visibility buildUserInfo(User user) {
    return Visibility(
                visible: user.displayName != null,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: CachedNetworkImage(
                          width: 75.0,
                          height: 75.0,
                          imageUrl: user.photoURL.toString(),
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                  height: 250.0,
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  )),
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: AppColors.primaryColor,
                            highlightColor: Colors.grey,
                            child: Container(
                              color: Colors.grey,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset(AssetPaths.appIcon),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.displayName.toString(),
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontFamily: GoogleFonts.getFont("Sora")
                                        .fontFamily)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

  AppBar buildAppBar(BuildContext context, Future<Null> _showDeletionDialog(dynamic context)) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0.0,
      title: Transform(
          transform: Matrix4.translationValues(10.0, 2.0, 0.0),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                AssetPaths.rivieraIcon,
                height: 40,
                width: 90,
                fit: BoxFit.contain,
              ),
            ),
          )),
      actions: [
        Theme(
          data: Theme.of(context).copyWith(
            cardColor: AppColors.cardBgColor,
          ),
          child: PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showDeletionDialog(context);
                      },
                      child: const Text(
                        Strings.accDeletionTitle,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ];
              }),
        )
      ],
    );
  }

  AlertDialog buildAndroidDialog(String title, String message, String btnLabelCancel, BuildContext context, String btnLabel, Future<void> requestAccountDeletion()) {
    return AlertDialog(
                backgroundColor: AppColors.cardBgColor,
                title: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                content: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      btnLabelCancel,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(btnLabel,
                        style: const TextStyle(color: Colors.redAccent)),
                    onPressed: () {
                      requestAccountDeletion();
                    },
                  ),
                ],
              );
  }

  CupertinoAlertDialog buildiOSDialog(String title, String message, BuildContext context, String btnLabelCancel, Future<void> requestAccountDeletion(), String btnLabel) {
    return CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      btnLabelCancel,
                    ),
                  ),
                  CupertinoDialogAction(
                    onPressed: () {
                      requestAccountDeletion();
                    },
                    child: Text(
                      btnLabel,
                    ),
                  ),
                ],
              );
  }

  void updateVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }
}
