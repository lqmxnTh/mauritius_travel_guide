import 'package:flutter/material.dart';

class SelectionField extends StatefulWidget {
  SelectionField({Key? key}) : super(key: key);

  @override
  _SelectionFieldState createState() => _SelectionFieldState();
}

class _SelectionFieldState extends State<SelectionField> {
  String selectedOption = '2 adults';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: selectedOption,
        onChanged: (String? newValue) {
          setState(() {
            selectedOption = newValue!;
          });
        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        underline: Container(
          height: 2,
          color: Colors.transparent,
        ),
        dropdownColor: Colors.white,
        isExpanded: true,
        items: <String>[
          '2 adults',
          '2 adults with children',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
