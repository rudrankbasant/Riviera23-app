import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/strings/strings.dart';
import '../presentation/methods/custom_flushbar.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(
      double latitude, double longitude, BuildContext context) async {
    final String googleUrl = Strings.googleMapUrl(latitude, longitude);
    final String appleUrl = Strings.appleMapUrl(latitude, longitude);
    final Uri googleuri = Uri.parse(googleUrl);
    final Uri googleUriForIos =
        Uri.parse(Strings.googleMapUrlForIos(latitude, longitude));
    final Uri appleUri = Uri.parse(appleUrl);

    if (await canLaunchUrl(googleuri)) {
      try {
        await launchUrl(googleuri);
      } catch (e) {
        throw e.toString();
      }
    } else if (await canLaunchUrl(googleUriForIos)) {
      try {
        launchUrl(googleUriForIos);
      } catch (e) {
        throw e.toString();
      }
    } else if (await canLaunchUrl(appleUri)) {
      try {
        launchUrl(appleUri);
      } catch (e) {
        throw e.toString();
      }
    } else {
      showCustomFlushbar(
        Strings.errorLoading,
        Strings.mapError,
        context,
      );
    }
  }
}
