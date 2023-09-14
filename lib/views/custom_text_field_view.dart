import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  const CustomTextField({Key? key, required this.controller, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(hintText: title),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}