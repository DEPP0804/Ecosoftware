import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para InputFormatters
import 'package:ecosoftware/styles/app_styles.dart'; // Para kDefaultPadding

class MobileRechargePage extends StatefulWidget {
  const MobileRechargePage({Key? key}) : super(key: key);

  @override
  State<MobileRechargePage> createState() => _MobileRechargePageState();
}

class _MobileRechargePageState extends State<MobileRechargePage> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario

  // --- Controladores y Variables de Estado ---
  String? _selectedOperator; // Operador seleccionado
  final _phoneNumberController = TextEditingController(); // Número de celular
  double? _selectedAmount; // Monto predefinido seleccionado
  final _customAmountController = TextEditingController(); // Para monto personalizado (opcional)
  String? _selectedSourceAccount; // Cuenta de origen
  bool _isLoading = false;
  String? _errorMessage;

  // --- Datos de Ejemplo (Reemplazar con datos reales/API) ---
  // Lista de operadores comunes en Colombia (puedes ajustarla)
  final List<String> _operators = [
    'Claro', 'Movistar', 'Tigo', 'Wom', 'Virgin Mobile', 'ETB', 'Móvil Éxito'
  ];

  // Montos comunes de recarga
  final List<double> _rechargeAmounts = [
     3000, 5000, 10000, 15000, 20000, 30000, 50000
  ];

  // Cuentas de origen (igual que en pago TDC para el ejemplo)
   final List<Map<String, String>> _sourceAccounts = [
    {'id': 'sa1', 'display': 'Ahorros **** 9876'},
    {'id': 'sa2', 'display': 'Corriente **** 5432'},
  ];
  // --- Fin Datos de Ejemplo ---

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _customAmountController.dispose();
    super.dispose();
  }

  // --- Lógica de Recarga (Placeholder) ---
  Future<void> _processRecharge() async {
     if (!_formKey.currentState!.validate()) {
      return; // Detener si hay errores de validación
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String operator = _selectedOperator!;
    final String phoneNumber = _phoneNumberController.text;
    final double amount = _selectedAmount!; // Usaremos solo montos predefinidos por ahora
    final String accountId = _selectedSourceAccount!;

    print('--- Iniciando Recarga Celular ---');
    print('Operador: $operator');
    print('Número: $phoneNumber');
    print('Monto: $amount');
    print('Cuenta Origen: $accountId');

    // --- Simular llamada a API de Recargas ---
    // Aquí iría la integración real con un proveedor de recargas.
    await Future.delayed(const Duration(seconds: 3));
    // --- Fin Simulación ---

    // --- Manejar Respuesta (Simulado) ---
    bool rechargeSuccessful = true; // Simular éxito
    String responseMessage = '';

    if (rechargeSuccessful) {
       responseMessage = '¡Recarga realizada con éxito!';
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
       responseMessage = 'Error al procesar la recarga. Intenta de nuevo.';
        setState(() {
          _errorMessage = responseMessage;
        });
    }
    // --- Fin Manejo Respuesta ---

    setState(() => _isLoading = false);
  }
  // --- Fin Lógica de Recarga ---


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
       appBar: AppBar(
        title: const Text('Recargas Celular'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Operador:', style: textTheme.titleMedium),
              const SizedBox(height: kDefaultPadding / 2),
              DropdownButtonFormField<String>(
                 value: _selectedOperator,
                hint: const Text('Selecciona un operador'),
                items: _operators.map((operator) {
                  return DropdownMenuItem<String>(
                    value: operator,
                    child: Text(operator),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedOperator = value),
                validator: (value) => value == null ? 'Selecciona un operador' : null,
                 decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.8),
                ),
              ),
              const SizedBox(height: kDefaultPadding * 1.5),

              Text('Número de Celular:', style: textTheme.titleMedium),
              const SizedBox(height: kDefaultPadding / 2),
               TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número a recargar',
                  hintText: 'Ej: 3001234567',
                  prefixText: '+57 ', // Prefijo Colombia
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Solo números
                  LengthLimitingTextInputFormatter(10), // Máximo 10 dígitos
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el número de celular';
                  }
                  if (value.length != 10) {
                     return 'El número debe tener 10 dígitos';
                  }
                  // TODO: Podrías añadir validación de prefijo vs operador si es necesario
                  return null;
                },
              ),
              const SizedBox(height: kDefaultPadding * 1.5),

              Text('Monto de la Recarga:', style: textTheme.titleMedium),
              const SizedBox(height: kDefaultPadding / 2),
              // Usamos Dropdown para los montos predefinidos
               DropdownButtonFormField<double>(
                 value: _selectedAmount,
                hint: const Text('Selecciona un monto'),
                items: _rechargeAmounts.map((amount) {
                  // Formatear para mostrar (puedes usar intl para mejor formato)
                  String displayAmount = '\$ ${amount.toStringAsFixed(0).replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
                  return DropdownMenuItem<double>(
                    value: amount,
                    child: Text(displayAmount),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedAmount = value),
                validator: (value) => value == null ? 'Selecciona un monto' : null,
                 decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.8),
                ),
              ),
              // Alternativa: Usar ChoiceChips o Buttons si prefieres otro look
              /* Wrap( // Ejemplo con ChoiceChips (requiere más manejo de estado)
                spacing: kDefaultPadding / 2,
                children: _rechargeAmounts.map((amount) => ChoiceChip(
                  label: Text('\$${amount.toStringAsFixed(0)}'),
                  selected: _selectedAmount == amount,
                  onSelected: (selected) => setState(() => _selectedAmount = selected ? amount : null),
                )).toList(),
              ), */
              const SizedBox(height: kDefaultPadding * 1.5),

              Text('Cuenta de Origen:', style: textTheme.titleMedium),
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

               // --- Botón de Recarga ---
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.send_to_mobile),
                        label: const Text('Recargar Celular'),
                         style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2, vertical: kDefaultPadding),
                          textStyle: textTheme.titleMedium,
                        ),
                        onPressed: (_selectedOperator == null ||
                                    _selectedAmount == null ||
                                    _selectedSourceAccount == null)
                                ? null // Deshabilitar si falta algo
                                : _processRecharge,
                      ),
              ),
            ],
          ),
        )
      )
    );
  }
}