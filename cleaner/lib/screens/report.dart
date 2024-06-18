
import 'package:cleaner/screens/report_addr.dart';
import 'package:cleaner/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:cleaner/screens/home_screen.dart';
import 'package:cleaner/widgets/navbar.dart';



class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}


class _ReportState extends State<Report> {

  String? _selectedReportType;
  TextEditingController additionalInfoController = TextEditingController();
  bool isChecked = false;
  File? _image;

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final String documentID ;


  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> navigateToHome()async {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const HomeScreen()
        )
    );
  }









  Future<void> _uploadImageAndSaveData() async {
    if (_image == null) return;
    try {
      DocumentReference? reports;
      // Upload image to Firebase Storage
      String fileName = 'reports/${DateTime.now().millisecondsSinceEpoch}.jpg';
      TaskSnapshot snapshot = await _storage.ref().child(fileName).putFile(_image!);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save report data to Firestore
      reports = await _firestore.collection('reports').add({
        'reportType': _selectedReportType,
        'additionalInfo': additionalInfoController.text,
        'imageUrl': downloadUrl,
        'receiveUpdates': isChecked,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await reports.update({'reportID' : reports.id});

      String reportID = reports.id;


      Navigator.of(context).push(
        MaterialPageRoute(
          // builder: (context) => const ReportAddress(),
          // Send document id to next screen
          builder: (context) => ReportAddress(reportID: reportID),
        ),
      );


      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted successfully')));
      // navigateToHome();
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to submit report')));
    }
  }







  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 43, 45, 100),
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
                        "File a Report",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  const Row(
                    children: [
                      Text("Report Type", style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      value: _selectedReportType,
                      hint: const Text("Select Report Type", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic), ),
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: "Report Type 1",
                          child: Text("Report Type 1"),
                        ),
                        DropdownMenuItem(
                          value: "Report Type 2",
                          child: Text("Report Type 2"),
                        ),
                        DropdownMenuItem(
                          value: "Report Type 3",
                          child: Text("Report Type 3"),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedReportType = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 60),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              hintText: 'Describe the issue (in as much detail as possible)',
                              hintStyle: TextStyle(color: Colors.grey,  fontStyle: FontStyle.italic ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),
                  _image == null
                      ? ElevatedButton(
                    onPressed: () => _showPicker(context),
                    child: const Text('Upload Image'),
                  )
                      : GestureDetector(
                    onTap: () => _showPicker(context),
                    child: Image.file(
                      _image!,
                      height: 200,
                      width: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadImageAndSaveData,
                    child: const Text('Select Incident Location'),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

