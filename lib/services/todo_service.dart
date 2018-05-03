import 'dart:async';

import 'package:todolist_sample/models/todo.dart';

enum TodoServiceSource {
  dummy,
  localStorage,
}

abstract class TodoService {
  Future<List<Todo>> list();
  Future<Todo> add(Todo todo);
  Future<bool> remove(int id);

  factory TodoService({TodoServiceSource source}) {
    switch (source) {
      case TodoServiceSource.dummy:
        return new _DummyTodoService();
      case TodoServiceSource.localStorage:
        // TODO: Implement local storage service
        return new _DummyTodoService();
    }
  }
}

class _DummyTodoService implements TodoService {
  List<Todo> _todos;

  Future<List<Todo>> list() async {
    await new Future.delayed(new Duration(seconds: 5));
    var temp = _generateDummies();
    if (_todos == null) {
      _todos = temp;
    } else {
      _todos.addAll(temp);
    }
    return temp;
  }

  Future<Todo> add(Todo todo) async {
    await new Future.delayed(new Duration(seconds: 5));
    _todos.add(todo);
    return todo;
  }

  Future<bool> remove(int id) async {
    await new Future.delayed(new Duration(seconds: 5));
    int itemIndex = _todos.indexWhere((todo) => todo.id == id);
    if (itemIndex >= 0) {
      _todos.removeAt(itemIndex);
    }
    return (itemIndex >= 0);
  }

  List<Todo> _generateDummies() {
    var dummies = new List.generate(20, (index) {
      var newIndex = index + (_todos != null ? _todos.length : 0);
      return new Todo(
        id: newIndex,
        name: 'TODO #$newIndex',
        description: 'Description of TODO #$newIndex',
        startTime: new DateTime.now(),
        endTime: new DateTime.now().add(new Duration(days: 1)),
      );
    });
    return dummies;
  }
}
