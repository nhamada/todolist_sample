import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:todolist_sample/models/todo.dart';
import 'package:todolist_sample/services/todo_service.dart';
import 'package:todolist_sample/utilities/strings.dart';

DateTime _startDateTime() {
  return new DateTime.fromMicrosecondsSinceEpoch(0);
}

DateTime _endDateTime() {
  return new DateTime(2030, 12, 31);
}

class TodoEditPage extends StatefulWidget {
  final Todo todo;
  final TodoService todoService;

  TodoEditPage({Key key, this.todo, this.todoService})
    : assert(todoService != null),
      super(key: key);

  @override
  State createState() => new _TodoEditState(todo: todo);
}

class _TodoEditState extends State<TodoEditPage> {
  final Todo todo;

  final TextEditingController _nameController = new TextEditingController();
  final FocusNode _nameFocusNode = new FocusNode();

  final TextEditingController _descController = new TextEditingController();
  final FocusNode _descFocusNode = new FocusNode();

  DateTime _startDate;
  DateTime _endDate;

  bool _processing = false;

  _TodoEditState({this.todo}) : super();

  @override
  void initState() {
    if (todo != null) {
      _nameController.text = todo.name;
      _descController.text = todo.description;
      _startDate = todo.startTime;
      _endDate = todo.endTime;
    } else {
      _startDate = new DateTime.now();
      _endDate = new DateTime.now();
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    _descController.dispose();
    _descFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
              todo == null ? Strings.newTodoTitle : Strings.editTodoTitle),
        ),
        body: _buildComponents(context));
  }

  Widget _buildComponents(BuildContext context) {
    if (_processing) {
      return new Stack(
        children: <Widget>[
          _buildEditPage(context),
          _buildProcessingPage(),
        ],
      );
    }
    return _buildEditPage(context);
  }

  void _showStartDatePicker() async {
    var diff = _endDate.difference(_startDate);

    var selected = await showDatePicker(
      context: context,
      firstDate: _startDateTime(),
      lastDate: _endDateTime(),
      initialDate: _startDate,
    );
    if (selected != null) {
      setState(() {
        _startDate = selected;
        if (_startDate.isAfter(_endDate)) {
          _endDate = _startDate.add(diff);
        }
      });
    }
  }

  void _showEndDatePicker() async {
    var diff = _endDate.difference(_startDate);

    var selected = await showDatePicker(
      context: context,
      firstDate: _startDateTime(),
      lastDate: _endDateTime(),
      initialDate: _endDate,
    );
    if (selected != null) {
      setState(() {
        _endDate = selected;
        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate.subtract(diff);
        }
      });
    }
  }

  bool _validateFields() {
    if (_nameController.text == null || _nameController.text.isEmpty) {
      return false;
    }
    if (_endDate.isBefore(_startDate)) {
      return false;
    }
    return true;
  }

  Widget _buildProcessingPage() {
    return new Container(
      color: new Color.fromRGBO(0, 0, 0, 0.6),
      padding: new EdgeInsets.all(0.0),
      child: new Center(child: new CircularProgressIndicator()),
    );
  }

  Widget _buildEditPage(BuildContext context) {
    return new SingleChildScrollView(
      child: new SafeArea(
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
              _buildTodoDateWidgets(),
              new Divider(),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  child: new Text(Strings.saveTodo),
                  onPressed: _validateFields() ? _onSaveTodo : null,
                ),
              ),
            ],
          ),
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
          controller: _nameController,
          focusNode: _nameFocusNode,
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
          controller: _descController,
          focusNode: _descFocusNode,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }

  Widget _buildTodoDateWidgets() {
    return new Column(
      children: <Widget>[
        new GestureDetector(
          onTap: _showStartDatePicker,
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(Strings.todoStartDateLabel),
                  new Text(Strings.formattedDateString(_startDate)),
                ],
              ),
            ),
        ),
        new GestureDetector(
          onTap: _showEndDatePicker,
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(Strings.todoEndDateLabel),
                  new Text(Strings.formattedDateString(_endDate)),
                ],
              ),
            ),
        ),
      ],
    );
  }

  _onSaveTodo() async {
    setState(() {
      _processing = true;
    });
    if (_nameFocusNode.hasFocus) {
      _nameFocusNode.unfocus();
    }
    if (_descFocusNode.hasFocus) {
      _descFocusNode.unfocus();
    }

    if (todo == null) {
      Todo newTodo = await widget.todoService.add(name: _nameController.text,
                                                  description: _descController.text,
                                                  startDate: _startDate,
                                                  endDate: _endDate);
    setState(() {
      _processing = false;
    });
      if (newTodo != null) {
        Navigator.of(context).pop();
      }
    } else {
      Todo updatedTodo = await widget.todoService.update(id: todo.id,
                                                         name: _nameController.text,
                                                         description: _descController.text,
                                                         startDate: _startDate,
                                                         endDate: _endDate,
                                                        );
      setState(() {
        _processing = false;
      });
      if (updatedTodo != null) {
        Navigator.of(context).pop();
      }
    }
  }
}
