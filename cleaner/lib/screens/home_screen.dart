import 'package:flutter/material.dart';
import 'package:cleaner/screens/request_pickup.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cleaner/widgets/appbar.dart';
import 'package:cleaner/widgets/navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCalendarVisible = false;

  void navigateToPickupForm() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RequestPickup(),
      ),
    );
  }

  void toggleCalendarVisibility() {
    setState(() {
      _isCalendarVisible = !_isCalendarVisible;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(30, 43, 45, 100),
      appBar: const CleanerAppBar(title: 'CLEANER+'),
      endDrawer: Navbar(),
      body: content(),
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
              Container(
                padding: const EdgeInsets.only(bottom:20),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                ),
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "Next Collection Date",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Sat 8/6',
                        style: TextStyle(
                          color: Color.fromRGBO(24,151,158, 100),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                        padding: const EdgeInsets.only(left: 15),
                    child: ElevatedButton(
                      onPressed: toggleCalendarVisibility,
                      child: Text(_isCalendarVisible ? 'Hide Schedule' : 'See Schedule', style: const TextStyle(color: Colors.black),),
                    ),
                    ),

                    if (_isCalendarVisible) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5), // Adjust padding as needed
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25), // Adjust the radius as needed
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
                                  isTodayHighlighted: true,
                                  selectedDecoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle
                                  )

                                ),
                              ),
                              const SizedBox(height: 10,),
                              ElevatedButton(
                                onPressed: navigateToPickupForm,
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all<Color>(
                                    const Color.fromRGBO(24, 151, 158, 1), // Change button color
                                  ),// Change button color// Change text color
                                ),
                                child: const Text('Request Pickup', style: TextStyle(color: Colors.white),),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 50,),
              Container(
                // padding: const EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(25),
                ),

                padding: const EdgeInsets.only(left: 16),
                child: const SizedBox(
                  height: 100, // Example height
                  width: 400,
                  child: Text("Pickup History",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25),),// Example width
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
