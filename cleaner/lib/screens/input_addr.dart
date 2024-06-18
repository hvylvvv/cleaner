import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:cleaner/Resources/auth_methods.dart';
import 'package:cleaner/screens/home_screen.dart';


class SetupAddress extends StatefulWidget {
  const SetupAddress({super.key});

  @override
  State<SetupAddress> createState() => _SetupAddressState();
}

class _SetupAddressState extends State<SetupAddress> {

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
    final TextEditingController addressCountryController = TextEditingController(text: addressData['country']);

    void updateUserAddress() async {
      String resp = await AuthMethods().updateUserAddress(
          addressLatLong: addressLatLongController.text,
          addressLine1: addressLine1Controller.text,
          addressSuburb: addressSuburbController.text,
          addressParish: addressParishController.text,
          addressCountry: addressCountryController.text
      );
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
                updateUserAddress();
                navigateToHome();


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