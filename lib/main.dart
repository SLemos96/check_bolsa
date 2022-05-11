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
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Falha ao carregar dados...');
  }
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
  double _valorAcao = 0.0;
  String _acao = ""; //chave de busca
  TextEditingController acaoController = TextEditingController();
  TextEditingController pesoController = TextEditingController();

  void _buscar() {
    //requisição tem que ser feita em cima dessa string
    print(request + acaoController.text);
    getData(acaoController.text);

    _acao = acaoController.text;
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   '$_valorAcao',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
            buildFutureBuilder(),
            TextFormField(
              // keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Código da Ação",
                  labelStyle: TextStyle(color: Colors.blueAccent)),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
              controller: acaoController,
              validator: (String? value) {
                if (value != null && value.isEmpty) return "Insira seu peso!";
              },
            ),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        // if (_formKey.currentState.validate()) {
                        _buscar();
                        setState(() {});
                        // }
                      },
                      child: Text(
                        "Buscar",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ))),
          ],
        ),
      ),
    );
  }

  buildFutureBuilder() {
    if (_acao.isEmpty) {
      return Center(
          child: Text(
        "",
        style: TextStyle(color: Colors.amber, fontSize: 25.0),
        textAlign: TextAlign.center,
      ));
    } else {
      return FutureBuilder<Map>(
          future: getData(_acao),
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
                  _valorAcao =
                      snapshot.data?["results"][_acao.toUpperCase()]["price"];
                  if (snapshot.data?["results"][_acao.toUpperCase()]
                          ["change_percent"] >
                      0) {
                    return Center(
                        child: Text(
                      "R\$ $_valorAcao",
                      style: TextStyle(color: Colors.green, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    return Center(
                        child: Text(
                      "R\$ $_valorAcao",
                      style: TextStyle(color: Colors.red, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  }
                }
            }
          });
    }
  }
}
