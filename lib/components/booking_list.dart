import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingList extends StatelessWidget {
  final String status;

  const BookingList({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('booking')
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final bookings = snapshot.data!.docs;
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text('Activity: ${booking['activity']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: \$${booking['price']}'),
                  Text('Email: ${booking['email']}'),
                  Text('Name: ${booking['name']}'),
                  Text('Tickets: ${booking['tickets']}'),
                  Text('Date: ${booking['date']}'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
