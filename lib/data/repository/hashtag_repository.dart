import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants/strings/api_endpoints.dart';
import '../../utils/constants/strings/shared_pref_keys.dart';
import '../../utils/constants/strings/strings.dart';
import '../models/hashtag_model.dart';

class HashtagRepository {
  Future<List<HashtagModel>> getAllHashtag() async {
    Box hashtagsBox;
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    hashtagsBox = await Hive.openBox(Strings.hashtagBox);
    return await getAllEventsData(hashtagsBox);
  }

  Future<List<HashtagModel>> getAllEventsData(Box hashtagBox) async {
    List<HashtagModel> hashtags = [];

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseURL = prefs.getString(SharedPrefKeys.idRemoteBaseURL);
    String url = APIEndpoints.getHashtag(baseURL);

    bool? appStartedHashtags = prefs.getBool(Strings.appStartedHashtag);

    var myMap = hashtagBox.toMap().values.toList();
    if (appStartedHashtags == true || myMap.isEmpty) {
      prefs.setBool(Strings.appStartedHashtag, false);
      try {
        http.Response response = await http.get(
          Uri.parse(url),
          headers: APIEndpoints.header,
        );

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body) as List;
          await putData(hashtagBox, json);
        } else {
          throw Exception(Strings.failedToFetch);
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    //get data from box
    if (myMap.isNotEmpty) {
      for (var i = 0; i < myMap.length; i++) {
        hashtags.add(HashtagModel.fromJson(myMap[i]));
      }
      return hashtags;
    } else {
      return hashtags;
    }
  }

  Future putData(Box eventBox, data) async {
    await eventBox.clear();
    for (var d in data) {
      await eventBox.add(d);
    }
  }
}
