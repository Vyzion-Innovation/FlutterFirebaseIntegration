import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(label!),
        ),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 239, 234, 234),
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the value';
            }
            return null;
          },
        ),
      ],
    );
  }
}
