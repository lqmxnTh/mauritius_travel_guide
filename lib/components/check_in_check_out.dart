import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class CheckInOutWidget extends StatefulWidget {
  CheckInOutWidget({Key? key, required this.onCheckInSelected, required this.onCheckOutSelected})
      : super(key: key);

  final void Function(DateTime?) onCheckInSelected;
  final void Function(DateTime?) onCheckOutSelected;

  @override
  _CheckInOutWidgetState createState() => _CheckInOutWidgetState();
}

class _CheckInOutWidgetState extends State<CheckInOutWidget> {
  DateTime? checkInDate;
  DateTime? checkOutDate;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)), // 2 months from now
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          // Pass the check-in date to the callback function
          widget.onCheckInSelected(checkInDate);
        } else {
          if (checkInDate == null || picked.isAfter(checkInDate!)) {
            checkOutDate = picked;
            // Pass the check-out date to the callback function
            widget.onCheckOutSelected(checkOutDate);
          } else {
            // Invalid selection, show a message or handle it as needed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Invalid Selection"),
                  content: Text("Check-out date cannot be earlier than check-in date."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          }
        }
      });
    }
  }
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context, true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Check-In",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (checkInDate != null)
                    Text(
                      "${checkInDate!.day}/${checkInDate!.month}",
                      style: const TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context, false),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Check-Out",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (checkOutDate != null)
                    Text(
                      "${checkOutDate!.day}/${checkOutDate!.month}",
                      style: const TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
