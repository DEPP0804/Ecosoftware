import 'package:flutter/material.dart';

class SistemasCapitalizacionPage extends StatefulWidget {
  const SistemasCapitalizacionPage({super.key});

  @override
  State<SistemasCapitalizacionPage> createState() =>
      _SistemasCapitalizacionPageState();
}

class _SistemasCapitalizacionPageState
    extends State<SistemasCapitalizacionPage> {
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
