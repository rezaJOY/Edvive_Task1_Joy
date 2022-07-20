import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:texttospeachapp/utils/Colors.dart';
import 'package:texttospeachapp/utils/languages.dart';
import 'package:translator/translator.dart';

class TextTranslate extends StatefulWidget {
  const TextTranslate({Key? key}) : super(key: key);

  @override
  _TextTranslateState createState() => _TextTranslateState();
}

class _TextTranslateState extends State<TextTranslate> {
  String? selectedto = "Hindi";
  bool isTranslate = true;
  var finaltext = "";

  TextEditingController textController = TextEditingController();
  int initialindex = 1;
  final translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();
  var output;
  translate(String text, String lang) async {
    await translator.translate(text, to: lang).then((value) {
      setState(() {
        output = value;

        isTranslate = true;
      });
    });
    await flutterTts.setLanguage(lang);
    await flutterTts.setPitch(0.7);
    await flutterTts.speak(output.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0xff6C63FF),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: textController,
                  style: const TextStyle(color: Colors.white, fontSize: 20.0),
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Text',
                    labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                    // hintText: "Enter Text",
                    // hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.deepPurple
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Card(
                    color: colorsUsed.dropdowncolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 25,
                    child: Container(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Convert To",
                            style: TextStyle(
                                color: colorsUsed.textcolor,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(color: colorsUsed.color),
                            // color: Colors.white,
                            width: 150,
                            height: 90,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hoverColor: colorsUsed.color,
                                fillColor: colorsUsed.color,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                      width: 5, color: colorsUsed.color),
                                ),
                              ),
                              value: selectedto,
                              items: Translation_languages.select_languages
                                  .map((language) => DropdownMenuItem<String>(
                                        value: language,
                                        child: Text(
                                          language,
                                          style: TextStyle(
                                              color: colorsUsed.textcolor),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (language) =>
                                  setState(() => selectedto = language),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.deepPurpleAccent,
                              ),
                              iconSize: 42,
                              // // underline: SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      primary: colorsUsed.buttoncolor,
                    ),
                          onPressed: () {
                            setState(() {
                              isTranslate = false;
                            });
                            output = "";
                            setState(() {
                              finaltext = textController.text;
                            });
                            translate(
                                finaltext,
                                Translation_languages.getLanguageCode(
                                    selectedto!));
                          },
                          child: isTranslate
                              ? Padding(
                                  padding: const EdgeInsets.all(20.0),

                                  child: Text(
                                    "Translate",
                                    style: TextStyle(
                                        color: colorsUsed.textcolor,
                                        fontWeight: FontWeight.bold),
                                  ),

                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    color: colorsUsed.textcolor,
                                  ),
                                )),
                      const SizedBox(
                        height: 50,
                      ),
                      output==null?Container():Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            color: colorsUsed.cardcolor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 25,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                output == null ? "" : output.toString(),
                                style: TextStyle(
                                    color: colorsUsed.textcolor, fontSize: 17),
                              ),
                            )),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                primary: Colors.white,
                              ),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: output.toString()));
                              },
                              child: const Icon(
                                Icons.copy,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
