import 'package:flutter/material.dart';

class CleanerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  // CleanerAppBar({Key key}) : preferredSize = .Size.f
  const CleanerAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return AppBar(
      // toolbarHeight: 70.0,
      title: Text(
        'Cleaner+',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'MontserratAlternates',
          fontSize: screenWidth * 0.08,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xFF599954),

    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
      // throw UnimplementedError();
}
