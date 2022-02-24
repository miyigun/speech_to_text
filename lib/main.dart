import 'package:flutter/material.dart';
// Null safety uygun olmayan bir kütüphane
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SesdenYaziya(),
    );
  }
}

class SesdenYaziya extends StatefulWidget{
  @override
  _SesdenYaziya createState() => _SesdenYaziya();
}

class _SesdenYaziya extends State<SesdenYaziya>{
  late SpeechRecognition _speechRecognition;
  bool _isAvailable=false;
  bool _isListening=false;
  String resultText="";

  @override
  void initState(){
    super.initState();
    initLoad();
  }

  void initLoad(){
    _speechRecognition=SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
          (bool result)=> setState(() => _isAvailable=result),
    );

    _speechRecognition.setRecognitionStartedHandler(
          () => setState(() => _isListening=true),
    );

    _speechRecognition.setRecognitionResultHandler(
          (String speech) => setState(() => resultText=speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
          () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
    );

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  child: Icon(Icons.cancel),
                  mini: true,
                  backgroundColor: Colors.deepOrange,
                  onPressed: (){
                    if (_isListening)
                      _speechRecognition.cancel().then(
                              (result) => setState(() {
                            _isListening=result;
                            resultText="";
                          }
                          ));
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  onPressed: (){
                    if (_isAvailable && !_isListening)
                      _speechRecognition
                          .listen(locale: "tr_TR")
                          .then((result) => print('$result'));
                  },
                  backgroundColor: Colors.pink,
                ),
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  mini: true,
                  backgroundColor: Colors.deepPurple,
                  onPressed: (){
                    if (_isListening)
                      _speechRecognition
                          .stop()
                          .then((result) => setState(() => _isListening=result),
                      );
                  },
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.8,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Text(
                resultText,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


