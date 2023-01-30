import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:riviera23/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event_model.dart';

class EventsRepository {

  Future<List<EventModel>> getAllEvents() async {
    Box eventBox;
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    eventBox = await Hive.openBox('events');
    return await getAllEventsData(eventBox);
  }



  Future<List<EventModel>> getAllEventsData(Box eventBox) async{
    List<EventModel> events = [];
    const url = '$baseURl/events';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? appStarted = prefs.getBool('appStarted');
    var myMap = eventBox.toMap().values.toList();
    if(appStarted==true || myMap.isEmpty ) {
      try {
        var response = await http.get(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
          },
        );

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body) as List;
          await putData(eventBox, json);
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          debugPrint(response.body);
          throw Exception('Failed to fetch');
        }
      } catch (SocketException) {
        print("EVENTS---> No Internet");
      }
    }

      //get data from box
      if (myMap.isNotEmpty) {
        for (var i = 0; i < myMap.length; i++) {
          events.add(EventModel.fromJson(myMap[i]));
        }
        return events;
      } else {
        debugPrint('No data in EventBox');
        return events;
      }


  }



  Future putData(Box eventBox, data) async{
    await eventBox.clear();
    for(var d in data){
      print("saving $d in EventBox");
      await eventBox.add(d);
    }
  }


}
