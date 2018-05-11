import 'package:flutter/material.dart';

import 'package:todolist_sample/models/todo.dart';
import 'package:todolist_sample/pages/todo_edit_page.dart';
import 'package:todolist_sample/services/todo_service.dart';

class TodoDetailPage extends StatefulWidget {
  final int todoId;
  final TodoService todoService;

  TodoDetailPage({Key key, this.todoId, this.todoService}) : super(key: key);

  @override
  State createState() => new _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  Todo _todo;

  @override
  void dispose() {
      super.dispose();
      _todo = null;
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Todo Detail"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new TodoEditPage(todo: _todo, todoService: widget.todoService),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return new FutureBuilder(
      future: widget.todoService.get(widget.todoId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return new Text(snapshot.error.toString());
        }

        if (snapshot.hasData) {
          _todo = snapshot.data;
          return _buildTodoDetail(_todo);
        } else {
          return new Center(child: new CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildTodoDetail(Todo todo) {
    return new SafeArea(
      child: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Text(
              todo.description,
            ),
          ],
        ),
      ),
    );
  }
}