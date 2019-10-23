import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=c8c062d8";

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.amber),
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
  double dolar;
  double euro;

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
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Reais',
                            labelStyle: TextStyle(
                              color: Colors.amber,
                            ),
                            border: OutlineInputBorder(),
                            prefixText: 'R\$ '),
                        style: TextStyle(color: Colors.amber, fontSize: 18),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Dólares',
                            labelStyle: TextStyle(
                              color: Colors.amber,
                            ),
                            border: OutlineInputBorder(),
                            prefixText: 'US\$ '),
                        style: TextStyle(color: Colors.amber, fontSize: 18),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Euros',
                            labelStyle: TextStyle(
                              color: Colors.amber,
                            ),
                            border: OutlineInputBorder(),
                            prefixText: '€ '),
                        style: TextStyle(color: Colors.amber, fontSize: 18),
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
