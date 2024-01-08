import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mauritius_travel_guide/pages/detail%20pages/detailed_activity_page.dart';

class ActivityPage extends StatefulWidget {
  final String activityId;

  const ActivityPage({required this.activityId, Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final searchController = TextEditingController();
  List<DocumentSnapshot> activityList = [];
  List<DocumentSnapshot> filteredList = [];

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    var activitySnapshot = await FirebaseFirestore.instance
        .collection('activities')
        .doc(widget.activityId)
        .collection('detailedActivity')
        .get();

    setState(() {
      activityList = activitySnapshot.docs;
      filteredList = activitySnapshot.docs;
    });
  }

  void searchActivities(String query) {
    setState(() {
      filteredList = activityList.where((activity) {
        var name = activity.get('name') as String;
        return name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('activities')
              .doc(widget.activityId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var activityData = snapshot.data!;
              var title = activityData.get('name') ?? 'Activity Page';
              return Text(title);
            }
            return const Text('Activity Page');
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('activities')
                  .doc(widget.activityId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var activityData = snapshot.data!;
                  var activityName = activityData.get('name') ?? '';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Best Place for: $activityName',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: searchController,
                        onChanged: searchActivities,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: "Search",
                        ),
                      ),
                    ],
                  );
                }
                return const Text(
                  'Activity Page',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                var detailedActivityDoc = filteredList[index];
                var imageUrl = detailedActivityDoc.get('img') ?? '';
                var name = detailedActivityDoc.get('name') ?? '';
                var location = detailedActivityDoc.get('location') ?? '';
                var price = detailedActivityDoc.get('price') ?? '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedActivityPage(
                          detailedActivityDoc: detailedActivityDoc, showPrice: true,
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
                              imageUrl,
                              width: 120,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  location,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Rs $price",
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
