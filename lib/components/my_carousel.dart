import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../pages/detail pages/detail_package_deal.dart';

class PackageCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('packages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No packages available.');
        }

        List<Map<String, dynamic>> packages = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        return CarouselSlider(
          items: packages.map((package) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PackageDetails(package),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity, // Maximum width
                    child: Image.asset(
                      package['img'],
                      fit: BoxFit.cover, // Ensure the image covers the entire container
                    ),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            // Other carousel options...
          ),
        );
      },
    );
  }
}
