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
  bool _isLoading = false;
  List<File> _images = [];

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final String documentID;

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();

    setState(() {
      _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    });
    }

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> navigateToHome() async {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const HomeScreen()
        )
    );
  }


  Future<void> _uploadImagesAndSaveData() async {
    if (_images.isEmpty) return;
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentReference? reports;
      List<String> downloadUrls = [];

      // Upload images to Firebase Storage
      for (File image in _images) {
        String fileName = 'reports/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        TaskSnapshot snapshot = await _storage.ref().child(fileName).putFile(image);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      // Save report data to Firestore
      reports = await _firestore.collection('reports').add({
        'reportType': _selectedReportType,
        'additionalInfo': additionalInfoController.text,
        'imageUrls': downloadUrls,
        'receiveUpdates': isChecked,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await reports.update({'reportID': reports.id});

      String reportID = reports.id;

      Navigator.of(context).push(
        MaterialPageRoute(
          // builder: (context) => const ReportAddress(),
          // Send document id to next screen
          builder: (context) => ReportAddress(reportID: reportID),
        ),
      );
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                  _pickImages();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _captureImage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to show the alert dialog
  void _showReportTypeInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Types Explained'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("1. Blocked Drains and Waterways"),
                Text(
                  "   - Report instances of clogged or blocked drains and waterways that may cause flooding or environmental issues.",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text("2. Missed Pickup"),
                Text(
                  "   - Inform us if your scheduled garbage pickup was missed.",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text("3. Illegal Dumping"),
                Text(
                  "   - Report cases of unauthorized garbage disposal in undesignated areas.",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text("4. Non-compliance by Companies"),
                Text(
                  "   - Highlight cases where companies are not adhering to waste management regulations.",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text("5. Request Pickup for Another Person"),
                Text(
                  "   - Submit a request to schedule a garbage pickup for someone unable to do so themselves.",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text("6. Other"),
                Text(
                  "   - For issues that do not fit into the above categories, provide details under 'Other'.",
                  style: TextStyle(color: Colors.grey),
                ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Report Type",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline, color: Colors.blue),
                        onPressed: () => _showReportTypeInfo(context),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.8),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      value: _selectedReportType,
                      hint: const Text(
                        "Select Report Type",
                        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: "Blocked Drains and Waterways",
                          child: Text("Blocked Drains and Waterways"),
                        ),
                        DropdownMenuItem(
                          value: "Missed Pickup",
                          child: Text("Missed Pickup"),
                        ),
                        DropdownMenuItem(
                          value: "Illegal Dumping",
                          child: Text("Illegal Dumping"),
                        ),
                        DropdownMenuItem(
                          value: "Non-compliance by Companies",
                          child: Text("Non-compliance by Companies"),
                        ),
                        DropdownMenuItem(
                          value: "Request Pickup for Another Person",
                          child: Text("Request Pickup for Another Person"),
                        ),
                        DropdownMenuItem(
                          value: "Other",
                          child: Text("Other"),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedReportType = newValue!;
                        });
                      },
                    ),
                  ),

                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "File a Report",
                  //       style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 35,
                  //         fontWeight: FontWeight.w400,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 30.0),
                  // const Row(
                  //   children: [
                  //     Text("Report Type", style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 25,
                  //     ),),
                  //   ],
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.only(left: 16),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.black, width: 0.8),
                  //     borderRadius: BorderRadius.circular(25),
                  //     color: Colors.white,
                  //   ),
                  //   child: DropdownButton<String>(
                  //     value: _selectedReportType,
                  //     hint: const Text("Select Report Type", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic), ),
                  //     isExpanded: true,
                  //     items: const [
                  //       DropdownMenuItem(
                  //         value: "Blocked Drains and Waterways",
                  //         child: Text("Blocked Drains and Waterways"),
                  //       ),
                  //       DropdownMenuItem(
                  //         value: "Missed Pickup",
                  //         child: Text("Missed Pickup"),
                  //       ),
                  //       DropdownMenuItem(
                  //         value: "Illegal Dumping",
                  //         child: Text("Illegal Dumping"),
                  //       ),
                  //       DropdownMenuItem(
                  //         value: "Non-compliance by Companies",
                  //         child: Text("Non-compliance by Companies"),
                  //       ),
                  //       DropdownMenuItem(
                  //         value: "Request Pickup for Another Person",
                  //         child: Text("Request Pickup for Another Person"),
                  //       ),
                  //       DropdownMenuItem(
                  //         value: "Other",
                  //         child: Text("Other"),
                  //       ),
                  //     ],
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         _selectedReportType = newValue!;
                  //       });
                  //     },
                  //   ),
                  // ),
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
                              hintText: 'Describe the issue (in as much detail as possible)\n\n\n\n',
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
                  _images.isEmpty
                      ? ElevatedButton(
                    onPressed: () => _showPicker(context),
                    child: const Text('Upload Images'),
                  )
                      : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _images.map((image) {
                      return GestureDetector(
                        onTap: () => _showPicker(context),
                        child: Image.file(
                          image,
                          height: 100,
                          width: 100,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _uploadImagesAndSaveData,
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
