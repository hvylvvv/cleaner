import 'package:flutter/material.dart';

class InputTextFeild extends StatelessWidget {
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController textEditingController;

  const InputTextFeild({
    required this.hintText,
    required this.textInputType,
    required this.textEditingController,
    Key? key, required String? Function(dynamic value) validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      ),
    );
  }
}


// class InputTextFeild extends StatelessWidget {
//   const InputTextFeild({
//     super.key,
//     required this.hintText,
//     required this.textInputType,
//     this.isPass = false,
//     required this.textEditingController,
//   });
//
//   final String hintText;
//   final TextInputType textInputType;
//   final bool isPass;
//   final TextEditingController textEditingController;
//
//   @override
//   Widget build(BuildContext context) {
//     final inputBorder =  OutlineInputBorder(borderSide: Divider.createBorderSide(context),
//         );
//
//     return TextField(
//       controller: textEditingController,
//       decoration: InputDecoration(
//         hintText: hintText,
//         border: inputBorder,
//         enabledBorder: inputBorder,
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       keyboardType: textInputType,
//       obscureText: isPass,
//     );
//   }
// }