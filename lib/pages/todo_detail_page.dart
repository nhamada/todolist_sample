import 'package:flutter/material.dart';

import 'package:todolist_sample/models/todo.dart';
import 'package:todolist_sample/pages/todo_edit_page.dart';
import 'package:todolist_sample/services/todo_service.dart';

class TodoDetailPage extends StatelessWidget {
  final Todo todo;
  final TodoService todoService;

  TodoDetailPage({Key key, this.todo, this.todoService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.todo.name),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new TodoEditPage(todo: todo, todoService: todoService),
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