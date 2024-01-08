import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void checkBookingStatus() async {

  CollectionReference bookingsCollection =
  FirebaseFirestore.instance.collection('booking');

  QuerySnapshot querySnapshot = await bookingsCollection.get();
  List<DocumentSnapshot> bookingDocs = querySnapshot.docs;

  DateTime currentDate = DateTime.now();


  for (DocumentSnapshot bookingDoc in bookingDocs) {
    Map<String, dynamic> bookingData = bookingDoc.data() as Map<String, dynamic>;

    String endTime = bookingData['end_time'];
    String status = bookingData['status'];
    String fullDate = bookingData['date'];//September 07, 2023
    DateTime bookingDateTime = DateFormat('MMMM dd, yyyy').parse(fullDate);


    if (isTimeGreaterThanOrEqualNow(endTime)) {
      if (currentDate.isAfter(bookingDateTime)){
        if (status == 'active') {
          await bookingDoc.reference.update({'status': 'passed'});
        }
      }
    }
  }
}

bool isTimeGreaterThanOrEqualNow(String endTime) {
  DateTime now = DateTime.now();

  String currentTime = DateFormat('HH:mm').format(now);
  String formattedEndTime = DateFormat('HH:mm').format(
      DateFormat('HH:mm').parse(endTime));
  return currentTime.compareTo(formattedEndTime) >= 0;
}
