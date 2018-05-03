import 'package:flutter/material.dart';

import 'package:todolist_sample/models/todo.dart';
import 'package:todolist_sample/pages/todo_detail_page.dart';
import 'package:todolist_sample/pages/todo_edit_page.dart';
import 'package:todolist_sample/services/todo_service.dart';

class TodoListPage extends StatelessWidget {
  final String title;

  final TodoService _todoService = new TodoService(source: TodoServiceSource.dummy);

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
                  builder: (context) => new TodoEditPage(editMode: TodoEditMode.newTodo),
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

  _TodoListViewState({this.todos}) : assert(todos != null);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index >= todos.length) {
          if (!_loading) {
            _loading = true;
            _requestTodos();
          }
          if (index == todos.length) {
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
                new TodoDetailPage(todo: todos[index]))
            );
          },
        );
      },
    );
  }

  _requestTodos() async {
    if (_listCompleted) return;

    List<Todo> newList = await widget.todoService.list();
    _listCompleted = newList.isEmpty;

    if (newList.isEmpty) {
      return;
    }
    setState(() {
      todos.addAll(newList);
      _loading = false;
    });
  }
}
