import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=c8c062d8";

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

Future<Map> getData() async {
  Response response = await get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('\$ Converter \$'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text('Loading data...',
                      style: TextStyle(color: Colors.green, fontSize: 18),
                      textAlign: TextAlign.center));
              break;
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading data :(',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center));
              } else {
                return Container(
                  color: Colors.green,
                );
              }
          }
        },
      ),
    );
  }
}
