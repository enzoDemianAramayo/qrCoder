import 'package:flutter/material.dart';
//Agrego esta weas de librerias
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      home: MyHomePage(),
    ));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScanResult _scanResult;

  //Acá va la magía

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lector códigos QR'),
      ),
      body: Center(
          child: _scanResult == null
              ? Text('Esperando datos de código')
              : Column(
                  children: [
                    Text('Contenido: ${_scanResult.rawContent}'),
                    Text('Estado: ${_validado}'),
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scanCode();
        },
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

//Método para escanear el codigo Qr
  Future<void> _scanCode() async {
    var result = await BarcodeScanner.scan();
    //Ahora vamos a mandar el codigo escaneado con el método GET a nuestr BD en la Nube.
    recibirRespuestaGET(result.toString());

    if (this._id == result.toString() && this._estado == "CONFIRMADO") {
      setState(() {
        _validado = "CONFIRMADO";
      });
    } else {
      setState(() {
        _validado = "DENEGADO";
      });
    }
  }

  Future<void> recibirRespuestaGET(String result) async {
    final respuesta = await http
        .get('https://lpooii-grupo4.herokuapp.com/getTicket/?id=' + result);
    if (respuesta.statusCode == 200) {
      setState(() {
        var parsedJson = json.decode(respuesta.body);
        _id = parsedJson["_id"];
        _estado = parsedJson["estado"];
      });
    } else {
      throw Exception("Fallo");
    }
  }

//Lo puse aca porque soy TROLL :'v
  String _id;
  String _estado;
  String _validado = "";
}
