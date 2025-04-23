import 'package:ecosoftware/Views/Pages/amortizacion.dart';
import 'package:ecosoftware/Views/Pages/anualidades.dart';
import 'package:ecosoftware/Views/Pages/interes_compuesto.dart';
import 'package:ecosoftware/Views/Pages/interes_simple.dart';
import 'package:ecosoftware/Views/Pages/sistemas_capitalizacion.dart';
import 'package:ecosoftware/Views/home_page.dart';
import 'package:ecosoftware/Views/login_view/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// Importar estilos donde está AppTheme
import 'package:ecosoftware/styles/app_styles.dart';
// --- ¡NUEVA IMPORTACIÓN NECESARIA! ---
import 'package:firebase_auth/firebase_auth.dart';
// --- FIN IMPORTACIÓN ---
// Opcional: para inicialización específica de Firebase
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // --- INICIO: CONFIGURAR PERSISTENCIA DE SESIÓN ---
  try {
    // Establece que la sesión del usuario solo dure mientras la app esté activa
    // en la memoria (se cierra al matar el proceso de la app).
    await FirebaseAuth.instance.setPersistence(Persistence.SESSION);
    print(
      "Persistencia de Firebase Auth establecida en SESSION.",
    ); // Mensaje de confirmación (opcional)
  } catch (e) {
    // Es raro que falle, pero es bueno saber si ocurre
    print("Error al establecer la persistencia de Firebase: $e");
    // Aquí podrías decidir si continuar o mostrar un error crítico
  }
  // --- FIN: CONFIGURAR PERSISTENCIA DE SESIÓN ---

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecosoftware',
      // Usar el tema personalizado
      theme: AppTheme.lightTheme,
      home: const WidgetTree(), // WidgetTree manejará si mostrar Login o Home
      routes: {
        // Rutas nombradas (sin const si las páginas no son const)
        '/home': (context) => HomePage(),
        '/interes_simple': (context) => InteresSimplePage(),
        '/interes_compuesto': (context) => InteresCompuestoPage(),
        '/anualidades': (context) => AnualidadesPage(),
        '/amortizacion': (context) => AmortizacionPage(),
        '/sistemas_capitalizacion': (context) => SistemasCapitalizacionPage(),
        // '/settings': (context) => SettingsPage(), // Añade la ruta a Settings si la usas
      },
    );
  }
}
