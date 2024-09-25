import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:cleaner/Resources/auth_methods.dart';
import 'package:cleaner/screens/home_screen.dart';


class SetupAddress extends StatefulWidget {
  // final String userId;

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
    final TextEditingController addressLine1Controller = TextEditingController(text: '${addressData['house_number'] ?? ''} ${addressData['road'] ?? ''}');
    final TextEditingController addressNeighbourhoodController = TextEditingController(text: '${addressData['neighbourhood'] ?? ''}' );
    final TextEditingController addressSuburbController = TextEditingController(text: addressData['suburb'] ?? '');
    final TextEditingController addressParishController = TextEditingController(text: addressData['county']);
    final TextEditingController addressCountryController = TextEditingController(text: addressData['country']);

    void updateUserAddress() async {
      String resp = await AuthMethods().updateUserAddress(
          addressLatLong: addressLatLongController.text,
          addressLine1: addressLine1Controller.text,
          addressNeighbourhood: addressNeighbourhoodController.text,
          addressSuburb: addressSuburbController.text,
          addressParish: addressParishController.text,
          addressCountry: addressCountryController.text
      );
      print(resp);
    }

    // void updateUserAddress() async {
    //   if (_addressController.text.isNotEmpty) {
    //     await FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(widget.userId)
    //         .update({
    //       'address': _addressController.text,
    //     });
    //
    //     // Navigate to the next screen or show success
    //     Navigator.of(context).pop();
    //   } else {
    //     // Show error if the address field is empty
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Address cannot be empty')),
    //     );
    //   }
    // }

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
                controller: addressNeighbourhoodController,
                decoration: const InputDecoration(labelText: 'Neighbourhood'),
              ),
              TextFormField(
                controller: addressSuburbController,
                decoration: const InputDecoration(labelText: 'Town'),
              ),
              TextFormField(
                controller: addressParishController,
                decoration: const InputDecoration(labelText: 'Parish'),
              ),

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

    return WillPopScope(
    onWillPop: () async {
      // Return false to disable the back button
      return false;
    },
        child:  Scaffold(
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
              _showAddressDialog(context, pickedData.latLong, pickedData.addressData);
              print(pickedData.addressData);
            //   I/flutter ( 4560): {house_number: 25, road: Camelia Way, neighbourhood: Mona Heights, suburb: Mona, county: Saint Andrew, ISO3166-2-lvl6: JM-02, state_district: Surrey County, country: Jamaica, country_code: jm}
            },
            onChanged: (pickedData) {
            })
    ));
  }
}