import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants/strings/api_endpoints.dart';
import '../../utils/constants/strings/shared_pref_keys.dart';
import '../../utils/constants/strings/strings.dart';
import '../models/event_model.dart';

class EventsRepository {
  Future<List<EventModel>> getAllEvents() async {
    Box eventBox;
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    eventBox = await Hive.openBox(Strings.eventBox);
    return await getAllEventsData(eventBox);
  }

  Future<List<EventModel>> getAllEventsData(Box eventBox) async {
    List<EventModel> events = [];

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseURL = prefs.getString(SharedPrefKeys.idRemoteBaseURL);
    String url = APIEndpoints.getEvents(baseURL);

    String eventsBoolKey = Strings.appStartedEvents;
    bool? appStartedEvents = prefs.getBool(eventsBoolKey);

    var myMap = eventBox.toMap().values.toList();
    if (appStartedEvents == true || myMap.isEmpty) {
      prefs.setBool(eventsBoolKey, false);
      try {
        http.Response response = await http.get(
          Uri.parse(url),
          headers: APIEndpoints.header,
        );

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body) as List;
          await putData(eventBox, json);
        } else {
          throw Exception(Strings.failedToFetch);
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    //Get data from box
    if (myMap.isNotEmpty) {
      for (var i = 0; i < myMap.length; i++) {
        events.add(EventModel.fromJson(myMap[i]));
      }
      return events;
    } else {
      return events;
    }
  }

  Future putData(Box eventBox, data) async {
    await eventBox.clear();
    for (var d in data) {
      await eventBox.add(d);
    }
  }
}
