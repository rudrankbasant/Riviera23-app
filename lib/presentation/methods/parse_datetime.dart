import 'package:intl/intl.dart';
import '../../utils/constants/strings/strings.dart';

String parseDate(String? datetime) {
  if (datetime != null) {
    DateTime dateTime = DateFormat(Strings.dateTimeFormat).parse(datetime, true);
    DateTime date = dateTime.toLocal();
    DateFormat formatter = DateFormat(Strings.date);
    String formatted = formatter.format(date);
    return formatted.toUpperCase();
  }
  return Strings.datesToBeDeclared;
}

String parseTime(String? datetime) {
  if (datetime != null) {
    DateTime dateTime = DateFormat(Strings.dateTimeFormat).parse(datetime, true);
    DateTime date = dateTime.toLocal();
    DateFormat formatter = DateFormat(Strings.time);
    String formatted = formatter.format(date);
    return formatted;
  }
  return Strings.datesToBeDeclared;
}
