import 'package:flutter/material.dart';

class EditableLabel extends StatefulWidget {
  final String initialLabel;

  EditableLabel({required this.initialLabel});

  @override
  _EditableLabelState createState() => _EditableLabelState();
}

class _EditableLabelState extends State<EditableLabel> {
  TextEditingController _textEditingController = TextEditingController();
  bool _isEditing = false;
  late String _labelValue;

  @override
  void initState() {
    super.initState();
    _labelValue = widget.initialLabel;
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _textEditingController.text = _labelValue;
    });
  }

  void _saveValue() {
    setState(() {
      _labelValue = _textEditingController.text;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _isEditing
              ? TextField(
            controller: _textEditingController,
            autofocus: true,
          )
              : Text(_labelValue),
        ),
        SizedBox(width: 10),
        _isEditing
            ? IconButton(
          icon: Icon(Icons.save),
          onPressed: _saveValue,
        )
            : IconButton(
          icon: Icon(Icons.edit),
          onPressed: _startEditing,
        ),
      ],
    );
  }
}