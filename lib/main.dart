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
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    if (text.isEmpty) _clearAll();

    double real = double.parse(text);
    dolarController.text = (real / this.dolar).toStringAsPrecision(4);
    euroController.text = (real / this.euro).toStringAsPrecision(4);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) _clearAll();

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsPrecision(4);
    euroController.text = (dolar * this.dolar / euro).toStringAsPrecision(4);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) _clearAll();

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsPrecision(4);
    dolarController.text = (euro * this.euro / dolar).toStringAsPrecision(4);
  }

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('\$ Converter \$'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _clearAll,
          )
        ],
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
                      _buildTextField(
                          'Reais', 'R\$ ', realController, _realChanged),
                      Divider(),
                      _buildTextField(
                          'Dólares', 'US\$ ', dolarController, _dolarChanged),
                      Divider(),
                      _buildTextField(
                          'Euros', '€ ', euroController, _euroChanged),
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

Widget _buildTextField(String label, String prefix,
    TextEditingController controller, Function func) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.amber,
        ),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 18),
    onChanged: func,
    keyboardType: TextInputType.number,
  );
}
