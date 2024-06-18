import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cleaner/screens/home_screen.dart';
import '../models/requestdata.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';


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
      appBar: const CleanerAppBar(title: 'CLEANER+'),
      endDrawer: Navbar(),

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
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    children: [
                      const Text("Pickup Type", style: TextStyle(
                          color: Colors.black,
                        fontSize: 25,
                      ),),
                      SizedBox(width: 10), // Adjust the width as needed
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Pickup Type Information"),
                                content: const Text("Regular Household Waste includes everyday trash generated from kitchens, bathrooms, and general living areas.\n\n"
                                    "Recycling Pickup is for recyclable materials such as paper, cardboard, plastics, glass, and metals.\n\n"
                                    "Yard Waste Collection is for pickup of grass clippings, leaves, branches, and other organic yard waste."
                                    "Bulk Item Pickupis for disposal of large items that cannot fit into regular trash bins, such as furniture, appliances, mattresses, or electronic waste.\n\n"
                                    "Hazardous Waste Disposal is for disposal of hazardous materials like batteries, chemicals, paints, and solvents.\n\n"
                                    "Construction Debris Pickup is for removal of materials resulting from renovation or construction projects, including wood, drywall, concrete, and other building materials.\n\n"
                                    "Special Event Clean-Up is for temporary pickups to manage increased waste generated during events, festivals, or community gatherings."),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Tooltip(
                          message: 'Select the type of pickup',
                          child: Icon(Icons.info_outline, size: 18, color: Colors.grey),
                        ),
                      ),

                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8, top:4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white10,
                    ),

                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: _selectedPickupType,
                      hint: const Text("Select Pickup Type", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey )),
                      isExpanded: true,
                      underline: const SizedBox.shrink(), // This removes the underline
                      items: const [
                        DropdownMenuItem(
                          value: "Regular Household Waste",
                          child: Text("Regular Household Waste"),
                        ),
                        DropdownMenuItem(
                          value: "Recycling Pickup",
                          child: Text("Recycling Pickup"),
                        ),
                        DropdownMenuItem(
                          value: "Yard Waste Collection",
                          child: Text("Yard Waste Collection"),
                        ),
                        DropdownMenuItem(
                          value: "Bulk Item Pickup",
                          child: Text("Bulk Item Pickup"),
                        ),
                        DropdownMenuItem(
                          value: "Hazardous Waste Disposal",
                          child: Text("Hazardous Waste Disposal"),
                        ),
                        DropdownMenuItem(
                          value: "Construction Debris Pickup",
                          child: Text("Construction Debris Pickup"),
                        ),
                        DropdownMenuItem(
                          value: "Special Event Clean-Up",
                          child: Text("Special Event Clean-Up"),
                        ),
                        DropdownMenuItem(
                          value: "Other",
                          child: Text("Other"),
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
                        style: TextStyle(color: Colors.black,
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
                            fillColor: Colors.white10,
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
                            fillColor: Colors.white10
                            ,
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
                              fillColor: Colors.white10,
                              filled: true,
                              hintText: 'Anything to Add?',
                              hintStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              )
                          ),
                        ),
                      ),
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
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
                            color: Colors.black,
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
