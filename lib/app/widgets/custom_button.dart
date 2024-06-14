import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color? color;
  final String text;
  final Color? textColor;
  final Function() onTap;

  const CustomButton(
      {super.key,
      this.color,
      required this.text,
      required this.onTap,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: (color != null) ? color : Colors.black),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        child: Center(
            child: Text(
          text,
          style:
              TextStyle(color: (textColor != null) ? textColor : Colors.white),
        )),
      ),
    );
  }
}
