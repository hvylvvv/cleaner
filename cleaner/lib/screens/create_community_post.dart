import 'package:cleaner/screens/reportmap.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/appbar.dart';
import '../widgets/navbar.dart';

class CommunityPost {
  bool resolved;
  String info;
  GeoPoint location;
  String title;

  CommunityPost({
    required this.resolved,
    required this.info,
    required this.location,
    required this.title,
  });

  factory CommunityPost.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return CommunityPost(
      resolved: data['Resolved'] ?? false,
      info: data['info'] ?? '',
      location: data['location'] ?? GeoPoint(0.0, 0.0),
      title: data['title'] ?? '',
    );
  }
}

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  Future<List<CommunityPost>> getCommunityPosts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('community posts')
        .get();

    List<CommunityPost> posts = snapshot.docs.map((doc) {
      return CommunityPost.fromFirestore(doc);
    }).toList();

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(30, 43, 45, 100),
      appBar: CleanerAppBar(title: 'CLEANER+'),
      endDrawer: Navbar(),
      body: FutureBuilder(
        future: getCommunityPosts(),
        builder: (context, AsyncSnapshot<List<CommunityPost>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching data'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No Posts Yet!',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  CommunityPost post = snapshot.data![index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle:
                    // Text(post.info),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.info),
                        Text(
                          'Location: ${post.location.latitude}, ${post.location.longitude}',
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      ],
                    ),

                    // Example of displaying resolved status
                    trailing: post.resolved
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.error, color: Colors.red),
                    onTap: () {
                      // Handle tapping on a post if needed
                    },
                  );
                },
              );
            }
          }
        },
      ),
    // floatingActionButton: FloatingActionButton(
    // // backgroundColor: Colors.red,
    //   onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportMap()),);},
    //   child: Text('View Map'),
    // ));
      floatingActionButton: SizedBox(
        width: 120, // Adjust the width as needed
        child: FloatingActionButton(
            onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportMap()),
            );
            },
          backgroundColor: Colors.grey,
          child: const Text('View Map'),
        ),
      )
    );
  }
}







// import 'package:flutter/material.dart';
// import '../widgets/appbar.dart';
// import '../widgets/navbar.dart';
//
//
// class Community extends StatefulWidget {
//   const Community({super.key});
//
//   @override
//   State<Community> createState() => _CommunityState();
// }
//
// class _CommunityState extends State<Community> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(30, 43, 45, 100),
//       appBar: CleanerAppBar(title: 'CLEANER+'),
//       endDrawer: Navbar(),
//       body: Center(
//         child: Text(
//           'No Posts Yet!',
//           style: TextStyle(fontSize: 20.0, color: Colors.white),
//         ),
//
//           // Container(
//           //   padding: EdgeInsets.all(8.0),
//           //   decoration: BoxDecoration(
//           //     color: Colors.white,
//           //     borderRadius: BorderRadius.circular(10.0),
//           //     boxShadow: [
//           //       BoxShadow(
//           //         color: Colors.black26,
//           //         blurRadius: 10.0,
//           //         offset: Offset(0, 1),
//           //       ),
//           //     ],
//           //   ),
//           //   child: const Column(
//           //     crossAxisAlignment: CrossAxisAlignment.stretch,
//           //     mainAxisSize: MainAxisSize.min,
//           //     children: [
//           //       Text(
//           //         'Announcement',
//           //         style: TextStyle(
//           //           fontSize: 20.0, // Reduced font size
//           //           fontWeight: FontWeight.bold,
//           //           color: Colors.black,
//           //         ),
//           //       ),
//           //       SizedBox(height: 4.0), // Reduced height
//           //       Text(
//           //         'No Posts Yet!',
//           //         style: TextStyle(
//           //           fontSize: 16.0, // Reduced font size
//           //           color: Colors.black87,
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // )
//
//
//
//
//
//
//
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     Navigator.push(
//       //       context,
//       //       MaterialPageRoute(builder: (context) => AddItemPage()),
//       //     );
//       //   },
//       //   child: const Icon(Icons.add),
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }
//
// // class AddItemPage extends StatelessWidget {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _titleController = TextEditingController();
// //   final TextEditingController _textFieldController = TextEditingController();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: const CleanerAppBar(title: 'CLEANER+'),
// //       backgroundColor: const Color.fromRGBO(30, 43, 45, 100), // Set the background color
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Container(
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(8.0),
// //                   color: Colors.white,
// //                 ),
// //                 child: TextFormField(
// //                   controller: _titleController,
// //                   decoration: const InputDecoration(
// //                     border: InputBorder.none,
// //                     hintText: 'Title',
// //                     contentPadding: EdgeInsets.all(16.0),
// //                   ),
// //                   style: const TextStyle(color: Colors.black),
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter a title';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               Container(
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(8.0),
// //                   color: Colors.white,
// //                 ),
// //                 child: TextFormField(
// //                   controller: _textFieldController,
// //                   maxLines: 5,
// //                   decoration: const InputDecoration(
// //                     border: InputBorder.none,
// //                     hintText: 'Text',
// //                     contentPadding: EdgeInsets.all(16.0),
// //                   ),
// //                   style: const TextStyle(color: Colors.black),
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter some text';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   if (_formKey.currentState!.validate()) {
// //                     // Process the form data
// //                     // For example, you can save it to a database
// //                     Navigator.of(context).pop();
// //                   }
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.blue,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(8.0),
// //                   ),
// //                 ),
// //                 child: const Text('Submit', style: TextStyle(color: Colors.white)), // Adjust button color
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           Navigator.pop(context);
// //         },
// //         child: const Icon(Icons.close),
// //       ),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
// //     );
//
