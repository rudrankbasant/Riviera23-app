import 'package:intl/intl.dart';

String parseDateTime(String? datetime) {
  if (datetime != null) {
    DateTime date = DateTime.parse(datetime);
    var formatter = DateFormat("hh:mm a   dd MMM, yyyy");
    var formatted = formatter.format(date);
    return formatted.toString();
  }
  return "Dates to be declared";
}