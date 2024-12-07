// import 'package:flutter/cupertino.dart';
//
// class BackgroundShapes extends StatelessWidget {
//   const BackgroundShapes({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Container(
//       width: double.infinity, // Takes the full width of the screen
//       height: screenHeight,           // Specify the height of the container
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           // Large circle
//           Positioned(
//             bottom: -100,
//             left: - screenWidth * 0.1,
//             child: Container(
//               width: 200,
//               height: 200,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF599954),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           // Medium circle
//           Positioned(
//             bottom: -30,
//             // right: screenWidth * 1,
//             child: Container(
//               width: 160,
//               height: 160,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF599954),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           // Small circle
//           Positioned(
//             bottom: -50,
//             right: -160,
//             child: Container(
//               width: 400,
//               height: 220,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF599954),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';

class BackgroundShapes extends StatelessWidget {
  const BackgroundShapes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity, // Takes the full width of the screen
      height: screenHeight, // Matches the height of the screen
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Large circle
          Positioned(
            bottom: -screenHeight * 0.1, // Responsive positioning
            left: -screenWidth * 0.1, // Responsive positioning
            child: Container(
              width: screenWidth * 0.5, // Responsive width
              height: screenWidth * 0.5, // Responsive height
              decoration: const BoxDecoration(
                color: Color(0xFF599954),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Medium circle
          Positioned(
            bottom: -screenHeight * 0.05, // Responsive positioning
            left: screenWidth * 0.2, // Centered positioning
            child: Container(
              width: screenWidth * 0.4, // Responsive width
              height: screenWidth * 0.4, // Responsive height
              decoration: const BoxDecoration(
                color: Color(0xFF599954),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Small circle
          Positioned(
            bottom: -screenHeight * 0.07, // Responsive positioning
            right: -screenWidth * 0.35, // Responsive positioning
            child: Container(
              width: screenWidth * 1, // Responsive width
              height: screenHeight * 0.25, // Responsive height
              decoration: const BoxDecoration(
                color: Color(0xFF599954),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
