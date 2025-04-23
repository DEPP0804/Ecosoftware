import 'package:flutter/material.dart';

class SistemasCapitalizacion extends StatefulWidget {
  const SistemasCapitalizacion({super.key});

  @override
  State<SistemasCapitalizacion> createState() => _SistemasCapitalizacionState();
}

class _SistemasCapitalizacionState extends State<SistemasCapitalizacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistemas de Capitalización'),
        centerTitle: true,
      ),
      body: const Center(child: Text('Sistemas de Capitalización')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción del botón flotante
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
