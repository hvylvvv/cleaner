import 'package:flutter/material.dart';

class CleanerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  // CleanerAppBar({Key key}) : preferredSize = .Size.f
  const CleanerAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // toolbarHeight: 70.0,
      title: const Text(
        'CLEANER+',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color.fromRGBO(30, 43, 45, 100),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
      // throw UnimplementedError();
}
