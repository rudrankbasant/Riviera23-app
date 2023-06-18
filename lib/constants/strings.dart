class Strings{

  Strings._();

  //Shared Pref Keys
  static const String idRemoteBaseURL = 'remote_base_url';
  static const String idRemoteAnnouncement = "remote_announcement";
  static const String idLocalAnnouncement = "local_announcement";



  //Firebase Collection Name
  static const String announcementCollection = 'announcements';



  //Hive Box
  static const String  eventBox = 'events';
  static const String  hashtagBox = 'hashtags';




  static const String  appStartedHashtag = 'appStarted_hashtags';
  static const String  appStartedEvents = 'appStarted_events';






  //Errors
  static const String errorEventBox = 'No data in EventBox';
  static const String errorHashtagBox = 'No data in HashtagBox';
  static const String noInternetEvents = "EVENTS: No Internet";
  static const String noInternetHashtags = "HASHTAGS: No Internet";
  static const String failedToFetch = 'Failed to fetch';

}