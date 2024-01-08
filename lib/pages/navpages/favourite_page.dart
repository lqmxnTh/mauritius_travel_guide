import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../detail pages/detail_hotel_page.dart';
import '../detail pages/detailed_activity_page.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CollectionReference activitiesCollection =
  FirebaseFirestore.instance.collection('activities');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Activities'),
            Tab(text: 'Hotels'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivitiesTab(),
          _buildHotelsTab(),
        ],
      ),
    );
  }

  Widget _buildActivitiesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: activitiesCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.hasData) {
          final activities = snapshot.data!.docs;

          final favoriteDetailedActivities = activities
              .map((activity) => activity.reference
              .collection('detailedActivity')
              .snapshots())
              .toList();

          return favoriteDetailedActivities.isEmpty
              ? const Center(
            child: Text("No Data"),
          )
              : ListView.builder(
            itemCount: favoriteDetailedActivities.length,
            itemBuilder: (BuildContext context, int index) {
              return StreamBuilder<QuerySnapshot>(
                stream: favoriteDetailedActivities[index],
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.hasData) {
                    final detailedActivities = snapshot.data!.docs;

                    final favoriteDetailedActivities =
                    detailedActivities.where((detailedActivity) =>
                    detailedActivity.get('isFav') == true);


                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: favoriteDetailedActivities.map(
                            (detailedActivity) {
                          return Column(
                            children: [
                              const SizedBox(height: 15),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailedActivityPage(
                                            detailedActivityDoc:
                                            detailedActivity, showPrice: true,
                                          ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          child: Image.network(
                                            detailedActivity['img'],
                                            width: 120,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                detailedActivity[
                                                'name'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                detailedActivity[
                                                'location'],
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "Rs ${detailedActivity['price']}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey,
                                            borderRadius:
                                            BorderRadius.circular(
                                                30),
                                          ),
                                          padding:
                                          const EdgeInsets.all(3),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    );
                  }

                  return const SizedBox.shrink();
                },
              );
            },
          );
        }

        return const Text('No data available');
      },
    );
  }
}

Widget _buildHotelsTab() {
  CollectionReference hotelsCollection =
  FirebaseFirestore.instance.collection('hotels');

  return StreamBuilder<QuerySnapshot>(
    stream: hotelsCollection.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.hasData) {
        final hotels = snapshot.data!.docs;
        final favoriteHotels =
        hotels.where((hotel) => hotel.get('isFav') == true).toList();

        return favoriteHotels.isEmpty
            ? const Center(
          child: Text("No Favorite Hotels"),
        )
            : ListView.builder(
          itemCount: favoriteHotels.length,
          itemBuilder: (BuildContext context, int index) {
            final hotel = favoriteHotels[index];

            return Column(
              children: [
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    // Navigate to the HotelDetailsPage when tapping on a hotel card
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelDetailsPage(
                          placeName: hotel['name'],
                          placeImg: hotel['img'],
                          placelocation: hotel['location'],
                          placereviews: hotel['reviews'].toString(),
                          placeprice: hotel['price'].toString(),
                          placeDescription: hotel['desc'],
                          DocumentID: hotel.reference.id,
                          Favourite: hotel['isFav'].toString(), placeImages:List<String>.from(hotel['Image'] ?? []),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              hotel['img'],
                              width: 120,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  hotel['location'],
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Rs ${hotel['price']}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.all(3),
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }

      return const Text('No favorite hotels data available');
    },
  );
}



