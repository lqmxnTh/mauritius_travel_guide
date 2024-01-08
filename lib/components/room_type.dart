import 'package:flutter/material.dart';

class RoomTypeSelectionWidget extends StatefulWidget {
  RoomTypeSelectionWidget({Key? key}) : super(key: key);

  @override
  _RoomTypeSelectionWidgetState createState() => _RoomTypeSelectionWidgetState();
}

class _RoomTypeSelectionWidgetState extends State<RoomTypeSelectionWidget> {
  String? selectedRoomType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Room Type",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<String>(
                value: 'Seaside View',
                groupValue: selectedRoomType,
                onChanged: (value) {
                  setState(() {
                    selectedRoomType = value;
                  });
                },
              ),
              const Text("Seaside View"),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Mountain View',
                groupValue: selectedRoomType,
                onChanged: (value) {
                  setState(() {
                    selectedRoomType = value;
                  });
                },
              ),
              const Text("Mountain View"),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Pool View',
                groupValue: selectedRoomType,
                onChanged: (value) {
                  setState(() {
                    selectedRoomType = value;
                  });
                },
              ),
              const Text("Pool View"),
            ],
          ),
        ],
      ),
    );
  }
}
