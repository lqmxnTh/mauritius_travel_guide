// ignore_for_file: empty_catches, use_build_context_synchronously, library_private_types_in_public_api

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mauritius_travel_guide/components/room_type.dart';
import 'package:mauritius_travel_guide/components/selection.dart';
import '../../components/app_button.dart';
import '../../components/app_large_text.dart';
import '../../components/app_text.dart';
import '../../components/check_in_check_out.dart';
import '../../components/randomGenerator.dart';
import '../../components/reponsive_button.dart';

class HotelDetailsPage extends StatefulWidget {
  final String placeName;
  final String placeImg;
  final String placelocation;
  final String placereviews;
  final String placeprice;
  final String placeDescription;
  final String DocumentID;
  final String Favourite;
  final List<String> placeImages;

  const HotelDetailsPage({
    super.key,
    required this.placeName,
    required this.placeImg,
    required this.placelocation,
    required this.placereviews,
    required this.placeprice,
    required this.placeDescription,
    required this.placeImages,
    required this.DocumentID,
    required this.Favourite,
  });

  @override
  _HotelDetailsPageState createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  bool isFav = false;
  bool _showFullDescription = false;
  int _selectedButton = 1;
  late DateTime selectedDateTime;
  DateTime? selectedCheckOutDate;
  DateTime? selectedCheckInDate;

  bool getFavValue() {
    if (widget.Favourite == "true") {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
    isFav = getFavValue();
  }

  void _updateFavInDatabase() async {
    try {
      String docId = widget.DocumentID;
      CollectionReference hotelsCollection =
          FirebaseFirestore.instance.collection('hotels');
      await hotelsCollection.doc(docId).update({'isFav': isFav});
    } catch (e) {}
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1.0, // Each image takes the full width
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                // Handle page change here
              },
              height: 250, // Adjust the height to your desired value
            ),
            items: widget.placeImages.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Image.network(
                    image,
                    fit: BoxFit.cover,
                  );
                },
              );
            }).toList(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppLargeText(
                          text: widget.placeName,
                          color: const Color.fromARGB(255, 69, 135, 168),
                          size: 30,
                        ),
                        if (widget.placeprice != '')
                          AppLargeText(
                            text: "Rs ${widget.placeprice}/Night",
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
                          text: widget.placelocation,
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
                              color: index < num.parse(widget.placereviews)
                                  ? Colors.yellow
                                  : Colors.grey,
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AppText(
                          text: widget.placereviews.toString(),
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppLargeText(
                      text: "Description",
                      color: Colors.black.withOpacity(0.8),
                      size: 20,
                    ),
                    const SizedBox(height: 8),
                    _showFullDescription
                        ? Text(
                            widget.placeDescription,
                            style: const TextStyle(fontSize: 18),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getTruncatedDescription(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showFullDescription = true;
                                      });
                                    },
                                    child: const Text(
                                      'See more',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    if (_showFullDescription)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showFullDescription = false;
                          });
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'See less',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    if (widget.placeprice != '')
                      AppLargeText(
                        text: "No. of People",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.placeprice != '') SelectionField(),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.placeprice != '')
                      AppLargeText(
                        text: "Check-In Check-Out",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.placeprice != '')
                      CheckInOutWidget(
                        onCheckInSelected: (date) {
                          setState(() {
                            selectedCheckInDate = date;
                          });
                        },
                        onCheckOutSelected: (date) {
                          setState(() {
                            selectedCheckOutDate = date;
                          });
                        },
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.placeprice != '')
                      AppLargeText(
                        text: "Select Room",
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.placeprice != '') RoomTypeSelectionWidget()
                  ],
                ),
              ),
            ),
          ),
          if (widget.placeprice != '')
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButtons(
                      size: 60,
                      color: Colors.red,
                      backgroundColor: Colors.white,
                      borderColor: Colors.red,
                      onTap: () {
                        setState(() {
                          isFav = !isFav;
                        });
                        _updateFavInDatabase();
                      },
                      icon: isFav ? Icons.favorite : Icons.favorite_border,
                    ),
                    const SizedBox(width: 30),
                    ResponsiveButton(
                      isResponsive: true,
                      onTap: () async {
                        String? email =
                            FirebaseAuth.instance.currentUser?.email;

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
                            DocumentSnapshot userDocument =
                                querySnapshot.docs[0];
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
                                        String refCode =
                                            generateRandomString(15);
                                        bookingCollection.add({
                                          'activity': widget.placeName,
                                          'img': widget.placeImg,
                                          'price': widget.placeprice,
                                          'email': email,
                                          'name': username,
                                          'tickets': _selectedButton,
                                          'date': DateFormat('MMMM dd, yyyy')
                                              .format(selectedCheckOutDate!),
                                          'start_date': DateFormat('MMMM dd, yyyy')
                                              .format(selectedCheckInDate!),
                                          'start_time': '13:00',
                                          'end_time': '16:00',
                                          'location': widget.placelocation,
                                          'status': "active",
                                          'ref': refCode
                                        }).then((value) {
                                          // Data stored successfully

                                          Navigator.of(context)
                                              .pop(); // Close the dialog

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Booking successful'),
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
            ),
        ],
      ),
    );
  }

  String _getTruncatedDescription() {
    if (widget.placeDescription.length > 100) {
      // You can adjust the number of characters to display before truncating
      return '${widget.placeDescription.substring(0, 100)}...';
    }
    return widget.placeDescription;
  }
}
