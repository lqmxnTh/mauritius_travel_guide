import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mauritius_travel_guide/components/app_text.dart';

import '../pages/detail pages/detail_hotel_page.dart';

class HotelListView extends StatelessWidget {
  final CollectionReference placesCollection =
      FirebaseFirestore.instance.collection('hotels');

  HotelListView({Key? key}) : super(key: key);

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
            String documentId = document.id;
            Map<String, dynamic> placeData =
                document.data() as Map<String, dynamic>;
            String placeName = placeData['name'] ?? '';
            String placeImg = placeData['img'] ?? '';
            String placelocation = placeData['location'] ?? '';
            String placereviews = placeData['reviews'].toString();
            String placeprice = placeData['price'].toString();
            String placeDescription = placeData['desc'] ?? '';
            String Favourite = placeData['isFav'].toString();
            // Assuming placeData['Image'] is the array of image strings
            List<String> placeImages = List<String>.from(placeData['Image'] ?? []);

            //add string

            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelDetailsPage(
                        placeName: placeName,
                        placeImg: placeImg,
                        placelocation: placelocation,
                        placeprice: placeprice,
                        placeDescription: placeDescription,
                        placereviews: placereviews,
                        DocumentID: documentId,
                        Favourite: Favourite,
                        placeImages: placeImages,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            placeImg,
                            width: 190,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                placeName,
                                style: const TextStyle(fontSize: 22),
                              ),
                              Row(
                                children: [
                                  AppText(text: placereviews),
                                  const Icon(
                                    Icons.star,
                                    size: 17,
                                    color: Colors.yellow,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                  ),
                                  AppText(text: placelocation),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Rs $placeprice",
                                        style: const TextStyle(
                                            color: Colors.blue, fontSize: 17),
                                      ),
                                      const Text(
                                        "/Night",
                                        style:
                                            TextStyle(color: Colors.blueGrey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const Icon(Icons.arrow_forward)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }).toList(),
        );
      },
    );
  }
}
