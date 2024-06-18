import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.blue, // text color
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          // side: BorderSide(color: Colors.red) // if you want to add border color
        ),
        elevation: 3, // button shadow
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
