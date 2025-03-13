import 'package:flutter/material.dart';

// Colores principales de la app financiera
const Color primaryColor = Color(0xFF4CAF50); // Verde principal
const Color secondaryColor = Color(0xFF81C784); // Verde secundario
const Color backgroundColor = Color(0xFFFFFFFF); // Fondo claro
const Color textColor = Color(0xFF2E7D32); // Texto oscuro
const Color defaultColor = Color(0xFF000000); // Color por defecto
const Color accentColor = Color(0xFF66BB6A); // Color de acento
const Color errorColor = Color(0xFFD32F2F); // Color para errores
const Color successColor = Color(0xFF388E3C); // Color para éxito
const Color warningColor = Color(0xFFFBC02D); // Color para advertencias

// Estilo de texto reutilizable
const TextStyle headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle headingStyle2 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: defaultColor,
);

const TextStyle subHeadingStyle = TextStyle(
  fontSize: 18,
  color: textColor,
  fontWeight: FontWeight.w500,
);

const TextStyle bodyTextStyle = TextStyle(
  fontSize: 16,
  color: textColor,
  fontWeight: FontWeight.normal,
);

const TextStyle buttonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const TextStyle errorTextStyle = TextStyle(
  fontSize: 14,
  color: errorColor,
  fontWeight: FontWeight.normal,
);

const TextStyle successTextStyle = TextStyle(
  fontSize: 14,
  color: successColor,
  fontWeight: FontWeight.normal,
);

const TextStyle warningTextStyle = TextStyle(
  fontSize: 14,
  color: warningColor,
  fontWeight: FontWeight.normal,
);

// Estilo de los campos de entrada
InputDecoration inputDecoration(String label, {String? errorText}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: textColor),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: accentColor, width: 2),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: secondaryColor, width: 1),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: errorColor, width: 1),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: errorColor, width: 2),
    ),
    errorText: errorText,
    border: const OutlineInputBorder(),
  );
}

// Botón estilizado reutilizable
Widget customButton({required String text, required VoidCallback onPressed}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
    onPressed: onPressed,
    child: Text(text, style: buttonTextStyle),
  );
}

// Botón secundario estilizado
Widget customSecondaryButton({
  required String text,
  required VoidCallback onPressed,
}) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
    onPressed: onPressed,
    child: Text(text, style: buttonTextStyle.copyWith(color: primaryColor)),
  );
}

// Estilo de tarjeta reutilizable
Widget customCard({required Widget child}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.white,
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );
}

// Estilo de alerta reutilizable
void showCustomSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: isError ? errorColor : successColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
