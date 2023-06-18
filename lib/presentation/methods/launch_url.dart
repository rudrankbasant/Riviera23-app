import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_flushbar.dart';

void _launchURL(url, BuildContext context) async {
  final Uri uri = Uri.parse(url);
  try {
    await canLaunchUrl(uri)
        ? await launchUrl(uri)
        : throw 'Could not launch $uri';
  } catch (e) {
    showCustomFlushbar("Can't Open Link",
        "The link may be null or may have some issues.", context);
  }
}
