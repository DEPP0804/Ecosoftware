import 'package:flutter/material.dart';
import 'package:ecosoftware/styles/app_styles.dart'; // Para usar kDefaultPadding
import 'package:ecosoftware/Views/Pages/credit_card_payment_page.dart'; // <-- Importación ya presente, ¡bien!
import 'package:ecosoftware/Views/Pages/mobile_recharge_page.dart'; // <-- AÑADE ESTA LÍNEA
import 'package:ecosoftware/Views/Pages/public_services_payment_page.dart'; // <-- AÑADE ESTA LÍNEA

class PaymentsPage extends StatefulWidget {
  // Si necesitas pasar datos a esta página (poco común para una pestaña principal),
  // puedes añadirlos aquí. Por ahora, la dejamos simple.
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Acceso al tema actual
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Como esta página se mostrará dentro del IndexedStack de HomePage,
    // NO necesitas un Scaffold ni un AppBar aquí. HomePage ya los provee.
    // Simplemente devuelve el contenido principal de la página.
    return ListView(
      // Usamos ListView para permitir scroll si el contenido crece
      padding: const EdgeInsets.all(kDefaultPadding), // Padding consistente
      children: <Widget>[
        // --- Título de la Sección ---
        Padding(
          padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
          child: Text(
            "Realizar Pagos",
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.primary, // O el color que prefieras
            ),
          ),
        ),

        // --- Aquí irá el contenido específico de Pagos ---
        // Puedes empezar con texto, botones, listas, etc.
        Card(
          child: ListTile(
            leading: Icon(
              Icons.phone_android_outlined,
              color: colorScheme.secondary,
            ),
            title: Text('Recargas Celular', style: textTheme.titleMedium),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // --- NAVEGACIÓN MODIFICADA ---
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MobileRechargePage(),
                ),
              );
              // --- FIN NAVEGACIÓN ---
            },
          ),
        ),
        const SizedBox(height: kDefaultPadding), // Espacio entre opciones
        Card(
          child: ListTile(
            leading: Icon(
              Icons.receipt_long_outlined,
              color: colorScheme.secondary,
            ),
            title: Text(
              'Pagar Servicios Públicos',
              style: textTheme.titleMedium,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // --- NAVEGACIÓN MODIFICADA ---
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PublicServicesPaymentPage(),
                ),
              );
              // --- FIN NAVEGACIÓN ---
            },
          ),
        ),
        const SizedBox(height: kDefaultPadding),

        Card(
          child: ListTile(
            leading: Icon(
              Icons.credit_card_outlined,
              color: colorScheme.secondary,
            ),
            title: Text(
              'Pago Tarjeta de Crédito',
              style: textTheme.titleMedium,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // --- NAVEGACIÓN MODIFICADA ---
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreditCardPaymentPage(),
                ),
              );
              // --- FIN NAVEGACIÓN ---
            },
          ),
        ),

        // Puedes añadir más opciones aquí (Pago de facturas, transferencias programadas, etc.)
        const SizedBox(height: kDefaultPadding * 2), // Espacio al final
        Center(
          child: Text(
            'Más opciones de pago próximamente...',
            style: textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
