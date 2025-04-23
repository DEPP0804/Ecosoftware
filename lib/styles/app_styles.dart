// lib/styles/app_styles.dart
import 'package:flutter/material.dart';

// ================================================================
// ==              Constantes Globales de UI                    ==
// ================================================================
// ¡ASEGÚRATE DE QUE ESTÉN DEFINIDAS AQUÍ y quítalas de otros archivos!
const double kDefaultPadding = 16.0;
const double kDefaultBorderRadius = 12.0;


// ================================================================
// ==              Paleta de Colores Principal (Azul)           ==
// ================================================================
const Color kPrimaryBlue = Color(0xFF0D47A1); // Azul oscuro principal
const Color kSecondaryBlue = Color(0xFF1976D2); // Azul medio
const Color kLightBlue = Color(0xFFBBDEFB);   // Azul claro
const Color kSurfaceColor = Colors.white;     // Fondo formularios/tarjetas
const Color kBackgroundColor = Color(0xFFF5F5F5); // Fondo general app
const Color kTextColorDark = Color(0xFF212121);  // Texto principal
const Color kTextColorMedium = Color(0xFF757575); // Texto secundario
const Color kErrorColor = Color(0xFFD32F2F);    // Rojo para errores
const Color kSuccessColor = Color(0xFF388E3C);   // Verde para éxito
const Color kWarningColor = Color(0xFFFBC02D); // Amarillo para advertencia


// ================================================================
// ==              Definición del Tema de la Aplicación         ==
// ================================================================
class AppTheme {
  // --- TEMA CLARO ---
  static ThemeData lightTheme = ThemeData(
    // --- Esquema de Color ---
    colorScheme: const ColorScheme(
      primary: kPrimaryBlue,
      secondary: kSecondaryBlue,
      surface: kSurfaceColor,
      background: kBackgroundColor,
      error: kErrorColor,
      // Colores "On"
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: kTextColorDark,
      onBackground: kTextColorDark,
      onError: Colors.white,
      brightness: Brightness.light,
    ),

    // --- Fondo General ---
    scaffoldBackgroundColor: kBackgroundColor,

    // --- Tipografía ---
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kTextColorDark),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kTextColorDark),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: kTextColorDark),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kTextColorDark),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kTextColorDark),
      bodyLarge: TextStyle(fontSize: 16, color: kTextColorDark, height: 1.4),
      bodyMedium: TextStyle(fontSize: 14, color: kTextColorMedium, height: 1.4),
      bodySmall: TextStyle(fontSize: 12, color: kTextColorMedium, height: 1.3),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ).apply( bodyColor: kTextColorDark, displayColor: kTextColorDark ),

    // --- Estilos de Widgets Específicos ---
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimaryBlue, foregroundColor: Colors.white, elevation: 0,
      centerTitle: true, titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: kSurfaceColor.withOpacity(0.8),
      contentPadding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 0.9, horizontal: kDefaultPadding),
      border: OutlineInputBorder( borderRadius: BorderRadius.circular(kDefaultBorderRadius), borderSide: BorderSide(color: kTextColorMedium.withOpacity(0.3), width: 1),),
      enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(kDefaultBorderRadius), borderSide: BorderSide(color: kTextColorMedium.withOpacity(0.3), width: 1),),
      focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(kDefaultBorderRadius), borderSide: const BorderSide(color: kPrimaryBlue, width: 1.5),),
      errorBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(kDefaultBorderRadius), borderSide: const BorderSide(color: kErrorColor, width: 1),),
      focusedErrorBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(kDefaultBorderRadius), borderSide: const BorderSide(color: kErrorColor, width: 1.5),),
      labelStyle: const TextStyle(color: kTextColorMedium, fontSize: 14),
      floatingLabelStyle: const TextStyle(color: kPrimaryBlue, fontSize: 14),
      hintStyle: const TextStyle(color: kTextColorMedium, fontSize: 14),
      errorStyle: const TextStyle(fontSize: 12, color: kErrorColor, height: 1.0),
      prefixIconColor: kTextColorMedium, suffixIconColor: kTextColorMedium,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryBlue, foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 0.75, horizontal: kDefaultPadding * 1.5),
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(kDefaultBorderRadius),),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        elevation: 2, shadowColor: kPrimaryBlue.withOpacity(0.2),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kSecondaryBlue,
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2, horizontal: kDefaultPadding / 2),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
         shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),),
      ),
    ),

     cardTheme: CardTheme(
       elevation: 1.5, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultBorderRadius)),
       color: kSurfaceColor, margin: const EdgeInsets.only(bottom: kDefaultPadding),
     ),

     snackBarTheme: SnackBarThemeData(
       backgroundColor: kTextColorDark, contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
       behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultBorderRadius / 1.5)),
       elevation: 4,
     ),

     iconTheme: const IconThemeData( color: kTextColorMedium, size: 22.0,),
     primaryIconTheme: const IconThemeData( color: kPrimaryBlue),

     dividerTheme: DividerThemeData(
        color: kTextColorMedium.withOpacity(0.2),
        thickness: 1,
        space: kDefaultPadding * 2,
     ),

     // ***** INICIO SECCIÓN AÑADIDA / MODIFICADA *****
     bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kSurfaceColor,       // Fondo blanco
        selectedItemColor: kPrimaryBlue,      // Ítem activo en Azul primario
        unselectedItemColor: kTextColorMedium,  // Ítem inactivo en Gris medio
        type: BottomNavigationBarType.fixed, // ¡Esencial para >3 ítems!
        showSelectedLabels: true,           // Mostrar label activo
        showUnselectedLabels: true,         // Mostrar label inactivo
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), // Estilo label activo
        unselectedLabelStyle: const TextStyle(fontSize: 12), // Estilo label inactivo
        // selectedIconTheme: IconThemeData(size: 24), // Opcional: tamaño icono activo
        // unselectedIconTheme: IconThemeData(size: 22), // Opcional: tamaño icono inactivo
        elevation: 8.0, // Sombra para darle separación
      ),
     // ***** FIN SECCIÓN AÑADIDA / MODIFICADA *****

  ); // Fin de ThemeData
} // Fin de clase AppTheme

// --- Extensiones para Colores Personalizados ---
extension CustomColorScheme on ColorScheme {
  Color get success => brightness == Brightness.light ? kSuccessColor : Colors.greenAccent;
  Color get onSuccess => brightness == Brightness.light ? Colors.white : kTextColorDark;
  Color get warning => brightness == Brightness.light ? kWarningColor : Colors.amberAccent;
  Color get onWarning => brightness == Brightness.light ? kTextColorDark : kTextColorDark;
}