class APIEndpoints {
  APIEndpoints._();

  static String getEvents(String? baseURL) => '$baseURL/events';

  static String getHashtag(String? baseURL) => '$baseURL/hashtag';

  static const Map<String, String> header = {
    "Content-Type": "application/json",
  };
}
