import 'dart:math'; // Necesario para la función pow()
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Asegúrate que la ruta a tus estilos sea correcta
import 'package:ecosoftware/styles/app_styles.dart';
// Paquete para gráficos (asegúrate de tenerlo en pubspec.yaml)
import 'package:fl_chart/fl_chart.dart';
// Paquete para formatear números y moneda (asegúrate de tenerlo en pubspec.yaml)
import 'package:intl/intl.dart';
// --- IMPORTACIONES DE FIREBASE ---
// Necesarias para guardar el crédito aceptado
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Clase para representar una entrada en la tabla de amortización
// Ayuda a organizar los datos de cada mes del crédito.
class AmortizationEntry {
  final int month; // Número del mes (1, 2, 3...)
  final double interestPaid; // Interés pagado en este mes
  final double principalPaid; // Capital pagado en este mes
  final double installmentAmount; // Cuota total pagada este mes (capital + interés)
  final double endingBalance; // Saldo restante al final de este mes

  AmortizationEntry({
    required this.month,
    required this.interestPaid,
    required this.principalPaid,
    required this.installmentAmount,
    required this.endingBalance,
  });
}


// Widget principal de la página de simulación
class LoanSimulationPage extends StatefulWidget {
  const LoanSimulationPage({Key? key}) : super(key: key);

  @override
  State<LoanSimulationPage> createState() => _LoanSimulationPageState();
}

// Estado del widget LoanSimulationPage
class _LoanSimulationPageState extends State<LoanSimulationPage> {
  // Clave global para manejar el estado y validación del formulario
  final _formKey = GlobalKey<FormState>();

  // --- Controladores para los campos de texto del formulario ---
  final _amountController = TextEditingController(); // Para el monto del crédito
  final _termController = TextEditingController();   // Para el plazo en meses
  final _rateController = TextEditingController();   // Para la tasa de interés % E.A.

  // --- Variables para almacenar los resultados de la simulación ---
  double? _originalAmount;       // Monto original solicitado
  double? _monthlyInstallment; // Cuota mensual calculada (capital + interés)
  double? _totalInterest;        // Intereses totales a pagar durante el crédito
  double? _totalRepayment;       // Pago total (monto original + intereses totales)
  List<AmortizationEntry> _amortizationSchedule = []; // Lista para guardar la tabla de amortización detallada

  // --- Variables de estado para la interfaz de usuario ---
  bool _isLoading = false; // Indica si se está calculando la simulación
  bool _isSaving = false;  // Indica si se está guardando el crédito aceptado
  String? _errorMessage;   // Mensaje de error para mostrar al usuario

  // --- Formateadores de moneda (usando el paquete intl) ---
  // Para mostrar valores sin decimales (ej. totales, saldos grandes)
  final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
  // Para mostrar valores con 2 decimales (ej. cuotas, intereses)
  final currencyFormatterWithDecimals = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 2);


  // Método que se llama cuando el widget se elimina del árbol de widgets.
  // Es importante limpiar los controladores para liberar memoria.
  @override
  void dispose() {
    _amountController.dispose();
    _termController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  /// Calcula la simulación del crédito basado en los datos ingresados
  /// y genera la tabla de amortización detallada.
  void _calculateSimulation() {
    // 1. Validar el formulario: si no es válido, no hacer nada.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Actualizar estado: Indicar que inicia la carga y limpiar resultados anteriores.
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _originalAmount = null;
      _monthlyInstallment = null;
      _totalInterest = null;
      _totalRepayment = null;
      _amortizationSchedule = []; // Limpiar la tabla anterior
    });

    // 3. Obtener y parsear valores de los controladores.
    // Se reemplazan separadores para asegurar el formato numérico correcto.
    final double? amount = double.tryParse(_amountController.text.replaceAll('.', '').replaceAll(',', '.'));
    final int? termMonths = int.tryParse(_termController.text);
    final double? annualRatePercent = double.tryParse(_rateController.text.replaceAll(',', '.'));

    // 4. Validar que los valores parseados sean números válidos y positivos.
    if (amount == null || termMonths == null || annualRatePercent == null || amount <= 0 || termMonths <= 0 || annualRatePercent <= 0) {
      setState(() {
        _errorMessage = 'Ingresa valores válidos y positivos.';
        _isLoading = false; // Detener la carga
      });
      return; // Salir de la función si los datos no son válidos
    }

    // 5. Guardar el monto original para usarlo después (ej. en gráficos).
    _originalAmount = amount;

    // 6. Realizar Cálculos Financieros
    // Convertir tasa % Efectiva Anual (E.A.) a tasa decimal periódica mensual.
    // Fórmula: i_mensual = (1 + Tasa_E.A.)^(1/12) - 1
    double effectiveAnnualRateDecimal = annualRatePercent / 100.0;
    double monthlyRate = pow(1 + effectiveAnnualRateDecimal, 1/12.0) - 1;

    double currentBalance = amount; // El saldo inicial es el monto solicitado.
    double calculatedInstallment;   // Variable para la cuota mensual.
    double totalInterestPaid = 0;   // Acumulador para los intereses totales.
    List<AmortizationEntry> schedule = []; // Lista temporal para construir la tabla.

    try {
      // Calcular la cuota fija usando la fórmula de anualidad.
      // Cuota = P * [i * (1 + i)^n] / [(1 + i)^n – 1]
      double numerator = amount * monthlyRate * pow(1 + monthlyRate, termMonths);
      double denominator = pow(1 + monthlyRate, termMonths) - 1;

      // Manejar el caso de tasa 0% (denominador sería 0).
      if (denominator.abs() < 1e-9) { // Usar valor pequeño para comparación de flotantes
        calculatedInstallment = amount / termMonths; // Cuota simple sin intereses.
      } else {
        calculatedInstallment = numerator / denominator;
      }
      // Guardar la cuota base calculada en el estado.
      _monthlyInstallment = calculatedInstallment;

      // --- Generar Tabla de Amortización mes a mes ---
      for (int i = 1; i <= termMonths; i++) {
        // Calcular interés y capital para la cuota del mes 'i'.
        double interestForMonth = currentBalance * monthlyRate;
        double principalForMonth = calculatedInstallment - interestForMonth;

        // Ajustar la última cuota para que salde exactamente el crédito.
        // Esto corrige pequeñas diferencias por redondeo.
        if (i == termMonths) {
          principalForMonth = currentBalance; // El último pago de capital es el saldo restante.
          calculatedInstallment = principalForMonth + interestForMonth; // Recalcular la cuota final.
        }

        // Actualizar el saldo y sumar los intereses pagados.
        currentBalance -= principalForMonth;
        totalInterestPaid += interestForMonth;

        // Asegurar que el saldo final sea exactamente 0.0.
        double finalBalance = (i == termMonths) ? 0.0 : currentBalance;
        if (finalBalance.abs() < 0.01) finalBalance = 0.0; // Corregir residuos muy pequeños.

        // Añadir la información del mes a la lista temporal 'schedule'.
        schedule.add(AmortizationEntry(
          month: i,
          interestPaid: interestForMonth,
          principalPaid: principalForMonth,
          installmentAmount: calculatedInstallment, // Usar la cuota (posiblemente ajustada).
          endingBalance: finalBalance,
        ));
      }
      // --- Fin Generación Tabla ---

      // 7. Guardar la tabla completa y los totales calculados en el estado.
      _amortizationSchedule = schedule;
      _totalRepayment = amount + totalInterestPaid; // Pago total = Capital + Intereses.
      _totalInterest = totalInterestPaid;

    } catch (e) {
      // 8. Manejar errores que puedan ocurrir durante el cálculo.
      print("Error en cálculo: $e");
      _errorMessage = "Error al calcular. Verifica los valores.";
      _isLoading = false; // Detener la carga si hay error.
    }

    // 9. Actualizar estado final (detener carga) solo si el widget aún existe.
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Guarda los datos del crédito simulado y aceptado en Firestore
  /// para el usuario actualmente autenticado.
  Future<void> _acceptLoan() async {
    // 1. Verificar si hay resultados válidos de la simulación para guardar.
    if (_originalAmount == null || _monthlyInstallment == null || _termController.text.isEmpty || _rateController.text.isEmpty) {
      // Mostrar mensaje si no se ha simulado nada válido.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero simula un crédito válido.'), backgroundColor: Colors.orange),
      );
      return;
    }

    // 2. Obtener el usuario actual de Firebase Auth.
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Mostrar error si no hay usuario autenticado.
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Usuario no autenticado.'), backgroundColor: Colors.red),
      );
      return;
    }
    final userId = user.uid; // Obtener el ID único del usuario.

    // 3. Indicar que se está iniciando el proceso de guardado.
    setState(() => _isSaving = true);

    try {
      // 4. Preparar los datos del crédito en un mapa.
      final loanData = {
        'originalAmount': _originalAmount, // Monto original
        'termMonths': int.tryParse(_termController.text), // Plazo en meses
        'annualRatePercent': double.tryParse(_rateController.text.replaceAll(',', '.')), // Tasa % E.A.
        'monthlyInstallment': _monthlyInstallment, // Cuota mensual calculada
        'acceptedDate': Timestamp.now(), // Fecha y hora actual de aceptación
        'status': 'active', // Estado inicial del crédito (ej. 'active', 'paid')
        // Puedes añadir más campos relevantes aquí:
        'loanType': 'Libre Inversión (Simulado)' // Tipo de crédito
      };

      // 5. Obtener la referencia a la subcolección 'loans' dentro del documento del usuario.
      // Estructura: /users/{userId}/loans/{loanId}
      final userLoansCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('loans');

      // 6. Añadir un nuevo documento a la subcolección 'loans' con los datos preparados.
      // Firestore generará un ID único para este nuevo préstamo.
      await userLoansCollection.add(loanData);

      // 7. Si el guardado fue exitoso y el widget aún existe:
       if (mounted) {
          // Mostrar mensaje de confirmación.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Crédito aceptado y guardado!'), backgroundColor: Colors.green),
          );
          // Regresar a la pantalla anterior (probablemente HomePage).
          Navigator.of(context).pop();
       }

    } catch (e) {
      // 8. Manejar errores durante el guardado en Firestore.
      print("Error al guardar el crédito: $e");
       if (mounted) {
          // Mostrar mensaje de error detallado.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar el crédito: ${e.toString()}'), backgroundColor: Colors.red),
          );
       }
    } finally {
      // 9. Asegurarse de detener la indicación de guardado, incluso si hubo error.
       if (mounted) {
          setState(() => _isSaving = false);
       }
    }
  }


  // Método principal que construye la interfaz de usuario de la página.
  @override
  Widget build(BuildContext context) {
    // Obtener tema y estilos de texto actuales.
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Agrupar la tabla de amortización por año para mostrarla en ExpansionTiles.
    Map<int, List<AmortizationEntry>> groupedSchedule = {};
    for (var entry in _amortizationSchedule) {
      int year = ((entry.month - 1) / 12).floor() + 1;
      if (!groupedSchedule.containsKey(year)) {
        groupedSchedule[year] = [];
      }
      groupedSchedule[year]!.add(entry);
    }

    // Construir la estructura principal de la página (Scaffold).
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulación de Créditos'),
        centerTitle: true,
      ),
      // Usar SingleChildScrollView para permitir scroll si el contenido es largo.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding), // Padding general
        child: Form(
          key: _formKey, // Asociar la clave al Form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Estirar hijos horizontalmente
            children: [
              // --- Sección de Inputs (Campos de texto y botón Calcular) ---
              // (Código de los TextFormField y ElevatedButton 'Simular Crédito' igual que antes)
              Text('Ingresa los datos del crédito:', style: textTheme.titleLarge),
              const SizedBox(height: kDefaultPadding * 1.5),
              TextFormField(controller: _amountController, decoration: const InputDecoration(labelText: 'Monto del Crédito (\$)', hintText: 'Ej: 10000000', border: OutlineInputBorder(), prefixText: '\$ '), keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => (v == null || v.isEmpty || double.tryParse(v) == null || double.parse(v) <= 0) ? 'Monto inválido' : null),
              const SizedBox(height: kDefaultPadding),
              TextFormField(controller: _termController, decoration: const InputDecoration(labelText: 'Plazo (Meses)', hintText: 'Ej: 36', border: OutlineInputBorder()), keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => (v == null || v.isEmpty || int.tryParse(v) == null || int.parse(v) <= 0) ? 'Plazo inválido' : null),
              const SizedBox(height: kDefaultPadding),
              TextFormField(controller: _rateController, decoration: const InputDecoration(labelText: 'Tasa Interés (% E.A.)', hintText: 'Ej: 18,5', border: OutlineInputBorder(), suffixText: '%'), keyboardType: TextInputType.numberWithOptions(decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+([.,]?\d{0,2})?$'))], validator: (v) => (v == null || v.isEmpty || double.tryParse(v.replaceAll(',', '.')) == null || double.parse(v.replaceAll(',', '.')) <= 0) ? 'Tasa inválida' : null),
              const SizedBox(height: kDefaultPadding * 1.5),
              ElevatedButton.icon(
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Simular Crédito'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 0.8), textStyle: textTheme.titleMedium),
                  // Deshabilitar si está calculando o guardando
                  onPressed: _isLoading || _isSaving ? null : _calculateSimulation,
              ),
              const SizedBox(height: kDefaultPadding),

              // --- Indicador de Carga y Mensajes de Error ---
              // Mostrar CircularProgressIndicator si _isLoading es true.
              if (_isLoading) const Center(child: Padding(padding: EdgeInsets.all(kDefaultPadding), child: CircularProgressIndicator())),
              // Mostrar mensaje de error si _errorMessage no es nulo.
              if (_errorMessage != null) Padding(padding: const EdgeInsets.symmetric(vertical: kDefaultPadding), child: Text(_errorMessage!, style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error), textAlign: TextAlign.center)),

              // --- Sección de Resultados (Mostrar solo si no hay carga y hay resultados) ---
              if (!_isLoading && _amortizationSchedule.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinear hijos a la izquierda
                  children: [
                    // --- Card con el Resumen de la Simulación ---
                    Card(
                      margin: const EdgeInsets.only(top: kDefaultPadding, bottom: kDefaultPadding),
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
                      child: Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Resumen de la Simulación:', style: textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
                            const SizedBox(height: kDefaultPadding),
                            // Mostrar filas con los resultados principales usando el helper
                            _buildResultRow(context, 'Cuota Mensual Aprox:', _monthlyInstallment),
                            const Divider(height: kDefaultPadding * 1.5, thickness: 0.5),
                            _buildResultRow(context, 'Total Intereses Aprox:', _totalInterest),
                            const Divider(height: kDefaultPadding * 1.5, thickness: 0.5),
                            _buildResultRow(context, 'Pago Total Aprox:', _totalRepayment),
                          ]
                        )
                      )
                    ),

                    // --- Gráfico de Línea (Evolución del Saldo) ---
                    Text('Evolución del Saldo:', style: textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
                    const SizedBox(height: kDefaultPadding),
                    // Contenedor con altura fija para el gráfico
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        _buildLineChartData(), // Llama al helper que configura el gráfico
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding * 1.5),

                    // --- Plan de Pagos Detallado (Expandible por Año) ---
                    Text('Plan de Pagos Detallado:', style: textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
                    const SizedBox(height: kDefaultPadding / 2),
                    // ListView para mostrar las secciones expandibles de cada año
                    ListView.builder(
                      shrinkWrap: true, // Necesario dentro de SingleChildScrollView
                      physics: const NeverScrollableScrollPhysics(), // Deshabilitar scroll propio
                      itemCount: groupedSchedule.keys.length, // Número de años
                      itemBuilder: (context, index) {
                        int year = groupedSchedule.keys.elementAt(index);
                        List<AmortizationEntry> yearEntries = groupedSchedule[year]!;
                        // Card para cada año con ExpansionTile
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding/4),
                            title: Text('Año $year', style: textTheme.titleMedium), // Título del año
                            childrenPadding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
                            // Hijos: la tabla de detalles para ese año
                            children: [
                              _buildYearDetailTable(context, yearEntries) // Llama al helper de la tabla
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: kDefaultPadding * 1.5), // Espacio antes del botón Aceptar

                    // --- BOTÓN ACEPTAR CRÉDITO ---
                    // Centrar el botón
                    Center(
                      child: ElevatedButton.icon(
                        // Mostrar indicador de carga si se está guardando
                        icon: _isSaving
                            ? Container(
                                width: 18, height: 18, // Tamaño del indicador
                                child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.onPrimary),
                              )
                            : const Icon(Icons.check_circle_outline), // Icono normal
                        label: Text(_isSaving ? 'Guardando...' : 'Aceptar Crédito'), // Texto dinámico
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2, vertical: kDefaultPadding),
                          backgroundColor: Colors.green[700], // Color verde para Aceptar
                          foregroundColor: Colors.white, // Texto blanco
                          textStyle: textTheme.titleMedium?.copyWith(color: Colors.white),
                        ),
                        // Deshabilitar botón si se está guardando, y llamar a _acceptLoan al presionar
                        onPressed: _isSaving ? null : _acceptLoan,
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding), // Espacio después del botón

                    // --- Nota Aclaratoria ---
                    Text(
                      '*Valores aproximados calculados con tasa Efectiva Anual (${_rateController.text}% E.A.) y sistema de cuota fija. La cuota real puede variar según condiciones finales del crédito, seguros asociados y redondeos de la entidad.',
                      style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye la tabla de detalles de amortización para un año específico.
  Widget _buildYearDetailTable(BuildContext context, List<AmortizationEntry> entries) {
    // (Sin cambios respecto a la versión anterior)
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    TextStyle headerStyle = textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.8));
    TextStyle cellStyle = textTheme.bodySmall!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding/2),
      child: Table(
        columnWidths: const { 0: IntrinsicColumnWidth(), 1: FlexColumnWidth(1.5), 2: FlexColumnWidth(1.3), 3: FlexColumnWidth(1.3), 4: FlexColumnWidth(1.8) },
        border: TableBorder( horizontalInside: BorderSide(width: 0.5, color: theme.dividerColor.withOpacity(0.5))),
        children: [
          TableRow(
            decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant.withOpacity(0.3)),
            children: [
              Padding(padding: const EdgeInsets.all(kDefaultPadding / 3), child: Text('Mes', style: headerStyle, textAlign: TextAlign.center)),
              Padding(padding: const EdgeInsets.all(kDefaultPadding / 3), child: Text('Cuota', style: headerStyle, textAlign: TextAlign.right)),
              Padding(padding: const EdgeInsets.all(kDefaultPadding / 3), child: Text('Interés', style: headerStyle, textAlign: TextAlign.right)),
              Padding(padding: const EdgeInsets.all(kDefaultPadding / 3), child: Text('Capital', style: headerStyle, textAlign: TextAlign.right)),
              Padding(padding: const EdgeInsets.all(kDefaultPadding / 3), child: Text('Saldo', style: headerStyle, textAlign: TextAlign.right)),
            ],
          ),
          ...entries.map((entry) {
            return TableRow(
              children: [
                Padding(padding: const EdgeInsets.all(kDefaultPadding / 3), child: Text(entry.month.toString(), style: cellStyle, textAlign: TextAlign.center)),
                Padding(padding: const EdgeInsets.all(kDefaultPadding / 3), child: Text(currencyFormatterWithDecimals.format(entry.installmentAmount), style: cellStyle, textAlign: TextAlign.right)),
                Padding(padding: const EdgeInsets.all(kDefaultPadding / 3), child: Text(currencyFormatterWithDecimals.format(entry.interestPaid), style: cellStyle, textAlign: TextAlign.right)),
                Padding(padding: const EdgeInsets.all(kDefaultPadding / 3), child: Text(currencyFormatterWithDecimals.format(entry.principalPaid), style: cellStyle, textAlign: TextAlign.right)),
                Padding(padding: const EdgeInsets.all(kDefaultPadding / 3), child: Text(currencyFormatter.format(entry.endingBalance), style: cellStyle, textAlign: TextAlign.right)),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Construye los datos y configuración para el gráfico de línea [LineChart].
  LineChartData _buildLineChartData() {
    // (Sin cambios respecto a la versión anterior con las correcciones)
    List<FlSpot> spots = [];
    spots.add(FlSpot(0, _originalAmount ?? 0));
    for (var entry in _amortizationSchedule) {
      spots.add(FlSpot(entry.month.toDouble(), entry.endingBalance));
    }
    double minY = 0;
    double maxY = (_originalAmount ?? 0) * 1.1;
    double maxX = (_amortizationSchedule.isNotEmpty) ? _amortizationSchedule.last.month.toDouble() : 1.0;

    return LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: maxY / 4, verticalInterval: (maxX / 6).ceil().toDouble(), getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 0.5), getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 0.5)),
      titlesData: FlTitlesData(show: true, rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: (maxX / 6).ceil().toDouble(), getTitlesWidget: (value, meta) { if (value == 0) return const SizedBox.shrink(); return SideTitleWidget(axisSide: meta.axisSide, space: 8.0, child: Text(value.toInt().toString(), style: const TextStyle(color: Colors.black54, fontSize: 10))); },)), leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 60, getTitlesWidget: (value, meta) { if (value == meta.min || value == meta.max || value % (maxY / 4) < 1) { if (value == 0 && meta.max < 10000) return const SizedBox.shrink(); return SideTitleWidget( axisSide: meta.axisSide, space: 8.0, child: Text(_formatAxisValue(value), style: const TextStyle(color: Colors.black54, fontSize: 10) )); } return const SizedBox.shrink(); },))),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1)),
      minX: 0, maxX: maxX, minY: minY, maxY: maxY,
      lineBarsData: [ LineChartBarData(spots: spots, isCurved: true, color: Theme.of(context).colorScheme.primary, barWidth: 3, isStrokeCapRound: true, dotData: const FlDotData(show: false), belowBarData: BarAreaData(show: true, color: Theme.of(context).colorScheme.primary.withOpacity(0.1))) ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (LineBarSpot spot) => Colors.blueGrey.withOpacity(0.8), // Corrección aplicada
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final double monthX = barSpot.x; // Corrección aplicada
              if (monthX == 0) return null;
              int index = monthX.toInt() - 1;
              if (index < 0 || index >= _amortizationSchedule.length) return null;
              AmortizationEntry entry = _amortizationSchedule[index];
              return LineTooltipItem('Mes ${monthX.toInt()}\n', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), children: [ TextSpan(text: currencyFormatter.format(entry.endingBalance), style: TextStyle(color: Colors.grey[100], fontWeight: FontWeight.w900, fontSize: 11)) ], textAlign: TextAlign.center);
            }).where((tooltip) => tooltip != null).toList();
          }
        ),
        handleBuiltInTouches: true,
        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            if (barData.spots[index].x == 0) { return TouchedSpotIndicatorData(FlLine(color: Colors.transparent), FlDotData(show: false)); } // Corrección aplicada (acceso a x)
            return TouchedSpotIndicatorData( FlLine(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), strokeWidth: 1), FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 5, color: Theme.of(context).colorScheme.primary, strokeWidth: 1, strokeColor: Colors.white)));
          }).toList();
        },
      ),
    );
  }

  /// Formatea un valor numérico grande a una cadena corta (ej: 1M, 500K).
  String _formatAxisValue(double value) {
    // (Sin cambios respecto a la versión anterior)
    if (value >= 1000000) { return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M'; } else if (value >= 1000) { return '${(value / 1000).toStringAsFixed(0)}K'; } return value.toStringAsFixed(0);
  }


  /// Construye una fila para mostrar un resultado (label y valor formateado).
  Widget _buildResultRow(BuildContext context, String label, double? value) {
    // (Sin cambios respecto a la versión anterior)
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final formatter = label.contains('Cuota') ? currencyFormatterWithDecimals : currencyFormatter;
    String formattedValue = (value == null) ? '-' : formatter.format(value);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(label, style: textTheme.bodyLarge)),
          const SizedBox(width: kDefaultPadding),
          Expanded(flex: 3, child: Text(formattedValue, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

} // Fin _LoanSimulationPageState
