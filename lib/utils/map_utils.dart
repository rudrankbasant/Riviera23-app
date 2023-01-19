import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../presentation/methods/custom_flushbar.dart';

class MapUtils{
  MapUtils._();

  static Future<void> openMap(Position? position, double latitude, double longitude, BuildContext context) async {
    if (position != null) {
      final String googleUrl = "google.navigation:q=$latitude,$longitude&mode=d";
      /*final String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=${position
          .latitude},${position
          .longitude}&destination=$latitude,$longitude&travelmode=walking';*/
      final String appleUrl = 'https://maps.apple.com/?ll=$latitude,$longitude';

      final Uri googleuri = Uri.parse(googleUrl);
      final Uri appleUri = Uri.parse(appleUrl);

      if (await canLaunchUrl(googleuri)) {
        await launchUrl(googleuri);
      } else if (await canLaunchUrl(appleUri)) {
        await launchUrl(appleUri);
      } else {
        showCustomFlushbar(
          'Error',
          'Could not open the map',
          context,
        );
      }
    }
  }

}