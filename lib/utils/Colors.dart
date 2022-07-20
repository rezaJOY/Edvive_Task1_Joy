import 'package:flutter/material.dart';

class colorsUsed {
  static final Color color = Colors.grey.shade200;
  static final Color buttoncolor = Colors.grey.shade200;
  static final Color cardcolor = Colors.grey.shade200;
  static final Color appbarbackgroundColor = Colors.grey.shade200;
  static final Color bottomcolor = Colors.grey.shade400;
  static final Color dropdowncolor = Colors.grey.shade200;
  static final Color textcolor = Colors.deepPurple;
  static final Color iconcolor = Color(0xff6C63FF);
}

class iconUsed {
  static final items = <Widget>[
     Icon(
         Icons.text_fields_rounded,
         color: colorsUsed.iconcolor),
    Icon(
      Icons.mic_sharp,
      color: colorsUsed.iconcolor,
    ),
  ];
}
