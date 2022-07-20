import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:texttospeachapp/utils/Colors.dart';
import 'package:texttospeachapp/utils/languages.dart';
import 'package:translator/translator.dart';
import 'package:avatar_glow/avatar_glow.dart';

class SpeachToTextTranslate extends StatefulWidget {
  const SpeachToTextTranslate({Key? key}) : super(key: key);

  @override
  _SpeechToTextTranslateState createState() => _SpeechToTextTranslateState();
}

class _SpeechToTextTranslateState extends State<SpeachToTextTranslate> {
  String? selectedto = "Hindi";
  bool isTranslate = true; // to check if the text is translated or not
  var finaltext = "";
  final stt.SpeechToText _speachtotext = stt.SpeechToText();

  bool isListening = false;
  String speechToText = "Press the button and start speaking";
   //TextEditingController textController = TextEditingController();
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

  void listen() async {
    if (isListening == false) {
      bool available = await _speachtotext.initialize(
          onStatus: (v) => {}, onError: (v) => {});
      if (available) {
        setState(() {
          isListening = true;
        });
        _speachtotext.listen(onResult: (value) {
          speechToText = value.recognizedWords;
        });
      }
    } else {
      setState(() {
        isListening = false;
      });
    }
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
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple, width: 3),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    speechToText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: colorsUsed.buttoncolor,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: speechToText));
                      },
                      child: Icon(
                        Icons.copy,
                        color: colorsUsed.iconcolor,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Card(
                    color: colorsUsed.dropdowncolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 25,
                    child: SizedBox(
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
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hoverColor: colorsUsed.color,
                                fillColor: colorsUsed.color,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
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
                              finaltext = speechToText;
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
                      output == null
                          ? Container()
                          : Padding(
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
                                          color: colorsUsed.textcolor,
                                          fontSize: 17),
                                    ),
                                  )),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
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
                      const SizedBox(
                        height: 300,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: colorsUsed.iconcolor,
        endRadius: 75,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
            backgroundColor: colorsUsed.buttoncolor,
            onPressed: () {
              listen();
            },
            child: isListening
                ? Icon(
                    Icons.mic,
                    color: colorsUsed.iconcolor,
                  )
                : Icon(Icons.mic_none, color: colorsUsed.iconcolor)),
      ),
    );
  }
}
