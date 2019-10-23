import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=c8c062d8";

void main() async {
  Response response = await get(request);
  print(json.decode(response.body)['results']['currencies']['USD']);

  runApp(MaterialApp(
    home: Container(),
  ));
}
