import 'package:intl/intl.dart';

int dayOfYear(DateTime date) => int.parse(DateFormat('D').format(date));
