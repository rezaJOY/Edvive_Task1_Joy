import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:texttospeachapp/Speechtotexttranslate.dart';
import 'package:texttospeachapp/texttranslate.dart';
import 'package:texttospeachapp/utils/Colors.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  
  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  var initialindex = 1;
  var currentindex = 1;
  var screens = [
    const TextTranslate(),
    const SpeachToTextTranslate()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
         backgroundColor: Colors.white,
        title: Center(
            child: Text(
          "Translator App",
          style: TextStyle(color: colorsUsed.textcolor),
        )),
      ),
      body: screens[currentindex],
      bottomNavigationBar: CurvedNavigationBar(
        index: initialindex,
        height: 50,
        backgroundColor: Colors.transparent,
        items: iconUsed.items,
        onTap: (index) {
          setState(() {
                      currentindex = index;

          });
        },
      ),
    );
  }
}
