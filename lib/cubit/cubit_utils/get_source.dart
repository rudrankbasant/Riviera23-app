import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Source> getSource(String idLocalVersion, String idRemoteVersion) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int? localVersion = prefs.getInt(idLocalVersion);
  int? remoteVersion = prefs.getInt(idRemoteVersion);
  if (remoteVersion != null) {
    /*NOTE: Checking internet connection here is important because if the app is opened with internet connection (hence fetches all remote data versions)
      and then goes to announcement page for the first time with no internet connection the app will have an issue because the localAnnouncementVersion
      will be null and will update itself to the remoteAnnouncementVersion and hence will never fetch until remote version is updated.
      This is the case with all firebase calls, namely - contacts, sponsors, timeline, announcements, faq, team, venue*/

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      if (localVersion != null) {
        if (remoteVersion == localVersion) {
          return Source.cache;
        } else {
          prefs.setInt(
              idLocalVersion, remoteVersion);
          return Source.server;
        }
      } else {
        prefs.setInt(
            idLocalVersion, remoteVersion);
        return Source.server;
      }
    } else {
      return Source.cache;
    }
  } else {
    return Source.server;
  }
}