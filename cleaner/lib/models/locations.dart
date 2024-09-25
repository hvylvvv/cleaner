import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadPickupData() async {
  final firestore = FirebaseFirestore.instance;

  // Your reorganized JSON data
  final Map<String, dynamic> pickupData = {
    "Mark Lane": ["Monday", "Thursday"],
    "Johns Lane": ["Monday", "Thursday"],
    "Georges Lane": ["Monday", "Thursday"],
    "Rum Lane": ["Monday", "Thursday"],
    "Rosemary Lane": ["Monday", "Thursday"],
    "Maiden Lane": ["Tuesday", "Friday"],
    "Gold Street": ["Tuesday", "Friday"],
    "Foster Lane": ["Tuesday", "Friday"],
    "Fleet Street": ["Wednesday", "Saturday"],
    "Higholbourne Street": ["Wednesday", "Saturday"],
    "Ladd Lane": ["Wednesday", "Saturday"],
    "Ocean Boulevard": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    "Pechon Street": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    "Rose Lane": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    "North Street": ["MonC&ab_chaday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    "King Street": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    "Beeston Street": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    "East Queen Street": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    "Victoria Avenue": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  };

  // Upload each location and its pickup days to Firestore
  pickupData.forEach((location, days) async {
    await firestore.collection('locations').doc(location).set({
      'days': days,
    });
  });

  print("Pickup data uploaded successfully!");
  uploadPickupData();
}
