import 'package:flutter/foundation.dart';

class Strings {
  static String appTitle = 'Todolist';

  static String newTodoTitle = 'New Todo';
  static String editTodoTitle = 'Edit Todo';

  static String todoStartDateLabel = 'State Date:';
  static String todoEndDateLabel = 'End Date:';

  static String saveTodo = 'Save';

  static String formattedDateString(DateTime dateTime) {
    var year = dateTime.year.toString();
    var month = dateTime.month.toString();
    var day = dateTime.day.toString();

    return '$year.$month.$day';
  }
}
