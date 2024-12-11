import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cleaner/screens/request_pickup.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cleaner/widgets/appbar.dart';
import 'package:cleaner/widgets/navbar.dart';
import 'package:intl/intl.dart';
import 'package:cleaner/screens/report.dart';
import '../screens/account.dart';
import 'package:cleaner/screens/create_community_post.dart';
import 'package:url_launcher/url_launcher.dart';




class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getCommunityName(String userId) async {
    try {
      // Fetch the user document by userId
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        // Access the AddressNeighbourhood field (community name)
        String communityName = userSnapshot.get('AddressNeighbourhood');
        return communityName;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<String?> getStreetName(String userId) async {
    try {
      // Fetch the user document by userId
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        // Access the AddressLine1 field
        String addressLine1 = userSnapshot.get('AddressLine1');

        // Extract the street name (e.g., "Mark Lane" from "5 Mark Lane")
        String streetName = extractStreetName(addressLine1);

        // Fetch the locations document using the street name
        DocumentSnapshot locationSnapshot = await _firestore.collection('locations').doc(streetName).get();

        if (locationSnapshot.exists) {
          // You can access other data in the location document if needed
          // For example, return the street name or any other relevant field
          return streetName;  // or locationSnapshot.get('desiredField');
        } else {
          print('Location not found');
          return null;
        }
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  String extractStreetName(String addressLine1) {
    // Assuming address format "5 Mark Lane", we can split it and get the last part
    List<String> parts = addressLine1.split(' ');
    if (parts.length > 1) {
      return parts.sublist(1).join(' '); // Join the parts after the first one
    }
    return addressLine1; // Return the original if no split occurs
  }

}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isCalendarVisible = false;
  String _nextPickupDate = 'Loading...';
  String? _communityName;
  List<String> pickupDays = [];


  @override
  void initState() {
    super.initState();
    fetchCommunityAndPickupDate();
  }


  Future<String?> getStreetName(String userId) async {
    try {
      // Fetch the user document by userId
      DocumentSnapshot userSnapshot = await firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        // Access the AddressLine1 field (or however your street name is stored)
        String addressLine1 = userSnapshot.get('AddressLine1');
        String streetName = extractStreetName(addressLine1); // Implement this function
        return streetName;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

// This is a simple example of extracting the street name from the address
  String extractStreetName(String address) {
    // Split the address by spaces and return the last part
    // You can customize this logic based on your address format
    List<String> parts = address.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : address; // Adjust as needed
  }


  Future<void> fetchCommunityAndPickupDate() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = user?.uid; // Replace with actual user ID

    // Fetch the community name
    String? community = await UserService().getCommunityName(userId!);

    if (community != null) {
      setState(() {
        _communityName = community;
        print(_communityName);
      });
      fetchNextPickupDate(community); // Fetch next pickup date using the community name
    } else {
      // If community name is not found, check the street name
      String? streetName = await UserService().getStreetName(userId);
      if (streetName != null) {
        setState(() {
          print("Street name found: $streetName");
        });
        fetchNextPickupDate(streetName); // Fetch next pickup date using the street name
      } else {
        setState(() {
          _nextPickupDate = 'Community not found';
        });
      }
    }
  }

  Future<void> fetchNextPickupDate(String name) async {
    try {
      name = name.trim();
      // Fetch the document for the community or street name
      DocumentSnapshot locationSnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .doc(name)
          .get();

      // Check if the document exists
      if (locationSnapshot.exists) {
        // Fetch the 'days' field
        List<dynamic> pickupDays = locationSnapshot.get('days');

        // Log fetched days for debugging
        print("Fetched pickup days: $pickupDays");

        if (pickupDays.isNotEmpty) {
          // Find the next pickup date
          DateTime? nextPickup = getNextPickupDateForMultipleDays(List<String>.from(pickupDays));

          setState(() {
            _nextPickupDate = nextPickup != null
                ? DateFormat('EEEE, d/M').format(nextPickup)
                : 'No pickup days available';
            this.pickupDays = List<String>.from(pickupDays);  // Store pickup days for the dialog
          });
        } else {
          setState(() {
            _nextPickupDate = 'No pickup days found';
          });
        }
      } else {
        print("Location document not found for $name");
        setState(() {
          _nextPickupDate = 'No address found';
        });
      }
    } catch (e) {
      setState(() {
        _nextPickupDate = 'Error loading date';
      });
      print('Error fetching pickup date: $e');
    }
  }

  DateTime? getNextPickupDateForMultipleDays(List<String> pickupDays) {
    Map<String, int> dayOfWeekMap = {
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };

    DateTime today = DateTime.now();
    List<DateTime> nextPickupDates = [];

    for (String pickupDay in pickupDays) {
      int pickupDayIndex = dayOfWeekMap[pickupDay]!;
      int todayIndex = today.weekday;

      int daysUntilNextPickup = (pickupDayIndex - todayIndex + 7) % 7;
      if (daysUntilNextPickup == 0) {
        daysUntilNextPickup = 7;
      }

      DateTime nextPickupDate = today.add(Duration(days: daysUntilNextPickup));
      nextPickupDates.add(nextPickupDate);
    }

    nextPickupDates.sort();
    return nextPickupDates.isNotEmpty ? nextPickupDates.first : null;
  }



  void toggleCalendarVisibility() {
    setState(() {
      _isCalendarVisible = !_isCalendarVisible;
    });
  }

  void navigateToPickupForm() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RequestPickup(),
      ),
    );
  }

  Future<void> openExternalLink(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // toolbarHeight: 70.0,
          title: Text(
          'Cleaner+',
          style: TextStyle(
          color: Colors.white,
          fontFamily: 'MontserratAlternates',
          fontSize: screenWidth * 0.08,
          fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF599954),

        ),
        endDrawer: const Navbar(),
        body: content(),
      ),
    );
  }

  Widget content() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: FractionallySizedBox(
        widthFactor: screenWidth * 0.0023,
        heightFactor: screenWidth * 0.0023,
        child: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              SizedBox(height: screenWidth * 0.0023),
              Container(
                padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                ),
                width: screenWidth * 0.9,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Next Collection Date:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Text(
                            _nextPickupDate,
                            style: const TextStyle(
                              color: Color(0xFF599954),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline, color: Color(0xFF599954)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("What's this?"),
                                    content: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(color: Colors.black, fontSize: 16),
                                        children: [
                                          const TextSpan(
                                            text: 'Your pickup date is the next date that the garbage in your area is scheduled to be collected.\n\n',
                                          ),
                                          const TextSpan(
                                            text: 'For ',
                                          ),
                                          TextSpan(
                                            text: '$_communityName',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const TextSpan(
                                            text: ', collection is scheduled for: ',
                                          ),
                                          TextSpan(
                                            text: pickupDays.join(',\n\n\n'),
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          // TextSpan(
                                          //   text: '\n\n\nIf you get an error, try using the Quick Links section to visit the NSWMA Website, and enter a listed location closest to you in th 'Update Your Account Information' Section '.',
                                          //   style: const TextStyle(fontWeight: FontWeight.bold),
                                          // ),

                                          const TextSpan(
                                            text: '\n\n\nIf you get an error, try using the ',
                                            style: TextStyle(fontWeight: FontWeight.normal),
                                            children: [
                                              TextSpan(
                                                text: 'Quick Links',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ' section to',
                                                style: TextStyle(fontWeight: FontWeight.normal),
                                              ),
                                              TextSpan(
                                                text: ' Visit the NSWMA Website',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ', and enter a listed location closest to you in the ',
                                                style: TextStyle(fontWeight: FontWeight.normal),
                                              ),
                                              TextSpan(
                                                text: 'Update Your Account Information',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ' Section.',
                                                style: TextStyle(fontWeight: FontWeight.normal),
                                              ),
                                            ],
                                          )


                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),


                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: ElevatedButton(
                        onPressed: toggleCalendarVisibility,
                        child: Text(
                          _isCalendarVisible ? 'Hide Calendar' : 'See Calendar',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    if (_isCalendarVisible) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            children: [
                              TableCalendar(
                                rowHeight: 50,
                                headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                ),
                                focusedDay: DateTime.now(),
                                firstDay: DateTime.utc(2024, 01, 01),
                                lastDay: DateTime.utc(2055),
                                calendarStyle: const CalendarStyle(
                                  weekendTextStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                  isTodayHighlighted: true,
                                  selectedDecoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: navigateToPickupForm,
                                style: ButtonStyle(
                                  backgroundColor:
                                  WidgetStateProperty.all<Color>(
                                    const Color.fromRGBO(24, 151, 158, 1),
                                  ),
                                ),
                                child: const Text(
                                  'Request Pickup',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              Container(
                padding: const EdgeInsets.only(left: 10), // Optional padding for spacing from the left
                alignment: Alignment.centerLeft, // Aligns the text to the left
                child: const Text(
                  "Quick Links",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10), // Add spacing between "Quick Links" and the text


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      navigateToPickupForm();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "Request a Pick-up",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,

                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5), // Spacing between tappable texts
                  GestureDetector(
                    onTap: ()
                    {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Report(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "File a Report",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,

                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 5), // Spacing between tappable texts
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Account(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "Update Your Account Information",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,

                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5), // Spacing between tappable texts
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Community(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "View Current Notices & Alerts",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,

                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5), // Spacing between tappable texts
                  GestureDetector(
                    onTap: () {
                      openExternalLink('https://www.nswma.gov.jm/collection-schedule/');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "Visit the NSWMA website",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}