import 'package:intl/intl.dart';

String parseDate(String? datetime) {
  if (datetime != null) {
    DateTime date = DateTime.parse(datetime);
    var formatter = DateFormat("dd MMM, yyyy");
    var formatted = formatter.format(date);
    return formatted.toString();
  }
  return "Dates to be declared";
}

String parseTime(String? datetime) {
  if (datetime != null) {
    DateTime date = DateTime.parse(datetime);
    var formatter = DateFormat("hh:mm a");
    var formatted = formatter.format(date);
    return formatted.toString();
  }
  return "Dates to be declared";
}
