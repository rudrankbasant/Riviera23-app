import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:riviera23/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/hashtag_model.dart';

class HashtagRepository {
  Future<List<HashtagModel>> getAllHashtag() async {

    Box hashtagsBox;
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    hashtagsBox = await Hive.openBox('hashtags');
    return await getAllEventsData(hashtagsBox);

    /*const url = '$baseURl/hashtag';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      final json = jsonDecode(response.body) as List;
      final result = json.map((e) => HashtagModel.fromJson(e)).toList();
      return result;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      debugPrint(response.body);
      throw Exception('Failed to fetch');
    }*/
  }

  Future<List<HashtagModel>> getAllEventsData(Box hashtagBox) async{
    List<HashtagModel> hashtags = [];
    const url = '$baseURl/hashtag';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? appStarted = prefs.getBool('appStarted');
    var myMap = hashtagBox.toMap().values.toList();
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
          await putData(hashtagBox, json);
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
        hashtags.add(HashtagModel.fromJson(myMap[i]));
      }
      return hashtags;
    } else {
      debugPrint('No data in EventBox');
      return hashtags;
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
