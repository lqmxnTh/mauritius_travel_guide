import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mauritius_travel_guide/components/list_view_hotel.dart';
import 'package:mauritius_travel_guide/components/list_view_builder.dart';
import 'package:mauritius_travel_guide/components/list_view_places.dart';
import 'package:mauritius_travel_guide/components/my_carousel.dart';
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  late String loggedInUserName = '';
  final user = FirebaseAuth.instance.currentUser!;
  final searchController = TextEditingController();
  late User? currentUser;
  List<String> docIds = [];
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection("activities")
        .get()
        .then((value) => value.docs.forEach((element) {
      docIds.add(element.reference.id);
    }));
  }
  void getCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      fetchUserName(currentUser!.email!);
    }
  }
  void fetchUserName(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final userData = snapshot.docs.first.data();
      setState(() {
        loggedInUserName = userData['name'];
      });
    }
  }
  void signOut() {
    FirebaseAuth.instance.signOut();
  }
  Future<String> getImagePath(String documentId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('activities')
        .doc(documentId)
        .get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      final imagePath = data['img'] as String?;
      if (imagePath != null) {
        return imagePath;
      }
    }
    return '';
  }
  List<Map<String, dynamic>> packages = [];
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getDocId();
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/Beach1.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Welcome,",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              loggedInUserName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              String.fromCharCodes(Runes(
                                  '\u{1F44B}')),style: const TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          "Discover packages",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      child: PackageCarousel(),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Activities'),
                    Tab(text: 'Historic Places'),
                    Tab(text: 'Hotels'),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.transparent, // Set the background color to transparent
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListViewBuilder(),
                      PlacesListView(),
                      HotelListView()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
