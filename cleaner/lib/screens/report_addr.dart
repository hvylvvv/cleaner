import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:cleaner/screens/home_screen.dart';
// import 'package:cleaner/screens/report.dart';


class ReportAddress extends StatefulWidget {
  final String reportID;

  const ReportAddress({super.key, required this.reportID});
  // const ReportAddress({super.key});



  @override
  State<ReportAddress> createState() => _ReportAddressState();
}

class _ReportAddressState extends State<ReportAddress> {

  Future<void> navigateToHome()async {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const HomeScreen()
        )

    );
  }


  void _showAddressDialog(BuildContext context, LatLong latLong, addressData) {
    final TextEditingController addressLatLongController = TextEditingController(text: '${latLong.latitude.toString()}, ${latLong.longitude.toString()}');
    final TextEditingController addressLine1Controller = TextEditingController(text: addressData['road']);
    final TextEditingController addressSuburbController = TextEditingController(text: addressData['suburb']);
    final TextEditingController addressParishController = TextEditingController(text: addressData['county']);
    // final TextEditingController addressCountryController = TextEditingController(text: addressData['country']);




    void updateReportAddress() async {
      String resp = FirebaseFirestore.instance.collection('reports').doc(widget.reportID)
          .update({'addressLatLong': addressLatLongController.text })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error")) as String;
      print(resp);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm/Edit Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextFormField(
                controller: addressLine1Controller,
                decoration: const InputDecoration(labelText: 'Street Address'),
              ),
              TextFormField(
                controller: addressSuburbController,
                decoration: const InputDecoration(labelText: 'Town'),
              ),
              TextFormField(
                controller: addressParishController,
                decoration: const InputDecoration(labelText: 'Parish'),
              ),

              // TextFormField(
              //   controller: addressCountryController,
              //   decoration: const InputDecoration(labelText: 'Country'),
              // ),
              TextFormField(
                controller: addressLatLongController,
                decoration: const InputDecoration(labelText: 'GeoLocation'),
              ),
              // Text(LatLong as String)
              // Add more text fields here if you need to edit more parts of the address
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),


            ElevatedButton(
              onPressed: () async {
                updateReportAddress();
                navigateToHome();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted successfully')));
                // Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterLocationPicker(
            initPosition: const LatLong(23, 89),
            selectLocationButtonStyle: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
            ),
            selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
            selectLocationButtonText: 'Set Current Location',
            selectLocationButtonLeadingIcon: const Icon(Icons.check),
            initZoom: 15,
            minZoomLevel: 5,
            maxZoomLevel: 20,
            trackMyPosition: true,
            onError: (e) => print(e),
            onPicked: (pickedData) {
              // print(pickedData.LatLong);
              // print(pickedData.address);
              // print(pickedData.addressData['country']);
              // print(pickedData.addressData);
              _showAddressDialog(context, pickedData.latLong, pickedData.addressData);
              // print(FirebaseAuth.instance.currentUser);
            },
            onChanged: (pickedData) {
              // print(pickedData.latLong.latitude);
              // print(pickedData.latLong.longitude);
              // print(pickedData.address);
              // print(pickedData.addressData);
            })
    );
  }
}