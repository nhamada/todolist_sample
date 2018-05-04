import 'dart:async';
import 'dart:math';

import 'package:todolist_sample/models/todo.dart';

enum TodoServiceSource {
  dummy,
  localStorage,
}

abstract class TodoService {
  Future<List<Todo>> list();
  Future<Todo> add({String name, String description, DateTime startDate, DateTime endDate});
  Future<Todo> update({int id, String name, String description, DateTime startDate, DateTime endDate});
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

  Future<Todo> add({String name, String description, DateTime startDate, DateTime endDate}) async {
    await new Future.delayed(new Duration(seconds: 5));
    int maxId = -1;
    for (var todo in _todos) {
      maxId = max(maxId, todo.id);
    }
    Todo todo = new Todo(id: maxId + 1,
                         name: name,
                         description: description,
                         startTime: startDate,
                         endTime: endDate);
    _todos.add(todo);
    return todo;
  }

  Future<Todo> update({int id, String name, String description, DateTime startDate, DateTime endDate}) async {
    await new Future.delayed(new Duration(seconds: 5));
    int itemIndex = _todos.indexWhere((todo) => todo.id == id);
    if (itemIndex < 0) {
      return null;
    }
    Todo oldTodo = _todos[itemIndex];
    Todo updateTodo = new Todo(id: id,
                               name: (name != null) ? name : oldTodo.name,
                               description: (description != null) ? description : oldTodo.description,
                               startTime: (startDate != null) ? startDate : oldTodo.startTime,
                               endTime: (endDate != null) ? endDate : oldTodo.endTime,
                              );
    _todos[itemIndex] = updateTodo;
    return updateTodo;
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
