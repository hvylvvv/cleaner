import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cleaner/screens/create_community_post.dart';
import 'package:cleaner/screens/home_screen.dart';
import 'package:cleaner/screens/map.dart';
import 'package:cleaner/screens/report.dart';
import 'package:cleaner/screens/login_screen.dart';
import '../screens/account.dart';
import 'package:cleaner/screens/reportmap.dart';
import 'package:cleaner/models/userdata.dart'; // Adjust the path as needed

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  UserData? userData;
  bool isLoading = true;

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
          isLoading = false;
        });
        print("User Data: ${userData.toString()}");
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserAccountsDrawerHeader(
            accountName: isLoading
                ? Text("", style: TextStyle(fontSize: 25))
                : Text(userData?.name ?? 'N/A', style: const TextStyle(fontSize: 25)),
            // accountEmail: Text(currentUser.email!, style: const TextStyle(fontSize: 15)),
            accountEmail: isLoading
                ? Text("", style: TextStyle(fontSize: 25))
                : Text(userData?.email ?? 'N/A', style: const TextStyle(fontSize: 15)),
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.grey),
                  title: const Text(
                    "Home",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.pin_drop, color: Colors.grey),
                  title: const Text(
                    "Map",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ReportMap(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.chat, color: Colors.grey),
                  title: const Text(
                    "Community",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Community(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.report, color: Colors.grey),
                  title: const Text(
                    "Report",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  onTap: ()
                  {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                        // builder: (context) => const Report(),
                    //   ),
                    // );
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.grey),
                  title: const Text(
                    "Settings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Account(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.blueGrey),
                  title: const Text(
                    "Log Out",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
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
        ],
      ),
    );
  }
}



// import 'package:cleaner/screens/create_community_post.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cleaner/screens/home_screen.dart';
// import 'package:cleaner/screens/map.dart';
// import 'package:cleaner/screens/report.dart';
// import 'package:cleaner/screens/login_screen.dart';
//
// import '../screens/account.dart';
//
// class Navbar extends StatelessWidget {
//   Navbar({super.key});
//   final currentUser = FirebaseAuth.instance.currentUser!;
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.center,
//
//
//         children: [
//
//
//           UserAccountsDrawerHeader(
//             // accountName: Text("John Doe", style: TextStyle(fontSize: 25),), // Replace with actual user name
//             accountName: Text(currentUser.displayName!, style: const TextStyle(fontSize: 25), ),
//             accountEmail: Text(currentUser.email!, style: const TextStyle(fontSize: 15),), // Replace with actual user email
//             decoration: const BoxDecoration(
//               color: Colors.grey, // Customize the background color
//             ),
//           ),
//
//
//
//
//
//           // const SizedBox(height: 5,),
//           Expanded(
//             child: ListView(
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.home, color: Colors.grey),
//                   title: const Text(
//                     "Home",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
//                     // textAlign: TextAlign.center,
//                   ),
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const HomeScreen(),
//                       ),
//                     );
//                   },
//                 ),
//
//                 const SizedBox(height: 10,),
//                 ListTile(
//                   leading: const Icon(Icons.pin_drop, color: Colors.grey),
//                   title: const Text(
//                     "Map",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
//                     // textAlign: TextAlign.center,
//                   ),
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const Map(),
//                       ),
//                     );
//                   },
//                 ),
//
//
//                 const SizedBox(height: 10,),
//                 ListTile(
//                   leading: const Icon(Icons.chat, color: Colors.grey),
//                   title: const Text(
//                     "Community",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
//                     // textAlign: TextAlign.center,
//                   ),
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const Community(),
//                       ),
//                     );
//                   },
//                 ),
//
//
//                 const SizedBox(height: 10,),
//                 ListTile(
//                   leading: const Icon(Icons.report, color: Colors.grey),
//                   title: const Text(
//                     "Report",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
//                     // textAlign: TextAlign.center,
//                   ),
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const Report(),
//                       ),
//                     );
//                   },
//                 ),
//
//
//                 const SizedBox(height: 10,),
//                 // Divider(),
//                 Container(
//                   height: 1, // Adjust thickness of the separator
//                   color: Colors.grey[300], // Customize color of the separator
//                   margin: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust margin as needed
//                 ),
//
//                 // const SizedBox(height: 5,),
//                 ListTile(
//                   leading: const Icon(Icons.settings, color: Colors.grey),
//                   title: const Text(
//                     "Settings",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
//                   ),
//                   onTap: () {
//
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const Account(), // Replace with your settings screen widget
//                       ),
//                     );
//                   },
//                 ),
//
//
//                 const SizedBox(height: 10,),
//                 ListTile(
//                   leading: const Icon(Icons.logout, color: Colors.blueGrey),
//                   title: const Text(
//                     "Log Out",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
//                     // textAlign: TextAlign.center,
//                   ),
//                   onTap: () async {
//                     await FirebaseAuth.instance.signOut();
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const LoginScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
