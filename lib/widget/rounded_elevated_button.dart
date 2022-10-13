
import 'package:flutter/material.dart';
import 'package:prediction/util/constant.dart';




class RoundedElevatedButton extends StatelessWidget {
  RoundedElevatedButton(
      {required this.width, required this.onPressed, required this.childText});

  final double width;
  final VoidCallback onPressed;
  final String childText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          childText,
          style:
          TextStyle( color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14 )

        ),
        style: ElevatedButton.styleFrom(
            primary: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            elevation: 0,
            padding: EdgeInsets.only(
                left: 14, right: 14, top: 14, bottom: 14)),
      ),
    );
  }
}
