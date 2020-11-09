import 'package:flutter/material.dart';
//Agrego esta weas de librerias
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;

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
                    Text('Formato: ${_scanResult.format.toString()}'),
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
    setState(() {
      _scanResult = result;
    });
  }

//Con este método hacemos una peticion al API Rest
  Future<http.Response> fetchPost() {
    return http.get('https://lpooii-grupo4.herokuapp.com/getTickets');
    //Despues de esto quisiera leer una lista JSON en un bucle y si no existe nada
    //Entonces no puede pasar pero si coincide el codigo con el _id y est CONFIRMADO
    //Entonces si pasa a ver la pelicula :'v
  }
}

//Con esta wea obtenemos la info de la API
class Ticket {
  String _id;
  String _estado;

  Ticket(this._id, this._estado);

  get getId => this._id;
  get getEstado => this._estado;

  set setId(String value) => this._id = value;
  set setEstado(String value) => this._estado = value;

  factory Ticket.fromJSON(Map<String, dynamic> json) {
    return Ticket(json['_id'].toString(), json['estado'].toString());
  }
}
