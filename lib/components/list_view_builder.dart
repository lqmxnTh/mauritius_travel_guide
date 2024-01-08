import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mauritius_travel_guide/pages/activity_page.dart';
import '../read data/get_activities_name.dart';

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key}) : super(key: key);

  Future<List<String>> getDocIds() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('activities').get();

    return snapshot.docs.map((doc) => doc.reference.id).toList();
  }

  Future<List<String>> getImageUrls() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('activities').get();

    return snapshot.docs
        .map((doc) => doc.get('img') as String?)
        .where((imageUrl) => imageUrl != null)
        .cast<String>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: FutureBuilder<List<String>>(
        future: getDocIds(),
        builder: (context, docIdsSnapshot) {
          if (!docIdsSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return FutureBuilder<List<String>>(
            future: getImageUrls(),
            builder: (context, imageUrlsSnapshot) {
              if (!imageUrlsSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<String> docIds = docIdsSnapshot.data!;
              List<String> imageUrls = imageUrlsSnapshot.data!;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: docIds.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityPage(
                            activityId: docIds[index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        width: 300,
                        height: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                child: GetActivityName(
                                  documentId: docIds[index]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
