class Todo {
  final int id;
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;

  bool done = false;

  Todo({this.id,
        this.name,
        this.description,
        this.startTime,
        this.endTime}
      ) : assert(id != null && id >= 0),
          assert(name != null && name.length > 0),
          assert(startTime != null),
          assert(endTime != null);
}