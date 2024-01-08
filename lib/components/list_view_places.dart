import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mauritius_travel_guide/components/app_text.dart';
import '../pages/detail pages/detail_place_page.dart'; // Import the PlaceDetailsPage

class PlacesListView extends StatelessWidget {
  final CollectionReference placesCollection =
  FirebaseFirestore.instance.collection('places');

  PlacesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: placesCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> placeData =
            document.data() as Map<String, dynamic>;
            String placeId = document.id;
            String placeName = placeData['name'] ?? '';
            String placeImg = placeData['img'] ?? '';
            String placelocation = placeData['location'] ?? '';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceDetailsPage(placeId: placeId),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Container(
                      width: 270,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(placeImg),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 270,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              placeName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            AppText(
                              text: placelocation,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlaceDetailsPage(placeId: placeId),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'View Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
