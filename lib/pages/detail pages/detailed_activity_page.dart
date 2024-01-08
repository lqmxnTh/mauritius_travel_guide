// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../components/app_button.dart';
import '../../components/app_large_text.dart';
import '../../components/app_text.dart';
import '../../components/randomGenerator.dart';
import '../../components/reponsive_button.dart';

class DetailedActivityPage extends StatefulWidget {
  final DocumentSnapshot detailedActivityDoc;
  final bool showPrice;

  const DetailedActivityPage(
      {Key? key, required this.detailedActivityDoc, required this.showPrice})
      : super(key: key);

  @override
  State<DetailedActivityPage> createState() => _DetailedActivityPageState();
}

class _DetailedActivityPageState extends State<DetailedActivityPage> {
  bool isFav = false;
  int _selectedButton = 1;
  bool showFullDescription = false;
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
    isFav = widget.detailedActivityDoc.get('isFav') ?? false;
    widget.detailedActivityDoc.reference.snapshots().listen((snapshot) {
      setState(() {
        isFav = snapshot.get('isFav') ?? false;
      });
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 31)),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var imageUrl = widget.detailedActivityDoc.get('img');
    var name = widget.detailedActivityDoc.get('name');
    var location = widget.detailedActivityDoc.get('location');
    var price = widget.detailedActivityDoc.get('price');
    var reviews = widget.detailedActivityDoc.get('reviews');
    var desc = widget.detailedActivityDoc.get('description');
    var totalPrice = _selectedButton * price;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppLargeText(
                          text: name,
                          color: const Color.fromARGB(255, 69, 135, 168),
                          size: 30,
                        ),
                        if (widget.showPrice == true)
                          AppLargeText(
                            text: "Rs $totalPrice",
                            color: const Color.fromARGB(255, 69, 135, 168),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppLargeText(
                      text: "Location",
                      color: Colors.black.withOpacity(0.8),
                      size: 20,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 69, 135, 168),
                          size: 20,
                        ),
                        AppText(
                          text: location,
                          color: const Color.fromARGB(255, 69, 135, 168),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppLargeText(
                      text: "Reviews",
                      color: Colors.black.withOpacity(0.8),
                      size: 20,
                    ),
                    Row(
                      children: [
                        Wrap(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color:
                                  index < reviews ? Colors.yellow : Colors.grey,
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AppText(
                          text: reviews.toString(),
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppLargeText(
                      text: "Description",
                      color: Colors.black.withOpacity(0.8),
                      size: 20,
                    ),
                    if (showFullDescription)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: desc,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                showFullDescription = false;
                              });
                            },
                            child: const Text(
                              "See Less",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            desc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                showFullDescription = true;
                              });
                            },
                            child: const Text(
                              "See More",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (widget.showPrice == true)
                      AppLargeText(
                        text: "No. of People",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.showPrice == true)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 1; i <= 5; i++)
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedButton == i
                                        ? Colors.blue
                                        : Colors.lightBlue[200],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedButton = i;
                                    });
                                    // Handle button press for button with label i
                                    // You can add your desired functionality here
                                  },
                                  child: Text(i.toString()),
                                ),
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.showPrice == true)
                      AppLargeText(
                        text: "Select Date & Time",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.showPrice == true)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () => _selectDateTime(context),
                            child: const Text('Select DateTime'),
                          ),
                          AppText(
                            text: DateFormat('MMM dd, yyyy - hh:mm a')
                                .format(selectedDateTime),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.showPrice == true)
            Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButtons(
                    size: 60,
                    color: Colors.red,
                    backgroundColor: Colors.white,
                    borderColor: Colors.red,
                    onTap: () {
                      widget.detailedActivityDoc.reference
                          .update({'isFav': !isFav});
                    },
                    icon: isFav ? Icons.favorite : Icons.favorite_border,
                  ),
                  const SizedBox(width: 30),
                  ResponsiveButton(
                    isResponsive: true,
                    onTap: () async {
                      String? email = FirebaseAuth.instance.currentUser?.email;

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
                          DocumentSnapshot userDocument = querySnapshot.docs[0];
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
                                    onPressed: () {
                                      String refCode = generateRandomString(15);
                                      bookingCollection.add({
                                        'activity': name,
                                        'img': imageUrl,
                                        'price': totalPrice,
                                        'email': email,
                                        'name': username,
                                        'tickets': _selectedButton,
                                        'date': DateFormat('MMMM dd, yyyy')
                                            .format(selectedDateTime),
                                        'start_date':
                                            DateFormat('MMMM dd, yyyy')
                                                .format(selectedDateTime),
                                        'start_time': DateFormat('HH:mm')
                                            .format(selectedDateTime),
                                        'end_time': DateFormat('HH:mm').format(
                                            selectedDateTime
                                                .add(const Duration(hours: 1))),
                                        'location': location,
                                        'status': "active",
                                        'ref': refCode
                                      }).then((value) {
                                        // Data stored successfully

                                        Navigator.of(context)
                                            .pop(); // Close the dialog

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Booking successful'),
                                          ),
                                        );
                                      }).catchError((error) {
                                        // Error occurred while storing the data
                                      });
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
        ],
      ),
    );
  }
}
