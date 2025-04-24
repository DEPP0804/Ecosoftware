import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para InputFormatters
import 'package:ecosoftware/styles/app_styles.dart'; // Para kDefaultPadding

class CreditCardPaymentPage extends StatefulWidget {
  const CreditCardPaymentPage({Key? key}) : super(key: key);

  @override
  State<CreditCardPaymentPage> createState() => _CreditCardPaymentPageState();
}

class _CreditCardPaymentPageState extends State<CreditCardPaymentPage> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario

  // --- Controladores y Variables de Estado ---
  String? _selectedCreditCard; // Guardará la tarjeta seleccionada
  String? _selectedSourceAccount; // Guardará la cuenta de origen
  String _paymentType = 'total'; // Opciones: 'total', 'minimo', 'otro'
  final _amountController = TextEditingController(); // Para el monto personalizado
  bool _isLoading = false; // Para mostrar indicador de carga
  String? _errorMessage; // Para mostrar errores

  // --- Datos de Ejemplo (Reemplazar con datos reales de Firestore/API) ---
  final List<Map<String, String>> _creditCards = [
    {'id': 'cc1', 'display': 'Visa **** 1234'},
    {'id': 'cc2', 'display': 'Mastercard **** 5678'},
  ];

  final List<Map<String, String>> _sourceAccounts = [
    {'id': 'sa1', 'display': 'Ahorros **** 9876'},
    {'id': 'sa2', 'display': 'Corriente **** 5432'},
  ];
  // --- Fin Datos de Ejemplo ---

  @override
  void dispose() {
    _amountController.dispose(); // Limpiar el controlador
    super.dispose();
  }

  // --- Lógica de Pago (Placeholder) ---
  Future<void> _processPayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Limpiar errores previos
    });

    // 1. Validar Formulario
    if (!_formKey.currentState!.validate()) {
      setState(() => _isLoading = false);
      return; // Detener si hay errores de validación
    }

    // 2. Obtener los datos del formulario
    final String cardId = _selectedCreditCard!;
    final String accountId = _selectedSourceAccount!;
    final String paymentType = _paymentType;
    double amount = 0;

    if (paymentType == 'otro') {
      amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    } else if (paymentType == 'total') {
      // TODO: Obtener el saldo total real de la tarjeta seleccionada (cardId)
      amount = 500000.0; // Ejemplo
    } else if (paymentType == 'minimo') {
      // TODO: Obtener el pago mínimo real de la tarjeta seleccionada (cardId)
      amount = 50000.0; // Ejemplo
    }

    print('--- Iniciando Pago TDC ---');
    print('Tarjeta: $cardId');
    print('Cuenta Origen: $accountId');
    print('Tipo Pago: $paymentType');
    print('Monto: $amount');

    // 3. Simular llamada a API/Backend
    //    Aquí iría la llamada a Firebase Functions o tu API para procesar el pago real.
    //    Esta llamada debería verificar fondos, realizar la transacción, etc.
    await Future.delayed(const Duration(seconds: 3)); // Simular espera

    // 4. Manejar Respuesta (Simulado)
    bool paymentSuccessful = true; // Simular éxito/fracaso
    String responseMessage = '';

    if (paymentSuccessful) {
      responseMessage = '¡Pago realizado con éxito!';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseMessage),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Regresar a la pantalla anterior si fue exitoso
      }
    } else {
      responseMessage = 'Error al procesar el pago. Intenta de nuevo.';
      setState(() {
        _errorMessage = responseMessage;
      });
    }

    setState(() => _isLoading = false);
  }
  // --- Fin Lógica de Pago ---


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago Tarjeta de Crédito'),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Para evitar overflow si el teclado aparece
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selecciona la tarjeta a pagar:', style: textTheme.titleMedium),
              const SizedBox(height: kDefaultPadding / 2),
              DropdownButtonFormField<String>(
                value: _selectedCreditCard,
                hint: const Text('Elige una tarjeta'),
                items: _creditCards.map((card) {
                  return DropdownMenuItem<String>(
                    value: card['id'],
                    child: Text(card['display']!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCreditCard = value),
                validator: (value) => value == null ? 'Selecciona una tarjeta' : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.8),
                ),
              ),
              const SizedBox(height: kDefaultPadding * 1.5),

              Text('Selecciona la cuenta de origen:', style: textTheme.titleMedium),
              const SizedBox(height: kDefaultPadding / 2),
              DropdownButtonFormField<String>(
                value: _selectedSourceAccount,
                hint: const Text('Elige una cuenta'),
                items: _sourceAccounts.map((account) {
                  return DropdownMenuItem<String>(
                    value: account['id'],
                    child: Text(account['display']!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedSourceAccount = value),
                validator: (value) => value == null ? 'Selecciona una cuenta' : null,
                 decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.8),
                ),
              ),
              const SizedBox(height: kDefaultPadding * 1.5),

              Text('Monto a pagar:', style: textTheme.titleMedium),
              const SizedBox(height: kDefaultPadding / 2),
              // Opciones de Monto (Radio Buttons)
              RadioListTile<String>(
                title: const Text('Pago Total'),
                // TODO: Mostrar aquí el monto total real si se tiene
                // subtitle: Text('\$ XXXX.XX'),
                value: 'total',
                groupValue: _paymentType,
                onChanged: (value) => setState(() => _paymentType = value!),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<String>(
                title: const Text('Pago Mínimo'),
                // TODO: Mostrar aquí el monto mínimo real si se tiene
                // subtitle: Text('\$ YYYY.YY'),
                value: 'minimo',
                groupValue: _paymentType,
                onChanged: (value) => setState(() => _paymentType = value!),
                 contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<String>(
                title: const Text('Otro Monto'),
                value: 'otro',
                groupValue: _paymentType,
                onChanged: (value) => setState(() => _paymentType = value!),
                 contentPadding: EdgeInsets.zero,
              ),

              // Campo de texto para "Otro Monto" (aparece condicionalmente)
              if (_paymentType == 'otro')
                Padding(
                  padding: const EdgeInsets.only(top: kDefaultPadding / 2, left: kDefaultPadding),
                  child: TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Ingresa el monto',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      // Permite números y un solo punto decimal
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un monto';
                      }
                      final amount = double.tryParse(value.replaceAll(',', ''));
                      if (amount == null || amount <= 0) {
                        return 'Ingresa un monto válido';
                      }
                      // TODO: Añadir validación opcional (ej: no exceder saldo de cuenta origen)
                      return null;
                    },
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

              // --- Botón de Pago ---
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator() // Muestra carga
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.payment_outlined),
                        label: const Text('Realizar Pago'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2, vertical: kDefaultPadding),
                          textStyle: textTheme.titleMedium,
                        ),
                        onPressed: (_selectedCreditCard == null || _selectedSourceAccount == null)
                                ? null // Deshabilitar si no se ha seleccionado tarjeta o cuenta
                                : _processPayment, // Llama a la función de pago
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}