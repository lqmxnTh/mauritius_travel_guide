import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlaceDetailsPage extends StatelessWidget {
  final String placeId;

  const PlaceDetailsPage({required this.placeId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('places').doc(placeId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Place Details'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Place Details'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Place Details'),
            ),
            body: const Center(
              child: Text('Place details not found.'),
            ),
          );
        }

        Map<String, dynamic>? placeData = snapshot.data!.data() as Map<String, dynamic>?;

        if (placeData == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Place Details'),
            ),
            body: const Center(
              child: Text('Place details not found.'),
            ),
          );
        }

        String placeName = placeData['name'] ?? '';
        String placeImg = placeData['img'] ?? '';
        String placeDescription = placeData['description'] ?? '';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Place Details'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: Image.network(
                  placeImg,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      placeName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      placeDescription,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
