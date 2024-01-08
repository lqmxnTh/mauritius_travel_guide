import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../detail pages/booking_detail_page.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking"),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(25),
              child: Text(
                'Manage all your booking!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TabBar(
                labelColor: Colors.black,
                unselectedLabelStyle: const TextStyle(color: Colors.black),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                tabs: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Tab(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text('Active'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Tab(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Tab(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text('Passed'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TabBarView(
                  children: [
                    BookingList(status: 'active'),
                    BookingList(status: 'cancel'),
                    BookingList(status: 'passed'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  final String status;

  const BookingList({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String loggedInUserEmail = getCurrentUserEmail();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('booking')
          .where('status', isEqualTo: status)
          .where('email', isEqualTo: loggedInUserEmail)
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
            DateFormat dateFormat = DateFormat("MMMM dd, yyyy");

            DateTime dateObject = dateFormat.parse(booking['date']);
            int day = dateObject.day;
            String month = DateFormat('MMMM').format(dateObject);
            int year = dateObject.year;
            DateTime dateObjectIn = dateFormat.parse(booking['start_date']);
            int dayIn = dateObjectIn.day;
            String monthIn = DateFormat('MMMM').format(dateObjectIn);
            int yearIn = dateObjectIn.year;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailPage(
                      bookingData: booking,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(booking['img']),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.darken),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: ListTile(
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: booking['status'] == 'active'
                                      ? Colors.greenAccent
                                      : booking['status'] == 'cancel'
                                          ? Colors.redAccent
                                          : Colors.grey[400],
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 50, horizontal: 5),
                              ),
                              const SizedBox(width: 30),
                              if(dateObject.toString() == dateObjectIn.toString())
                              Column(
                                children: [
                                  Text(
                                    day.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "$month $year",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              if(dateObject.toString() != dateObjectIn.toString())
                              Column(
                                children: [
                                  Text(
                                    dayIn.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "$monthIn $yearIn",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(" - ",style: const TextStyle(color: Colors.white),),
                                  Text(
                                    day.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "$month $year",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${booking['activity']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  if(dateObject.toString() == dateObjectIn.toString())
                                  Text(
                                    '${booking['start_time']}   -   ${booking['end_time']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.4, // Adjust the width as needed
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 2),
                                    child: Text(
                                      '${booking['location']}',
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  if(dateObject.toString() == dateObjectIn.toString())
                                  Text(
                                    'Tickets: ${booking['tickets']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Ref: ${booking['ref']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email ?? ''; // Return the user's email if available
    }
    return ''; // Return an empty string if the user is not logged in or the email is unavailable
  }
}
