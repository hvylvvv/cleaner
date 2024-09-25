



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
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCalendarVisible = false;
  String _nextPickupDate = 'Loading...';
  String? _communityName;
  List<String> pickupDays = [];


  @override
  void initState() {
    super.initState();
    fetchCommunityAndPickupDate();
  }

  // Fetch the community and the next pickup date
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
      setState(() {
        _nextPickupDate = 'Community not found';
      });
    }
  }

  Future<void> fetchNextPickupDate(String communityName) async {
    try {
      // Fetch the document for the community
      DocumentSnapshot communitySnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .doc(communityName)
          .get();

      // Check if the document exists
      if (communitySnapshot.exists) {
        // Fetch the 'days' field
        List<dynamic> pickupDays = communitySnapshot.get('days');

        // Log fetched days for debugging
        print("Fetched pickup days: $pickupDays");

        if (pickupDays.isNotEmpty) {
          // Find the next pickup date
          DateTime? nextPickup = getNextPickupDateForMultipleDays(List<String>.from(pickupDays));

          setState(() {
            _nextPickupDate = nextPickup != null
                ? DateFormat('EEE d/M').format(nextPickup)
                : 'No pickup days available';
            this.pickupDays = List<String>.from(pickupDays);  // Store pickup days for the dialog
          });
        } else {
          setState(() {
            _nextPickupDate = 'No pickup days found';
          });
        }
      } else {
        print("Community document not found for $communityName");
        setState(() {
          _nextPickupDate = 'No community found';
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


  // void _showInfoDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Information'),
  //         content: const Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: const CleanerAppBar(title: 'CLEANER+'),
        endDrawer: Navbar(),
        body: content(),
      ),
    );
  }

  Widget content() {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.89,
        heightFactor: 0.95,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "Next Collection Date:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 29.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 15),
                    //   child: Text(
                    //     _nextPickupDate,
                    //     style: const TextStyle(
                    //       color: Color.fromRGBO(24, 151, 158, 100),
                    //       fontSize: 30,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    //
                    // IconButton(
                    //   icon: const Icon(Icons.info_outline, color: Colors.white),
                    //   onPressed: _showInfoDialog,
                    // ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Text(
                            _nextPickupDate,
                            style: const TextStyle(
                              color: Color.fromRGBO(24, 151, 158, 100),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // const SizedBox(width: 0.5), // Add some space between the text and the icon
                          IconButton(
                            icon: const Icon(Icons.info_outline, color: Colors.white),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("What's this?"),
                                    // content: const Text('Your pickup date is the next date that the garbage in your area is scheduled to be collected. '),
                                    //toadd - community name and days listed in db. "for <your community>, collection is scheduled for <days>.
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
                                            text: ', collection is scheduled for:\n',
                                          ),
                                          TextSpan(
                                            text: pickupDays.join(', '),
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const TextSpan(
                                            text: '.',
                                          ),
                                        ],
                                      ),
                                    ),
                                    // content: Text(
                                    //     'Your pickup date is the next date that the garbage in your area is scheduled to be collected.'
                                    //         'For $_communityName, collection is scheduled for the following days: ${pickupDays.join(', ')}.'
                                    // ),
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
                                  MaterialStateProperty.all<Color>(
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
                padding: const EdgeInsets.only(left: 15), // Optional padding for spacing from the left
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
                      child: Text(
                        "Request a Pick-up",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,

                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Spacing between tappable texts
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
                      child: Text(
                        "File a Report",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,

                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 10), // Spacing between tappable texts
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
                      child: Text(
                        "Update Your Account Information",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,

                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10), // Spacing between tappable texts
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
                      child: Text(
                        "View Current Notices & Alerts",
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