import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  var day = date.day;
  var suffix = _getDaySuffix(day);
  var formatter = DateFormat("d'$suffix' MMM, yyyy");
  return formatter.format(date);
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
