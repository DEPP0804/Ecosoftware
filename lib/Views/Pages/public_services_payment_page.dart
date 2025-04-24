import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecosoftware/styles/app_styles.dart'; // Para kDefaultPadding
// --- IMPORTACIONES DE FIREBASE (si las necesitas para cuentas/servicios) ---
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Para formatear moneda

class PublicServicesPaymentPage extends StatefulWidget {
  const PublicServicesPaymentPage({Key? key}) : super(key: key);

  @override
  State<PublicServicesPaymentPage> createState() => _PublicServicesPaymentPageState();
}

class _PublicServicesPaymentPageState extends State<PublicServicesPaymentPage> {
  final _formKey = GlobalKey<FormState>();

  // --- Controladores y Variables de Estado ---
  String? _selectedService; // Servicio público seleccionado
  final _referenceController = TextEditingController(); // Número de factura/referencia
  final _amountController = TextEditingController(); // Monto a pagar
  String? _selectedSourceAccount; // Cuenta de origen
  bool _isLoading = false;
  String? _errorMessage;

  // --- Datos de Ejemplo (Reemplazar con datos reales/API/Firestore) ---
  // Lista de servicios comunes (puedes obtenerla de Firestore o una config)
  final List<Map<String, dynamic>> _services = [
    {'id': 'energia', 'name': 'Energía Eléctrica (Afinia)', 'icon': Icons.lightbulb_outline},
    {'id': 'agua', 'name': 'Acueducto y Alcantarillado (Emdupar)', 'icon': Icons.water_drop_outlined},
    {'id': 'gas', 'name': 'Gas Natural (Gases del Caribe)', 'icon': Icons.local_fire_department_outlined},
    {'id': 'internet', 'name': 'Internet/Telefonía Hogar', 'icon': Icons.wifi},
    // Agrega más servicios según necesites
  ];

  // Cuentas de origen (igual que en ejemplos anteriores)
  final List<Map<String, String>> _sourceAccounts = [
    {'id': 'sa1', 'display': 'Ahorros **** 9876'},
    {'id': 'sa2', 'display': 'Corriente **** 5432'},
  ];
  // --- Fin Datos de Ejemplo ---

  // Formateador de moneda
  final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);


  @override
  void dispose() {
    _referenceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // --- Lógica de Pago (Placeholder) ---
  Future<void> _processPayment() async {
     if (!_formKey.currentState!.validate()) {
      return; // No procesar si el formulario no es válido
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String serviceId = _selectedService!;
    final String reference = _referenceController.text;
    // Parsear monto asegurándose de manejar formato local
    final double? amount = double.tryParse(_amountController.text.replaceAll('.', '').replaceAll(',', '.'));
    final String accountId = _selectedSourceAccount!;

    // Validar monto parseado (ya debería estar validado por el form, pero doble check)
    if (amount == null) {
       setState(() {
          _errorMessage = 'Monto inválido.';
          _isLoading = false;
       });
       return;
    }


    print('--- Iniciando Pago Servicio Público ---');
    print('Servicio ID: $serviceId');
    print('Referencia: $reference');
    print('Monto: $amount');
    print('Cuenta Origen: $accountId');

    // --- Simular llamada a API/Pasarela de Pagos de Servicios ---
    // Aquí iría la integración real con el proveedor de pagos (PSE, etc.)
    // Esta llamada enviaría los datos (servicio, referencia, monto, cuenta)
    // y esperaría una confirmación.
    await Future.delayed(const Duration(seconds: 3));
    // --- Fin Simulación ---

    // --- Manejar Respuesta (Simulado) ---
    bool paymentSuccessful = true; // Simular éxito
    String responseMessage = '';

    if (paymentSuccessful) {
       responseMessage = '¡Pago del servicio realizado con éxito!';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseMessage),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Regresar si fue exitoso
        }
    } else {
       responseMessage = 'Error al procesar el pago del servicio. Intenta de nuevo.';
        if (mounted) { // Verificar si el widget sigue montado antes de llamar a setState
           setState(() {
             _errorMessage = responseMessage;
           });
        }
    }
    // --- Fin Manejo Respuesta ---

     if (mounted) {
        setState(() => _isLoading = false);
     }
  }
  // --- Fin Lógica de Pago ---


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
       appBar: AppBar(
        title: const Text('Pago de Servicios'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selecciona el servicio a pagar:', style: textTheme.titleMedium),
              const SizedBox(height: kDefaultPadding / 2),
              // Dropdown para seleccionar el servicio
              DropdownButtonFormField<String>(
                 value: _selectedService,
                 hint: const Text('Elige un servicio'),
                 isExpanded: true, // Para que el texto no se corte
                 items: _services.map((service) {
                   return DropdownMenuItem<String>(
                     value: service['id'] as String,
                     child: Row( // Mostrar icono y nombre
                       children: [
                         Icon(service['icon'] as IconData? ?? Icons.receipt_long, size: 20, color: theme.colorScheme.secondary),
                         const SizedBox(width: kDefaultPadding / 2),
                         Expanded(child: Text(service['name'] as String, overflow: TextOverflow.ellipsis)),
                       ],
                     ),
                   );
                 }).toList(),
                 onChanged: (value) => setState(() => _selectedService = value),
                 validator: (value) => value == null ? 'Selecciona un servicio' : null,
                 decoration: const InputDecoration(
                   border: OutlineInputBorder(),
                   contentPadding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.8),
                 ),
              ),
              const SizedBox(height: kDefaultPadding * 1.5),

              Text('Número de Factura o Referencia:', style: textTheme.titleMedium),
              const SizedBox(height: kDefaultPadding / 2),
              // Campo para la referencia
              TextFormField(
                controller: _referenceController,
                decoration: const InputDecoration(
                  labelText: 'Referencia de pago',
                  hintText: 'Ingresa el número de la factura',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text, // Puede ser alfanumérico
                // Podrías añadir inputFormatters si hay un formato específico
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la referencia';
                  }
                  // Puedes añadir validaciones de longitud o formato aquí si es necesario
                  return null;
                },
              ),
              const SizedBox(height: kDefaultPadding * 1.5),

              Text('Monto a Pagar:', style: textTheme.titleMedium),
              const SizedBox(height: kDefaultPadding / 2),
              // Campo para el monto
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Monto exacto (\$)',
                  hintText: 'Ej: 55000', // Sin puntos
                  border: OutlineInputBorder(),
                   prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                   FilteringTextInputFormatter.digitsOnly // Solo permitir dígitos
                ],
                validator: (value) {
                   if (value == null || value.isEmpty) {
                    return 'Ingresa el monto a pagar';
                  }
                   final amount = double.tryParse(value);
                   if (amount == null || amount <= 0) {
                     return 'Monto inválido';
                   }
                   // Podrías añadir validación contra saldo de cuenta origen aquí si lo cargas
                  return null;
                },
              ),
              const SizedBox(height: kDefaultPadding * 1.5),

              Text('Pagar desde:', style: textTheme.titleMedium),
              const SizedBox(height: kDefaultPadding / 2),
              // Dropdown para la cuenta de origen
              DropdownButtonFormField<String>(
                value: _selectedSourceAccount,
                hint: const Text('Selecciona una cuenta'),
                items: _sourceAccounts.map((account) {
                  return DropdownMenuItem<String>(
                    value: account['id'],
                    child: Text(account['display']!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedSourceAccount = value),
                validator: (value) => value == null ? 'Selecciona una cuenta de origen' : null,
                 decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.8),
                ),
              ),
              const SizedBox(height: kDefaultPadding * 2),

              // --- Mensaje de Error ---
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: kDefaultPadding),
                  child: Text(
                    _errorMessage!,
                    style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),

               // --- Botón de Pagar ---
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.payment_outlined),
                        label: const Text('Pagar Servicio'),
                         style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2, vertical: kDefaultPadding),
                          textStyle: textTheme.titleMedium,
                        ),
                        // Deshabilitar si falta alguna selección
                        onPressed: (_selectedService == null || _selectedSourceAccount == null || _isLoading)
                                ? null
                                : _processPayment,
                      ),
              ),
            ],
          ),
        )
      )
    );
  }
}
