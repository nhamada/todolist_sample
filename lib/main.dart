import 'package:flutter/material.dart';

import 'package:todolist_sample/pages/todolist_page.dart';
import 'package:todolist_sample/utilities/strings.dart';

void main() => runApp(new TodoListApp());

class TodoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Strings.appTitle,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TodoListPage(title: Strings.appTitle),
    );
  }
}
