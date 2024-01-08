import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetActivityName extends StatelessWidget {
  final String documentId;

  const GetActivityName({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference activities =
        FirebaseFirestore.instance.collection("activities");
    return FutureBuilder<DocumentSnapshot>(
      future: activities.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic>? data =
                snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null && data.containsKey('name')) {
              return Text(data['name'],style: const TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.w400),);
            }
          }
          return const Text("Invalid Data");
        }
        return const Text("Loading");
      },
    );
  }
}
