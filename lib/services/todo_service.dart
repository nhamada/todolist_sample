import 'dart:async';
import 'dart:math';

import 'package:todolist_sample/models/todo.dart';

enum TodoServiceSource {
  dummy,
  localStorage,
}

abstract class TodoService {
  Future<List<Todo>> list({int page = 0});
  Future<List<Todo>> listSince({int sinceId, int page = 0});
  Future<List<Todo>> listBefore({int beforeId, int page = 0});
  Future<Todo> add({String name, String description, DateTime startDate, DateTime endDate});
  Future<Todo> update({int id, String name, String description, DateTime startDate, DateTime endDate});
  Future<bool> remove(int id);

  factory TodoService({TodoServiceSource source, int pagingCount}) {
    switch (source) {
      case TodoServiceSource.dummy:
        return new _DummyTodoService(pagingCount: pagingCount);
      case TodoServiceSource.localStorage:
        // TODO: Implement local storage service
        return new _DummyTodoService();
    }
  }
}

class _DummyTodoService implements TodoService {
  List<Todo> _todos;

  final int pagingCount;

  _DummyTodoService({this.pagingCount}) {
    _todos = _generateDummies(65);
  }

  Future<List<Todo>> list({int page = 0}) async {
    assert(page >= 0);
    await new Future.delayed(new Duration(seconds: 5));
    var sorted = _todos.toList();
    sorted.sort((item1, item2) => item2.id.compareTo(item1.id));

    var startIndex = page * pagingCount;
    var endIndex = (page + 1) * pagingCount;
    if (startIndex >= sorted.length) {
      return new List();
    }
    if (sorted.length < endIndex) {
      return sorted.sublist(startIndex);
    }
    return sorted.sublist(startIndex, endIndex);
  }

  Future<List<Todo>> listSince({int sinceId, int page = 0}) async {
    assert(page >= 0);
    await new Future.delayed(new Duration(seconds: 5));
    var sorted = _todos.where((todo) => sinceId < todo.id).toList();
    sorted.sort((item1, item2) => item2.id.compareTo(item1.id));

    var startIndex = page * pagingCount;
    var endIndex = (page + 1) * pagingCount;
    if (startIndex >= sorted.length) {
      return new List();
    }
    if (sorted.length < endIndex) {
      return sorted.sublist(startIndex);
    }
    return sorted.sublist(startIndex, endIndex);
  }

  Future<List<Todo>> listBefore({int beforeId, int page = 0}) async {
    assert(page >= 0);
    await new Future.delayed(new Duration(seconds: 5));
    var sorted = _todos.where((todo) => todo.id < beforeId).toList();
    sorted.sort((item1, item2) => item2.id.compareTo(item1.id));

    var startIndex = page * pagingCount;
    var endIndex = (page + 1) * pagingCount;
    if (startIndex >= sorted.length) {
      return new List();
    }
    if (sorted.length < endIndex) {
      return sorted.sublist(startIndex);
    }
    return sorted.sublist(startIndex, endIndex);
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

  List<Todo> _generateDummies(int length) {
    var dummies = new List.generate(length, (index) {
      var newIndex = index + (_todos != null ? _todos.length + 1 : 1);
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
