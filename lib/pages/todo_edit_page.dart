import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:todolist_sample/utilities/strings.dart';

enum TodoEditMode {
  newTodo,
  editTodo,
}

String _editTitle(TodoEditMode editMode) {
  switch (editMode) {
    case TodoEditMode.newTodo:
      return Strings.newTodoTitle;
    case TodoEditMode.editTodo:
      return Strings.editTodoTitle;
  }
  return '';
}

class TodoEditPage extends StatefulWidget {
  final TodoEditMode editMode;
  
  TodoEditPage({Key key,
               @required this.editMode})
              : super(key: key);

  @override
  State createState() => new _TodoEditState(editMode: editMode);
}

class _TodoEditState extends State<TodoEditPage> {
  final TodoEditMode editMode;

  _TodoEditState({this.editMode}) : super();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_editTitle(editMode)),
      ),
      body: _buildComponents(context)
    );
  }

  Widget _buildComponents(BuildContext context) {
    return new SafeArea(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildTodoNameTextField(context),
            ),
            new Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildDescriptionTextField(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoNameTextField(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text('Name'),
        new TextField(
        ),
      ],
    );
  }

  Widget _buildDescriptionTextField(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text('Description'),
        new TextField(
        ),
      ],
    );
  }
}