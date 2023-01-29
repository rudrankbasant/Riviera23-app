import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../presentation/methods/custom_flushbar.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(
      double latitude, double longitude, BuildContext context) async {
    String googleUrl2 =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final String googleUrl = "google.navigation:q=$latitude,$longitude&mode=w";
    /*final String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=${position
          .latitude},${position
          .longitude}&destination=$latitude,$longitude&travelmode=walking';*/
    //  final String appleUrl = 'https://maps.apple.com/?q=$latitude,$longitude';
    //final String appleUrl = 'http://maps.apple.com/?saddr=&daddr=$latitude,$longitude';
    final String appleUrl = 'maps://?saddr=&daddr=$latitude,$longitude';
    final Uri googleuri = Uri.parse(googleUrl);
    //final Uri googleUriForIos=Uri.parse("comgooglemaps://?center=$latitude,$longitude");
    final Uri googleUriForIos = Uri.parse(
        "comgooglemaps://?saddr=&daddr=$latitude,$longitude&directionsmode=driving");
    final Uri appleUri = Uri.parse(appleUrl);

    if (await canLaunchUrl(googleuri)) {
      try {
        /*print("using maps_launcer package");
          MapsLauncher.launchCoordinates(latitude, longitude);*/
        await launchUrl(googleuri);
      } catch (e) {
        print(e.toString());
      }
    } else if (await canLaunchUrl(googleUriForIos)) {
      try {
        launchUrl(googleUriForIos);
      } catch (e) {
        print(e.toString());
      }
    } else if (await canLaunchUrl(appleUri)) {
      try {
        launchUrl(appleUri);
      } catch (e) {
        print(e.toString());
      }
    } else {
      showCustomFlushbar(
        'Error',
        'Could not open the map',
        context,
      );
    }
  }
}
