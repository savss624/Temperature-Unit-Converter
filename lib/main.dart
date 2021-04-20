import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Converter(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Converter extends StatefulWidget {
  @override
  _ConverterState createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {

  Interpreter interpreter;
  loadModel() async {
    interpreter = await Interpreter.fromAsset('model.tflite');
  }

  String temp;
  predict() async {
    var input = [double.parse(temp)];
    var output = List(1*1).reshape([1,1]);

    interpreter.run(input, output);
    print(output);
    setState(() {
      result = output[0][0].toString();
    });
  }

  @override
  void initState() {
    loadModel();
    // TODO: implement initState
    super.initState();
  }

  String result = '';
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
                'assets/view.jpg',
              fit: BoxFit.cover,
              height: h,
              width: w,
            ),
            Padding(
              padding: EdgeInsets.all(36.0),
              child: Text(
                'Temperature\nUnit\nConverter',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    fontFamily: 'Overpass',
                    letterSpacing: 2,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: h / 3,
                width: w,
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.6),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '°C To °F',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          fontFamily: 'Overpass'
                        ),
                      ),
                      SizedBox(
                        height: h / 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: w / 2.6,
                            height: h / 16,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Overpass'
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '°C',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    fontFamily: 'Overpass'
                                ),
                              ),
                              onChanged: (value) {
                                temp = value;
                              },
                              onTap: () {
                                setState(() {
                                  result = '';
                                });
                              },
                            ),
                          ),
                          Text(
                            'To',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                fontFamily: 'Overpass'
                            ),
                          ),
                          Container(
                            width: w / 2.6,
                            height: h / 16,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: result == '' ? Center(
                              child: Text(
                                '°F',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    fontFamily: 'Overpass'
                                ),
                              ),
                            ) : Center(
                              child: Text(
                                result.substring(0, 12),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Overpass'
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h / 24,
                      ),
                      FlatButton(
                          onPressed: predict,
                          child: Text(
                            'Convert',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                fontFamily: 'Overpass'
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

