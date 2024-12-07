import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController textEditingController;

  const PasswordTextField({
    required this.hintText,
    required this.textInputType,
    required this.textEditingController,
    super.key, required String? Function(dynamic value) validator,
  });

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false; // Tracks whether the password is visible

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      keyboardType: widget.textInputType,
      obscureText: !_isPasswordVisible, // Toggle password visibility
      decoration: InputDecoration(
        hintText: widget.hintText,
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
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
            });
          },
        ),
      ),
    );
  }
}

//
//
// class PasswordTextField extends StatefulWidget {
//   const PasswordTextField({
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
//   _PasswordTextFieldState createState() => _PasswordTextFieldState();
// }
//
// class _PasswordTextFieldState extends State<PasswordTextField> {
//   bool _isObscure = true;
//
//   @override
//   Widget build(BuildContext context) {
//     final inputBorder = OutlineInputBorder(
//       borderSide: Divider.createBorderSide(context),
//     );
//
//     return TextField(
//       controller: widget.textEditingController,
//       decoration: InputDecoration(
//         hintText: widget.hintText,
//         border: inputBorder,
//         enabledBorder: inputBorder,
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//         suffixIcon: widget.isPass
//             ? IconButton(
//           icon: Icon(
//             _isObscure ? Icons.visibility : Icons.visibility_off,
//           ),
//           onPressed: () {
//             setState(() {
//               _isObscure = !_isObscure;
//             });
//           },
//         )
//             : null,
//       ),
//       keyboardType: widget.textInputType,
//       obscureText: widget.isPass && _isObscure,
//     );
//   }
// }
