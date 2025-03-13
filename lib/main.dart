import 'package:ecosoftware/Views/Pages/amortizacion.dart';
import 'package:ecosoftware/Views/Pages/anualidades.dart';
import 'package:ecosoftware/Views/Pages/interes_compuesto.dart';
import 'package:ecosoftware/Views/Pages/interes_simple.dart';
import 'package:ecosoftware/Views/home_page.dart';
import 'package:ecosoftware/Views/login_view/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WidgetTree(),
      routes: {
        '/home': (context) => HomePage(),
        '/interes_simple': (context) => InteresSimplePage(),
        '/interes_compuesto': (context) => InteresCompuestoPage(),
        '/anualidades': (context) => AnualidadesPage(),
        '/amortizacion': (context) => AmortizacionPage(),
      },
    );
  }
}
