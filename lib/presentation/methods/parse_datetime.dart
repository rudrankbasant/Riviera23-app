import 'package:intl/intl.dart';

import '../../constants/strings/strings.dart';

String parseDate(String? datetime) {
  if (datetime != null) {
    var dateTime = DateFormat(Strings.dateTimeFormat).parse(datetime, true);
    var date = dateTime.toLocal();
    var formatter = DateFormat(Strings.date);
    var formatted = formatter.format(date);
    return formatted.toUpperCase();
  }
  return Strings.datesToBeDeclared;
}

String parseTime(String? datetime) {
  if (datetime != null) {
    var dateTime = DateFormat(Strings.dateTimeFormat).parse(datetime, true);
    var date = dateTime.toLocal();
    var formatter = DateFormat(Strings.time);
    var formatted = formatter.format(date);
    return formatted;
  }
  return Strings.datesToBeDeclared;
}
