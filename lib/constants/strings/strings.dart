class Strings {
  Strings._();

  //Firebase Collection Name
  static const String announcementCollection = 'announcements';

  //Hive Box
  static const String eventBox = 'events';
  static const String hashtagBox = 'hashtags';

  static const String appStartedHashtag = 'appStarted_hashtags';
  static const String appStartedEvents = 'appStarted_events';

  //Firebase Error Codes
  static const String weakPassword = 'weak-password';
  static const String emailInUse = 'email-already-in-use';
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';
  static const String badEmailFormat = 'badly-formatted-email';

  //General
  static const String about = "ABOUT";
  static const String organizer = "ORGANIZER";
  static const String amount = "REGISTRATION AMOUNT";
  static const String free = "FREE";
  static const String register = 'REGISTER NOW';
  static const String registration = "Registration";
  static const String vitStudent = 'VIT STUDENT';
  static const String externalParticipant = 'EXTERNAL PARTICIPANT';
  static const String proshows = "PRO SHOWS";
  static const String featuredEventsTitle = "FEATURED EVENTS";
  static const String featuredEventsEmpty =
      'Featured Events will be updated soon';
  static const String seeMore = "See more";

  static getAmount(String? cost) => "\u{20B9}$cost (Inc. GST)";

  //General Messages
  static const String emailVerificationTitle = "Email Verification Sent!";
  static const String emailVerificationMessage =
      "Please check your inbox or spam folder for verification link";
  static const String passwordResetTitle = "Password Reset Email Sent!";
  static const String passwordResetMessage =
      "Please check your inbox or spam folder for password reset link";
  static const String favouriteTitle = "Added to Favourites!";
  static const String favouriteMessage =
      "You will be receiving important notifications for this event.";

  //Guide
  static const String favouriteGuideMessage =
      "You will receive all important notifications for the events you favourite.";
  static const String registrationGuide =
      "Register for events at Riviera 2023 as a VIT student, or as an external participant.";
  static const String externalParticipantGuide =
      "External participants need to register on the portal.";

  //Errors
  //Errors Messages
  static const String failedToFetch = 'Failed to fetch';
  static const String userNotLoggedIn = 'User not logged in';
  static const String datesToBeDeclared = "Dates to be declared";
  static const String errorLoading = "Error Loading";
  static const String cantOpenLinkTitle = "Can't Open Link";
  static const String cantOpenLinkMessage =
      "The link may be null or may have some issues.";

  static showURIError(Uri uri) => 'Could not launch $uri';

  //Auth Errors
  static const String generalTitle = "Error!";
  static const String weakPasswordTitle = "Weak Password";
  static const String weakPasswordMessage =
      'The password provided is too weak.';
  static const String emailInUseTitle = "Account Exists";
  static const String emailInUseMessage =
      'The account already exists for that email.';
  static const String userNotFoundTitle = "No user found";
  static const String userNotFoundMessage =
      'This email address has not been registered.';
  static const String wrongPasswordTitle = "Wrong Password";
  static const String wrongPasswordMessage =
      'Wrong password provided for email.';
  static const String badEmailFormatTitle = "Badly Formatted Email";
  static const String badEmailFormatMessage =
      'Please enter a valid email address.';
  static const String mapError = 'Could not open the map';

  //Provider IDs
  static const String google = 'google.com';
  static const String apple = 'apple.com';
  static const String password = 'password';

  //Formats
  static const String charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  static const String dateTimeFormat = "yyyy-MM-ddTHH:mm:ssZ";
  static const String date = "dd MMM, yyyy";
  static const String time = "hh:mm a";

  //Links
  static const String vtopLink = "https://vtop.vit.ac.in/vtop";
  static const String websiteLink = "https://web.vit.ac.in/riviera/";

  static googleMapUrl(double latitude, double longitude) =>
      "google.navigation:q=$latitude,$longitude&mode=w";

  static appleMapUrl(double latitude, double longitude) =>
      'maps://?saddr=&daddr=$latitude,$longitude';

  static googleMapUrlForIos(double latitude, double longitude) =>
      "comgooglemaps://?saddr=&daddr=$latitude,$longitude&directionsmode=driving";
}
