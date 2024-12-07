import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/navbar.dart';
import 'package:cleaner/models/userdata.dart';
import 'package:cleaner/screens/input_addr.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  UserData? userData;
  bool isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController(); // For address display

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userData = UserData.fromSnap(userDoc);
          _nameController.text = userData?.name ?? '';
          _phoneController.text = userData?.phone ?? '';
          _emailController.text = userData?.email ?? '';
          // _addressController.text = userDoc['AddressLine1'] ?? 'Tap to add address';
          _addressController.text = [
            userDoc['AddressLine1'],
            userDoc['AddressNeighbourhood'],
            userDoc['AddressSuburb'],
            // userDoc['AddressParish'],
          ].where((addressPart) => addressPart != null && addressPart.isNotEmpty).join(', ') ?? 'Tap to add address';

          isLoading = false;
        });
      } else {
        print("User document does not exist.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }



  Future<void> fixaddress() async {
    // Navigate to SetupAddress and await the result
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SetupAddress(),
      ),
    );

    // If the result is not null, show a SnackBar
    if (result != null && result is String) {
      // Show SnackBar after returning from SetupAddress
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update successful!')),
      );
      // Optionally fetch the updated address data again
      fetchUserData();
    }
  }


  Future<void> updateUserData() async {
    try {
      // Update email in Firebase Authentication
      await currentUser.updateEmail(_emailController.text);

      // Update user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'Name': _nameController.text,
        'Phone': _phoneController.text,
        'Email': _emailController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data updated successfully')),
      );
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user data')),
      );
    }
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: currentUser.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent. Check your email inbox.')),
      );
    } catch (e) {
      print('Error sending password reset email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send password reset email. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CleanerAppBar(title: 'CLEANER+'),
      endDrawer: Navbar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : content(),
    );
  }

  // Widget content() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               "Account Information",
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 30,
  //                 fontWeight: FontWeight.w300,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 10),
  //
  //         TextField(
  //           controller: _nameController,
  //           decoration: InputDecoration(labelText: 'Name'),
  //         ),
  //         SizedBox(height: 5),
  //         TextField(
  //           controller: _phoneController,
  //           decoration: InputDecoration(labelText: 'Phone'),
  //         ),
  //         SizedBox(height: 5),
  //         TextField(
  //           controller: _emailController,
  //           decoration: InputDecoration(labelText: 'Email'),
  //         ),
  //
  //         // Clickable Address TextField
  //         SizedBox(height: 5),
  //         GestureDetector(
  //           onTap: fixaddress,
  //           child: AbsorbPointer(
  //             child:
  //             // TextField(
  //             //   controller: _addressController,
  //             //   decoration: InputDecoration(labelText: 'Address'),
  //             //   maxLines: 3, // Adjust this as needed
  //             //   minLines: 1,
  //             // ),
  //
  //             TextField(
  //               controller: _addressController,
  //               decoration: InputDecoration(
  //                 labelText: 'Address (Tap to update)',
  //                 suffixIcon: Icon(Icons.edit_location_alt),  // Icon indicating it's clickable
  //               ),
  //               maxLines: 3,
  //               minLines: 1,
  //               readOnly: true, // Ensure the field is not editable
  //             ),
  //           ),
  //         ),
  //
  //         SizedBox(height: 10),
  //         ElevatedButton(
  //           onPressed: updateUserData,
  //           child: Text('Save Changes'),
  //         ),
  //         SizedBox(height: 10),
  //         TextButton(
  //           onPressed: resetPassword,
  //           child: Text('Reset Password'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget content() {
    return SingleChildScrollView(  // Wrap the content in SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Account Information",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email Address'),
            ),

            // Clickable Address TextField
            SizedBox(height: 5),
            GestureDetector(
              onTap: fixaddress,
              child: AbsorbPointer(
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address (Tap to update)',
                    suffixIcon: Icon(Icons.edit_location_alt),
                  ),
                  maxLines: 3,
                  minLines: 1,
                  readOnly: true,
                ),
              ),
            ),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: updateUserData,
              child: Text('Save Changes'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: resetPassword,
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
