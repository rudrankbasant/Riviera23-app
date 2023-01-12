import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:riviera23/utils/constants.dart';

import '../models/hashtag_model.dart';

class HashtagRepository {
  Future<List<HashtagModel>> getAllHashtag() async {
    const url = '$baseURl/hashtag';
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
    }
  }
}
