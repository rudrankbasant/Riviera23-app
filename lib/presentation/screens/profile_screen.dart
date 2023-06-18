import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riviera23/presentation/screens/auth_screen.dart';
import 'package:riviera23/presentation/screens/events_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/auth/auth_cubit.dart';
import '../../utils/app_colors.dart';
import '../methods/custom_flushbar.dart';
import '../widgets/profile_info.dart';
import 'merch_screen.dart';

class ProfileScreen extends StatefulWidget {
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
      body:
          'This request is initiated to delete account associated with ${user.email} created with ${user.providerData[0].providerId}',
      subject: 'Request to Delete Account',
      recipients: ['contact@dscvit.com'],
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
          String title = "Request Account Deletion";
          String message =
              "It may take upto 5-7 business days to delete your account after the process has been initiated.";
          String btnLabelCancel = "Cancel";
          String btnLabel = "Delete Account";
          return Platform.isIOS
              ? CupertinoAlertDialog(
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
                )
              : AlertDialog(
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
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        btnLabelCancel,
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(btnLabel,
                          style: TextStyle(color: Colors.redAccent)),
                      onPressed: () {
                        requestAccountDeletion();
                      },
                    ),
                  ],
                );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0.0,
        title: Transform(
            // you can forcefully translate values left side using Transform
            transform: Matrix4.translationValues(10.0, 2.0, 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  'assets/riviera_icon.png',
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
                icon: Icon(
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
                        child: Text(
                          'Request Account Deletion',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ];
                }),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Visibility(
                    visible: user.displayName != null,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                  Image.asset("assets/app_icon.png"),
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
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MerchScreen()));
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Image.asset("assets/merch_banner.png"),
                          ),
                          fit: BoxFit.fill,
                        )),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text("MORE",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontFamily:
                                    GoogleFonts.getFont("Sora").fontFamily)),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  ProfileInfo(
                      imgPath: "assets/email_icon.svg",
                      infoText: user.email.toString(),
                      isButton: false),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventsScreen(1)));
                    },
                    child: ProfileInfo(
                      imgPath: "assets/favourite_icon.svg",
                      infoText: "Favorite Events",
                      isButton: true,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventsScreen(1)));
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<AuthCubit>(context)
                          .signOut(context)
                          .then((isSuccess) {
                        if (isSuccess) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthScreen()));
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
                                child: SvgPicture.asset(
                                    "assets/sign_out_icon.svg"),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Text('Sign Out',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: GoogleFonts.getFont("Sora")
                                          .fontFamily)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SvgPicture.asset(
                                'assets/right_arrow_icon.svg',
                                height: 20,
                                width: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL("https://dscvit.com/privacy-policy", context);
                    },
                    child: Text("Terms and Conditions | Privacy Policy",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontFamily:
                                GoogleFonts.getFont("Sora").fontFamily)),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL("https://dscvit.com/privacy-policy", context);
                    },
                    child: Text("Version ${version}",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontFamily:
                                GoogleFonts.getFont("Sora").fontFamily)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void updateVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }
}

void _launchURL(_url, BuildContext context) async {
  final Uri _uri = Uri.parse(_url);
  try {
    await canLaunchUrl(_uri)
        ? await launchUrl(_uri)
        : throw 'Could not launch $_uri';
  } catch (e) {
    print(e.toString());
    showCustomFlushbar("Can't Open Link",
        "The link may be null or may have some issues.", context);
  }
}
