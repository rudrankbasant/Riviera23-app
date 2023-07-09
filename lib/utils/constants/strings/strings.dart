import 'dart:core';

class Strings {
  Strings._();

  static const String appName = "Riviera23";

  //Remote Config Ids
  static const String androidVersion = "android_version";
  static const String iosVersion = "ios_version";
  static const String baseUrl = "base_url";
  static const String showGdsc = "show_gdsc";

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
  static const String close = "Close";

  static showURIError(Uri uri) => 'Could not launch $uri';

  //Auth Errors
  static const String generalErrorTitle = "Error!";
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

  //Announcement Screen
  static const String announcements = 'Announcements';
  static const String loadingAnnouncement = "Loading Announcement History ...";
  static const String openLink = "Open link";

  //Auth Screen
  static const String loadingAuth = 'Reviving the Era...';
  static const String titleAuth = "WELCOME TO RIVIERA'23";
  static const String emailAuth = "Email";
  static const String passwordAuth = "Password";
  static const String forgotPasswordAuth = "Forgot Password?";
  static const String confirmPasswordAuth = "Confirm Password";
  static const String passwordsDontMatch = "Passwords don't match";
  static const String emailPasswordAuth = "Please Enter email and password";
  static const String signupAuth = "Sign Up";
  static const String signInAuth = "Sign In";
  static const String or = "OR";
  static const String googleAuth = "Continue with Google";
  static const String appleAuth = "Continue with Apple";
  static const String loginGuideAuth = "Already have an account? Login";
  static const String signupGuideAuth = "Don't have an account? Sign Up";
  static const String resetPasswordAuth = "Reset Password";
  static const String resetDescAuth =
      "Enter your email ID to reset your password";
  static const String resetLinkSentAuth = "Reset Password Link Sent";
  static const String resetLinkDescAuth =
      "Please check your email for a link to reset your password. \nIf it doesn’t appear within a few minutes, check your spam folder.";
  static const String send = "Send";

  //Bottom Nav Screen
  static const String home = "Home";
  static const String events = "Events";
  static const String hashtags = "Hashtags";
  static const String info = "Info";
  static const String profile = "Profile";

  //Contacts Screen
  static const String meetTheTeam = "Meet the Team";
  static const String loadingTeam = "Loading Team ...";
  static const String teamLink = "https://riviera.vit.ac.in/team";
  static const String contactUs = "CONTACT US";
  static const String loadingContacts = "Loading Contacts";

  //Events Screen
  static const String allEvents = "All Events";
  static const String favouriteEvents = "Favourites";
  static const String search = "Search";
  static const String eventFilter = "Event Filter";
  static const String eventDates = "Event Dates";
  static const String clearAll = "Clear All";
  static const String day1 = "23 FEB, 2023";
  static const String day2 = "24 FEB, 2023";
  static const String day3 = "25 FEB, 2023";
  static const String day4 = "26 FEB, 2023";
  static const String venues = "Venues";
  static const String noEvents = "No Events Found.";
  static const String subsGuideEvents =
      "You will receive event-specific notifications for your favourite events. \n\nAdd some favourites by liking an event!";
  static const String placeholderTextEvents =
      "You will receive event-specific notifications for your favourite events. Add some favourites by liking an event!";

  //Faq Screen
  static const String sponsors = "Sponsors";
  static const String placeholderTextSponsor = "Sponsors Will appear here";
  static const String loadingFaq = "Loading FAQs...";
  static const String faq = "FAQ";

  //Hashtags
  static const String rivieraHashtag = '#riviera23';
  static const String photowall = ' photowall';
  static const String desc1 = 'Use ';
  static const String desc2 =
      ' on your Instagram to get featured on this timeline.';

  //Home Screen
  static const String seeAllMerch = "See all Merch";
  static const String placeholderTextEventOngoing =
      "On Going Events will appear here.";
  static const String appLinkApple =
      'https://apps.apple.com/in/app/riviera-23/id1665459606';
  static const String appLinkGoogle =
      'https://play.google.com/store/apps/details?id=in.ac.vit.riviera23';
  static const String updateTitle = "Update Available";
  static const String updateDesc =
      "A new version of the app is available. Please update to the latest version.";
  static const String later = "Later";
  static const String updateNow = "Update Now";

  //Merch Screen
  static const String merchTitle = 'Merchandise';

  static getMerchPrice(String price) => "\u{20B9}$price";
  static const String sizeChart = "Size Chart";
  static const String description = "Description";
  static const String buyNow = 'BUY NOW';

  //Profile Screen
  static String delAccountEmailBody(String? email, String providerId) =>
      'This request is initiated to delete account associated with $email created with $providerId';
  static const String delAccountEmailSubject = "Request to Delete Account";
  static const String dscEmailId = 'contact@dscvit.com';
  static const String accDeletionTitle = "Request Account Deletion";
  static const String accDeletionDesc =
      "It may take upto 5-7 business days to delete your account after the process has been initiated."
      "It may take upto 5-7 business days to delete your account after the process has been initiated.";
  static const String cancel = "Cancel";
  static const String deleteAccount = "Delete Account";
  static const String more = "More";
  static const String favEvents = "Favorite Events";
  static const String signOut = "signOut";
  static const String privacyPolicyLink = "https://dscvit.com/privacy-policy";
  static const String termsAndConditions =
      "Terms and Conditions | Privacy Policy";

  static getVersion(String version) => "Version $version";

  //Splash Screen
  static const String getStarted = 'GET STARTED';
  static const riviera = 'Riviera';
  static const rivieraDesc =
      ' is the Annual International Sports and Cultural Carnival of the Vellore Institute of Technology.';
}
