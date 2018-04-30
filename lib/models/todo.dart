import 'package:flutter/foundation.dart';

class Todo {
  final int id;
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;

  bool done = false;

  Todo({@required this.id,
        @required this.name,
        this.description,
        @required this.startTime,
        @required this.endTime}
      ) : assert(id != null && id >= 0),
          assert(name != null && name.length > 0),
          assert(startTime != null),
          assert(endTime != null);
}