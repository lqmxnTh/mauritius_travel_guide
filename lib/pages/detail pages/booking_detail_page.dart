import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mauritius_travel_guide/components/my_button.dart';
import '../navpages/booking.dart';

class BookingDetailPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingDetailPage({Key? key, required this.bookingData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String capitalize(String input) {
      if (input.isEmpty) {
        return input;
      }
      return input[0].toUpperCase() + input.substring(1);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${bookingData['name']}',
                      style:
                          const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${bookingData['activity']}',
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      'Reservation: ${bookingData['ref']}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: bookingData['status'] == 'active'
                            ? Colors.greenAccent.withOpacity(0.8)
                            : bookingData['status'] == 'cancel'
                                ? Colors.redAccent.withOpacity(0.8)
                                : bookingData['status'] == 'passed'
                                    ? Colors.grey.withOpacity(0.8)
                                    : Colors
                                        .transparent, // Customize the glow color and opacity
                        spreadRadius:
                            7, // Customize the spread radius of the glow
                        blurRadius: 15, // Customize the blur radius of the glow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                        15), // Half of the width or height to achieve a circular shape
                    color: bookingData['status'] == 'active'
                        ? Colors.greenAccent
                        : bookingData['status'] == 'cancel'
                            ? Colors.redAccent
                            : bookingData['status'] == 'passed'
                                ? Colors.grey
                                : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      capitalize(bookingData['status']),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text("Booking Details"),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[200]),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Issued To:"),
                                    Text('${bookingData['name']}'),
                                  ],
                                ),
                              ],
                            ),
                            if(bookingData['date'] == bookingData['start_date'])
                              Row(
                              children: [
                                const Icon(Icons.confirmation_num_rounded),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Quantity:"),
                                    Text('${bookingData['tickets']}'),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        const Divider(
                          thickness: 1.5,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Allowed Access"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                if(bookingData['date'] == bookingData['start_date'])
                                  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Day"),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text('${bookingData['date']}'),
                                  ],
                                ),
                                if(bookingData['date'] != bookingData['start_date'])
                                  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Day"),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text('${bookingData['start_date']}'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text('${bookingData['date']}'),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.watch_later_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                if(bookingData['date'] == bookingData['start_date'])
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Time(From - To)"),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        '${bookingData['start_time']} - ${bookingData['end_time']}'),
                                  ],
                                ),
                                if(bookingData['date'] != bookingData['start_date'])
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Time"),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Check-In'),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                'Check-Out'),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                ' ${bookingData['start_time']}'),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                ' ${bookingData['end_time']}'),
                                          ],
                                        ),
                                      ],
                                    ),

                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Visibility(
              visible: bookingData['status'] == 'active',
              child: MyButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Cancel Booking'),
                        content: const Text(
                            'Are you sure you want to cancel this booking?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                          TextButton(
                            child: const Text('Continue'),
                            onPressed: () {
                              Navigator.pop(context);
                              FirebaseFirestore.instance
                                  .collection('booking')
                                  .where('ref', isEqualTo: bookingData['ref'])
                                  .get()
                                  .then((snapshot) {
                                if (snapshot.docs.isNotEmpty) {
                                  final document = snapshot.docs.first;
                                  document.reference.update({'status': 'cancel'}).then((_) {
                                    // Update successful
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const BookingPage(), // Replace BookingPage with the desired page you want to navigate to
                                      ),
                                    );
                                  }).catchError((error) {
                                    // Error occurred while updating
                                    // Show an error message or handle the error
                                  });
                                }
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                color: Colors.red,
                btnText: "Cancel Booking",
                icon: Icons.close,
                iconColour: Colors.white,
              ),
            ),
            Visibility(
              visible: bookingData['status'] != 'active',
              child: MyButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Record'),
                        content: const Text(
                            'Are you sure you want to delete this record?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                          TextButton(
                            child: const Text('Continue'),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('booking')
                                  .where('ref', isEqualTo: bookingData['ref'])
                                  .get()
                                  .then((snapshot) {
                                if (snapshot.docs.isNotEmpty) {
                                  final document = snapshot.docs.first;
                                  document.reference.delete().then((_) {
                                    // Deletion successful
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Record deleted'),
                                      ),
                                    );
                                  }).catchError((error) {
                                    // Error occurred while deleting
                                    // Show an error message or handle the error
                                  });
                                }
                              });
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                color: Colors.red,
                btnText: "Delete Record",
                icon: Icons.close,
                iconColour: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
