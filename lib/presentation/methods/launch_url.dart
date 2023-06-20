import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/strings/strings.dart';
import 'custom_flushbar.dart';

void launchURL(url, BuildContext context, [bool browserMode = false]) async {
  final Uri uri = Uri.parse(url);
  try {
    browserMode
        ? await canLaunchUrl(uri)
            ? await launchUrl(uri, mode: LaunchMode.externalApplication)
            : throw Strings.showURIError(uri)
        : await canLaunchUrl(uri)
            ? await launchUrl(uri)
            : throw Strings.showURIError(uri);
  } catch (e) {
    showCustomFlushbar(
        Strings.cantOpenLinkTitle, Strings.cantOpenLinkMessage, context);
  }
}
