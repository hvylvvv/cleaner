// import 'dart:async';
// import 'package:flutter/material.dart';
//
// import 'login_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2), // Adjust duration as needed
//     );
//
//     _animation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(_controller);
//
//     // Start animation
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Navigate after 3 seconds
//     Timer(const Duration(seconds: 3), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => const LoginScreen(), // Replace with your main page
//         ),
//       );
//     });
//
//     return Scaffold(
//       backgroundColor: Colors.white, // White background
//       body: Center(
//         child: FadeTransition(
//           opacity: _animation,
//           child: const Text(
//             'Cleaner+',
//             style: TextStyle(
//               fontSize: 48,
//               fontWeight: FontWeight.w300,
//               // fontStyle: FontStyle.italic,
//               color: Colors.black, // Text color
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
