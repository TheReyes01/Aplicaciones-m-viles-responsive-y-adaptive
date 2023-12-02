import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prueba de Programación Flutter',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // StreamController para emitir los datos
  final StreamController<List<String>> _streamController =
      StreamController.broadcast();

  // Lista de datos para mostrar en el ListView
  List<String> _data = ["Juan", "Pedro", "María", "José"];

  // Timer para emitir nuevos datos en el Stream
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Inicializamos el timer para emitir nuevos datos cada 2 segundos
    _timer = Timer.periodic(Duration(seconds: 2), (_) => _emitData());
  }

  @override
  void dispose() {
    // Nos aseguramos de cancelar el timer antes de destruir el widget
    _timer.cancel();

    // Cerramos el StreamController
    _streamController.close();

    super.dispose();
  }

  List<String> _emitData() {
    // Generamos una nueva lista de datos aleatorio
    List<String> data = List.from(_data)..shuffle();

    // Emitimos el dato en el Stream
    _streamController.add(data);

    // Devolvemos la lista de datos
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba de Programación Flutter'),
      ),
      body: Center(
        child: StreamBuilder<List<String>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            // Si el Stream está activo
            if (snapshot.connectionState == ConnectionState.active) {
              // Si hay datos disponibles
              if (snapshot.hasData) {
                // Devolvemos el nombre en medio de la pantalla
                return Text(snapshot.data!.first);
              } else {
                // Devolvemos un mensaje de error
                return Text('No hay datos disponibles');
              }
            } else {
              // Si el Stream está esperando
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Devolvemos un mensaje de espera
                return Text('Esperando datos...');
              } else {
                // Si el Stream está en error
                if (snapshot.hasError) {
                  // Devolvemos un mensaje de error
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Devolvemos un mensaje vacío
                  return Container();
                }
              }
            }
          },
        ),
      ),
    );
  }
}
