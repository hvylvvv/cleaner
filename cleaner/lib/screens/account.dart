import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/navbar.dart';
import 'package:cleaner/models/userdata.dart'; // Adjust the path as needed

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

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          // const SizedBox(height: 3,),
          const Text("Is this correct?",
            style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),),

          const SizedBox(height: 10,),




          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 5),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Phone'),
          ),
          SizedBox(height: 5),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 5),
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
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}











// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../widgets/appbar.dart';
// import '../widgets/navbar.dart';
// import 'package:cleaner/models/userdata.dart'; // Adjust the path as needed
//
// class Account extends StatefulWidget {
//   const Account({super.key});
//
//   @override
//   State<Account> createState() => _AccountState();
// }
//
// class _AccountState extends State<Account> {
//   final currentUser = FirebaseAuth.instance.currentUser!;
//   UserData? userData;
//   bool isLoading = true;
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }
//
//   Future<void> fetchUserData() async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUser.uid)
//           .get();
//
//       if (userDoc.exists) {
//         setState(() {
//           userData = UserData.fromSnap(userDoc);
//           _nameController.text = userData?.name ?? '';
//           _phoneController.text = userData?.phone ?? '';
//           _emailController.text = userData?.email ?? '';
//           isLoading = false;
//         });
//       } else {
//         print("User document does not exist.");
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//
//
//
//   Future<void> reauthenticateAndUpdateEmail() async {
//     try {
//       // Get the current user's credential
//       AuthCredential credential = EmailAuthProvider.credential(
//         email: currentUser.email!,
//         password: 'pearpear', // Collect the user's password securely
//       );
//
//       // Re-authenticate the user
//       await currentUser.reauthenticateWithCredential(credential);
//
//       // Update email in Firebase Authentication
//       await currentUser.updateEmail(_emailController.text);
//
//       // Send verification email to the new email address
//       await currentUser.sendEmailVerification();
//
//       // Update Firestore with the new email and other user data
//       await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
//         'Name': _nameController.text,
//         'Phone': _phoneController.text,
//         'Email': _emailController.text,
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User data and email updated successfully. Please verify your new email address.')),
//       );
//     } catch (e) {
//       print('Error re-authenticating and updating email: $e');
//       String errorMessage = 'Error updating email. Please try again later.';
//       if (e is FirebaseAuthException) {
//         if (e.code == 'requires-recent-login') {
//           errorMessage = 'Please re-login and try again.';
//         } else if (e.code == 'email-already-in-use') {
//           errorMessage = 'The email address is already in use by another account.';
//         } else if (e.code == 'invalid-email') {
//           errorMessage = 'The email address is invalid.';
//         } else if (e.code == 'operation-not-allowed') {
//           errorMessage = 'Email update is not enabled. Check Firebase console.';
//         }
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(errorMessage)),
//       );
//     }
//   }
//
//
//
//   // Future<void> reauthenticateAndUpdateEmail() async {
//   //   try {
//   //     // Get the current user's credential
//   //     AuthCredential credential = EmailAuthProvider.credential(
//   //       email: currentUser.email!,
//   //       password: 'pearpear', // Collect the user's password securely
//   //     );
//   //
//   //     // Re-authenticate the user
//   //     await currentUser.reauthenticateWithCredential(credential);
//   //
//   //     // Verify and update the email
//   //     await currentUser.verifyBeforeUpdateEmail(_emailController.text);
//   //
//   //     // Update Firestore with the new email
//   //     await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
//   //       'Name': _nameController.text,
//   //       'Phone': _phoneController.text,
//   //       'Email': _emailController.text,
//   //     });
//   //
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('User data updated successfully')),
//   //     );
//   //   } catch (e) {
//   //     print('Error re-authenticating and updating email: $e');
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Error re-authenticating and updating email')),
//   //     );
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CleanerAppBar(title: 'CLEANER+'),
//       endDrawer: Navbar(),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : content(),
//     );
//   }
//
//   Widget content() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextField(
//             controller: _nameController,
//             decoration: InputDecoration(labelText: 'Name'),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: _phoneController,
//             decoration: InputDecoration(labelText: 'Phone'),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(labelText: 'Email'),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: reauthenticateAndUpdateEmail,
//             child: Text('Save Changes'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
// }
//
//
//
//
//
//
//
//








// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../widgets/appbar.dart';
// import '../widgets/navbar.dart';
// import 'package:cleaner/models/userdata.dart'; // Adjust the path as needed
//
// class Account extends StatefulWidget {
//   const Account({super.key});
//
//   @override
//   State<Account> createState() => _AccountState();
// }
//
// class _AccountState extends State<Account> {
//   final currentUser = FirebaseAuth.instance.currentUser!;
//   UserData? userData;
//   bool isLoading = true;
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }
//
//   Future<void> fetchUserData() async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUser.uid)
//           .get();
//
//       if (userDoc.exists) {
//         setState(() {
//           userData = UserData.fromSnap(userDoc);
//           _nameController.text = userData?.name ?? '';
//           _phoneController.text = userData?.phone ?? '';
//           _emailController.text = userData?.email ?? '';
//           isLoading = false;
//         });
//         print("User Data: ${userData.toString()}");
//       } else {
//         print("User document does not exist.");
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   // Future<void> updateUserData() async {
//   //   try {
//   //     await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
//   //       'Name': _nameController.text,
//   //       'Phone': _phoneController.text,
//   //       'Email': _emailController.text,
//   //     });
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('User data updated successfully')),
//   //     );
//   //   } catch (e) {
//   //     print('Error updating user data: $e');
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Error updating user data')),
//   //     );
//   //   }
//   // }
//
//   Future<void> updateUserData() async {
//     try {
//       // Update email in Firebase Authentication
//       await currentUser.updateEmail(_emailController.text);
//
//       // Update user data in Firestore
//       await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
//         'Name': _nameController.text,
//         'Phone': _phoneController.text,
//         'Email': _emailController.text,
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('User data updated successfully')),
//       );
//     } catch (e) {
//       print('Error updating user data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating user data')),
//       );
//     }
//   }
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CleanerAppBar(title: 'CLEANER+'),
//       endDrawer: Navbar(),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : content(),
//     );
//   }
//
//   Widget content() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextField(
//             controller: _nameController,
//             decoration: InputDecoration(labelText: 'Name'),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: _phoneController,
//             decoration: InputDecoration(labelText: 'Phone'),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(labelText: 'Email'),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: updateUserData,
//             child: Text('Save Changes'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
// }



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../widgets/appbar.dart';
// import '../widgets/navbar.dart';
// import 'package:cleaner/models/userdata.dart'; // Adjust the path as needed
//
// class Account extends StatefulWidget {
//   const Account({super.key});
//
//   @override
//   State<Account> createState() => _AccountState();
// }
//
// class _AccountState extends State<Account> {
//   final currentUser = FirebaseAuth.instance.currentUser!;
//   UserData? userData;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }
//
//   Future<void> fetchUserData() async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUser.uid)
//           .get();
//
//       if (userDoc.exists) {
//         setState(() {
//           userData = UserData.fromSnap(userDoc);
//           isLoading = false;
//         });
//         print("User Data: ${userData.toString()}");
//       } else {
//         print("User document does not exist.");
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CleanerAppBar(title: 'CLEANER+'),
//       endDrawer: Navbar(),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : content(),
//     );
//   }
//
//   Widget content() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Name: ${userData?.name ?? 'N/A'}',
//             style: TextStyle(fontSize: 20),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Phone: ${userData?.phone ?? 'N/A'}',
//             style: TextStyle(fontSize: 20),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Email: ${userData?.email ?? 'N/A'}',
//             style: TextStyle(fontSize: 20),
//           ),
//
//
//
//         ],
//       ),
//     );
//   }
// }


