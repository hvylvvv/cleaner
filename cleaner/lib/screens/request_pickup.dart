
import 'package:cleaner/screens/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cleaner/screens/home_screen.dart';
import '../models/requestdata.dart';
import 'login_screen.dart';
import 'package:cleaner/screens/map.dart';

class RequestPickup extends StatefulWidget {
  const RequestPickup({super.key});

  @override
  State<RequestPickup> createState() => _RequestPickupState();
}

class _RequestPickupState extends State<RequestPickup> {
  String? _selectedPickupType;
  bool isChecked = false;
  TextEditingController timePicker = TextEditingController();
  TextEditingController datePicker = TextEditingController();
  TextEditingController additionalInfoController = TextEditingController();

  Future<void> navigateToHome()async {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const HomeScreen()
        )
    );
  }


  // Function to submit the form
  void _submitForm() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated')),
      );
      return;
    }

    if (_selectedPickupType == null || datePicker.text.isEmpty || timePicker.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    RequestData requestData = RequestData(
      pickupType: _selectedPickupType!,
      date: datePicker.text,
      time: timePicker.text,
      additionalInfo: additionalInfoController.text,
      receiveUpdates: isChecked,
      uid: user.uid,
      name: user.displayName ?? 'Anonymous',

    );

    try {
      // added
      // final DocumentReference pickUp;
      DocumentReference? pickUp;

      pickUp = await FirebaseFirestore.instance.collection('pickups').add(requestData.toJson());
      await pickUp.update({'pickupId': pickUp.id});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup Request Submitted Successfully!')),

      );
      navigateToHome();
      // Navigator.pushNamedAndRemoveUntil(context, 'HomeScreen', (route) => false);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit pickup request: $error')),
      );
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 43, 45, 100),
      appBar: AppBar(
        toolbarHeight: 70.0,
        title: const Text(
          'CLEANER+',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(30, 43, 45, 200),
      ),

      endDrawer: Drawer(

        child: ListView(
          children: [
            ListTile(
              title: const Text("Home"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Map"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Map(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Community"),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Report"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Report(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Log Out"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),


      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 80.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        "Request Pickup",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  const Row(
                    children: [
                      Text("Pickup Type", style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.w200,
                        fontSize: 25,
                      ),),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8, top:4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,

                    ),

                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: _selectedPickupType,
                      hint: const Text("Select Pickup Type", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey )),
                      isExpanded: true,
                      underline: const SizedBox.shrink(), // This removes the underline
                      items: const [
                        DropdownMenuItem(
                          value: "Pickup Type 1",
                          child: Text("Pickup Type 1"),
                        ),
                        DropdownMenuItem(
                          value: "Pickup Type 2",
                          child: Text("Pickup Type 2"),
                        ),
                        DropdownMenuItem(
                          value: "Pickup Type 3",
                          child: Text("Pickup Type 3"),
                        ),
                        DropdownMenuItem(
                          value: "Pickup Type 4",
                          child: Text("Pickup Type 4"),
                        ),
                        DropdownMenuItem(
                          value: "Pickup Type 5",
                          child: Text("Pickup Type 5"),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPickupType = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Row(
                    children: [
                      Text("Date & Time",
                        style: TextStyle(color: Colors.white,
                          fontSize: 25,))
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: datePicker,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: "Select Date",
                            hintStyle: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                          ),
                          onTap: () async {
                            DateTime? datetime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime(3000),
                            );
                            if (datetime != null) {
                              String formattedDate = DateFormat('yyyy-MM-dd').format(datetime);
                              setState(() {
                                datePicker.text = formattedDate;
                              });
                            }
                          }, //Ontap
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: timePicker,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: "Select Time",
                            hintStyle: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                          ),
                          onTap: () async {
                            var time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                timePicker.text = time.format(context);
                              });
                            }
                          }, //Ontap
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 10),
                      SizedBox(
                        width: 400,
                        height: 150, // Specify a fixed height
                        child: TextFormField(
                          controller: additionalInfoController,
                          minLines: 2,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Anything to Add?',
                              hintStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              )
                          ),
                        ),
                      ),
                      // const SizedBox(height: 5),
                    ],
                  ),
                  // const SizedBox(height: 5),
                   SizedBox(
                    width: 400,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.start, // Align elements to the start of the row
                      children: [
                        Checkbox(
                          value: isChecked,
                          activeColor: const Color.fromARGB(255, 2, 100, 95),
                          tristate: true,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                        ),
                        const Text(
                          'I want to receive updates',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _submitForm();
                    },

                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color.fromARGB(255, 2, 100, 95),
                      ),
                      child: const Center(
                        child: Text(
                          "Request Pickup",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 200), // Adjust as needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
