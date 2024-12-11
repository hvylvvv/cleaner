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
import 'package:cleaner/models/userdata.dart';


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
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;

    // Split the string into words
    List<String> words = text.split(' ');

    // Capitalize each word and join them back
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1).toLowerCase();
    }

    // Join the words back with spaces
    return words.join(' ');
  }



  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserAccountsDrawerHeader(
            accountName: isLoading
                ? const Text("", style: TextStyle(fontSize: 25))
                : Text(toTitleCase(userData?.name ?? ''), style: TextStyle(fontSize: screenWidth * 0.08)),
            // accountEmail: Text(currentUser.email!, style: const TextStyle(fontSize: 15)),
            accountEmail: isLoading
                ? const Text("", style: TextStyle(fontSize: 25))
                : Text(toTitleCase(userData?.email ?? ''), style: TextStyle(fontSize: screenWidth * 0.04)),
            decoration: const BoxDecoration(
              color: Color(0xFF599954)
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.home, color: Color(0xFF599954)),
                  title: Text(
                    "Home",
                    style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.w300),
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
                  leading: const Icon(Icons.pin_drop, color: Color(0xFF599954)),
                  title: Text(
                    "Map",
                    style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.w300),
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
                  leading: const Icon(Icons.chat, color: Color(0xFF599954)),
                  title: Text(
                    "Community",
                    style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.w300),
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
                  leading: const Icon(Icons.report, color: Color(0xFF599954)),
                  title: Text(
                    "Report",
                    style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.w300),
                  ),
                  onTap: ()
                  {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Report(),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenWidth * 0.07),
                Container(
                  height: screenWidth * 0.005,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                ),

                ListTile(
                  leading: const Icon(Icons.settings, color: Color(0xFF599954)),
                  title: Text(
                    "Settings",
                    style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.w300),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Account(),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenWidth * 0.02),
                ListTile(
                  leading: const Icon(Icons.logout, color: Color(0xFF599954)),
                  title: Text(
                    "Log Out",
                    style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.w300),
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


