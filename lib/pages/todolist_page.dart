import 'dart:async';

import 'package:flutter/material.dart';

import 'package:todolist_sample/models/todo.dart';
import 'package:todolist_sample/pages/todo_detail_page.dart';
import 'package:todolist_sample/pages/todo_edit_page.dart';
import 'package:todolist_sample/services/todo_service.dart';

class TodoListPage extends StatelessWidget {
  final String title;

  static final int pagingCount = 20;

  final TodoService _todoService = new TodoService(source: TodoServiceSource.dummy,
                                                   pagingCount: pagingCount);

  TodoListPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.title),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new TodoEditPage(todoService: _todoService),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ],
      ),
      body: new FutureBuilder<List<Todo>>(
        future: _todoService.list(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return new Text(snapshot.error.toString());
          }

          return (snapshot.hasData)
            ? new _TodoListView(initialTodos: snapshot.data, todoService: _todoService,)
            : new Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }
}

class _TodoListView extends StatefulWidget {
  final List<Todo> initialTodos;
  final TodoService todoService;

  _TodoListView({Key key, this.initialTodos, this.todoService}) : super(key: key);

  @override
  createState() => new _TodoListViewState(todos: initialTodos);
}

class _TodoListViewState extends State<_TodoListView> {
  final List<Todo> todos;

  bool _loading = false;
  bool _listCompleted = false;

  _TodoListViewState({this.todos}) : assert(todos != null) {
    if (TodoListPage.pagingCount > todos.length) {
      _listCompleted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      onRefresh: _requestNewTodos,
      child: new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index >= todos.length) {
            if (_listCompleted) {
              return null;
            }
            if (index == todos.length) {
              if (!_loading) {
                _loading = true;
                _requestTodos();
              }
              return new ListTile(
                title: new Center(child: new CircularProgressIndicator()),
              );
            } else {
              return null;
            }
          }
          return new ListTile(
            title: new Text(todos[index].name),
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) =>
                  new TodoDetailPage(todo: todos[index], todoService: widget.todoService))
              );
            },
          );
        },
      ),
    );
  }

  _requestTodos() async {
    List<Todo> newList = await widget.todoService.listBefore(beforeId: todos.last.id);
    _listCompleted = newList.length < TodoListPage.pagingCount;

    _loading = false;
    if (newList.isEmpty) {
      return;
    }
    setState(() {
      todos.addAll(newList);
    });
  }

  Future<Null> _requestNewTodos() async {
    var completer = new Completer();
    var newList = await widget.todoService.listSince(sinceId: todos.first.id);
    completer.complete(null);
    return completer.future.then((_) {
      setState(() {
        todos.insertAll(0, newList);
      });
    });
  }
}
