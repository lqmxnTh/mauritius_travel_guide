import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../components/randomGenerator.dart';
import '../../components/reponsive_button.dart';
import 'detail_hotel_page.dart';
import 'detailed_activity_page.dart';

class PackageDetails extends StatelessWidget {
  final Map<String, dynamic> package;

  const PackageDetails(this.package, {super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Package Details',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          child: Image.asset(
                            package['img'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      package['Name'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final hotelReference =
                            package['hotel'] as DocumentReference;
                        final hotelDocument = await hotelReference.get();
                        final hotelData =
                            hotelDocument.data() as Map<String, dynamic>;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HotelDetailsPage(
                              placeName: hotelData['name'],
                              placeImg: hotelData['img'],
                              placelocation: hotelData['location'],
                              placereviews: hotelData['reviews'].toString(),
                              placeprice: '',
                              placeDescription: hotelData['desc'],
                              placeImages:
                                  List<String>.from(hotelData['Image'] ?? []),
                              DocumentID: '',
                              Favourite: hotelData['isFav'].toString(),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'View Hotel Details',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: Rs${package['Price'].toString()}',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        Text('Duration: ${package['Duration']}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.deepOrangeAccent,
                                fontWeight: FontWeight.bold)),
                        Text(
                            'Number of Persons: ${package['Person'].toString()}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.deepOrangeAccent,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text('Accommodation:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    for (var accommodation in package['Accomodation'])
                      Text('- $accommodation'),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exploration:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        for (var explorationReference in package['Exploration'])
                          FutureBuilder<DocumentSnapshot>(
                            future: explorationReference.get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final DocumentSnapshot activityDocument =
                                    snapshot.data as DocumentSnapshot;
                                String activityName =
                                    activityDocument['name'] ?? '';

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailedActivityPage(
                                          detailedActivityDoc: activityDocument,
                                          showPrice: false,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('- $activityName',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                      )),
                                );
                              } else {
                                return Text('- Activity Not Found');
                              }
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Package Inclusions:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    for (var inclusion in package['Package_Inclusion'])
                      Text('- $inclusion'),
                    const SizedBox(height: 10),
                    const Text('Package Exclusions:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    for (var exclusion in package['Package_Exclusion'])
                      Text('- $exclusion'),
                    const SizedBox(height: 10),
                    Text('Relaxation: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('- ${package['Relaxation']}'),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ResponsiveButton(
                      isResponsive: true,
                      onTap: () async {
                        String? email =
                            FirebaseAuth.instance.currentUser?.email;

                        if (email != null) {
                          CollectionReference bookingCollection =
                              FirebaseFirestore.instance.collection('booking');
                          QuerySnapshot querySnapshot = await FirebaseFirestore
                              .instance
                              .collection('users')
                              .where('email', isEqualTo: email)
                              .get();

                          if (querySnapshot.size > 0) {
                            // Assuming email is unique, so there should be only one document
                            DocumentSnapshot userDocument =
                                querySnapshot.docs[0];
                            String username = userDocument['name'];

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Booking'),
                                  content: const Text(
                                      'Are you sure you want to book?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () async {
                                        final String packageStartDate = package['date'];
                                        final DateFormat dateFormat = DateFormat('MMMM dd, yyyy');

                                        DateTime startDate = dateFormat.parse(packageStartDate);

                                        // Loop through your activities and create a booking document for each one
                                        for (var explorationReference in package['Exploration']) {
                                          final DocumentReference activityReference = explorationReference as DocumentReference;
                                          final DocumentSnapshot activityDocument = await activityReference.get();

                                          if (activityDocument.exists) {
                                            String activityName = activityDocument['name'];
                                            String activityImg = activityDocument['img'];
                                            String activityLocation = activityDocument['location'];
                                            String refCode = generateRandomString(15);

                                            // Format the date for this activity by adding 2 days to the start date
                                            String activityDate = dateFormat.format(startDate);
                                            startDate = startDate.add(Duration(days: 2));

                                            // Here, you can create a booking document in the 'booking' collection
                                            // and populate it with the necessary fields.
                                            await FirebaseFirestore.instance.collection('booking').add({
                                              'activity': activityName,
                                              'date': activityDate,
                                              'email': email,
                                              'end_time': "11:00",
                                              'img': activityImg,
                                              'location': activityLocation,
                                              'name': username,
                                              'price': 0,
                                              'ref': refCode,
                                              'start_time': "10:00",
                                              'status': 'active',
                                              'tickets': package['Person'],
                                              // Add other fields as needed
                                            });
                                          }
                                        }

                                        // Close the dialog
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // User is not authenticated or email is not available
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Scaffold(
        body: Center(
          child: Text(
            e.toString(),
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }
}
