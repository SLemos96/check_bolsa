// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
// import 'result.dart';

const request =
    "https://api.hgbrasil.com/finance/stock_price?key=410b24bd&symbol=";

void main() {
  runApp(const MyApp());
}

Future<Map> getData(acao) async {
  http.Response response = await http.get(request + acao);
  return json.decode(response.body);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bolsa',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _valorAcao = 40.2;
  // String _acao = ""; //chave de busca
  TextEditingController acaoController = TextEditingController();
  TextEditingController pesoController = TextEditingController();

  void _buscar() {
    //requisição tem que ser feita em cima dessa string
    print(request + acaoController.text);
    getData(acaoController.text);

    // debugPrint("Peso ${request} e altura ${acaoController.text}");
    //debugPrint("$imc");

    // Navigator.push(context, MaterialPageRoute(builder: (context) => Result(_imagem, _texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildFutureBuilder(),
    );
  }

  buildFutureBuilder() {
    return FutureBuilder<Map>(
        future: getData("itsa4"),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                  child: Text(
                "Carregando dados...",
                style: TextStyle(color: Colors.amber, fontSize: 25.0),
                textAlign: TextAlign.center,
              ));
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  "Erro ao carregar dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              } else {
                _valorAcao = snapshot.data?["results"]["ITSA4"]["price"];
                return Center(
                    child: Text(
                  "$_valorAcao",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              }
          }
        });
  }
}
