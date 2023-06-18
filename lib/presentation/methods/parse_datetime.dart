import 'package:intl/intl.dart';

String parseDate(String? datetime) {
  if (datetime != null) {
    // DateTime date = DateTime.parse(datetime);
    // var formatter = DateFormat("dd MMM, yyyy");
    // var formatted = formatter.format(date);
    // return formatted.toString().toUpperCase();
    //2023-02-24T03:30:00.000Z
    var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(datetime, true);
    var date = dateTime.toLocal();
    var formatter = DateFormat("dd MMM, yyyy");
    var formatted = formatter.format(date);
    return formatted.toUpperCase();
  }
  return "Dates to be declared";
}

String parseTime(String? datetime) {
  if (datetime != null) {
    // DateTime date = DateTime.parse(datetime);
    // var formatter = DateFormat("hh:mm a");
    // var formatted = formatter.format(date);
    // return formatted.toString();

    var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(datetime, true);
    var date = dateTime.toLocal();
    var formatter = DateFormat("hh:mm a");
    var formatted = formatter.format(date);
    print("formatted datetime ---" + formatted);
    return formatted;
  }
  return "Dates to be declared";
}
