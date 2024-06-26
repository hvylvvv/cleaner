import 'package:flutter/material.dart';

class InputTextFeild extends StatelessWidget {
  const InputTextFeild({
    super.key,
    required this.hintText,
    required this.textInputType,
    this.isPass = false,
    required this.textEditingController,
  });

  final String hintText;
  final TextInputType textInputType;
  final bool isPass;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final inputBorder =  OutlineInputBorder(borderSide: Divider.createBorderSide(context),
        );
   
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}