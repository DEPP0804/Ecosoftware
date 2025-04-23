import 'dart:math';
import 'package:flutter/material.dart';
// Asegúrate que kDefaultPadding y AppTheme estén en app_styles.dart
import 'package:ecosoftware/styles/app_styles.dart';

class AmortizacionPage extends StatefulWidget {
  const AmortizacionPage({Key? key}) : super(key: key);

  @override
  _AmortizacionPageState createState() => _AmortizacionPageState();
}

class _AmortizacionPageState extends State<AmortizacionPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistemas de Amortización'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Concepto General Card... (sin cambios)
            Card( /* ... */
               child: Padding(
                 padding: const EdgeInsets.all(kDefaultPadding),
                 child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text('Concepto General:', style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
                       const SizedBox(height: kDefaultPadding / 2),
                       Text(
                         'La amortización es el proceso de extinguir una deuda gradualmente mediante pagos periódicos, que generalmente cubren tanto los intereses generados como una parte del capital principal prestado.',
                         style: textTheme.bodyMedium,
                         textAlign: TextAlign.justify,
                       ),
                    ],
                 ),
               ),
             ),
            const SizedBox(height: kDefaultPadding),
            // ExpansionTiles para cada sistema... (sin cambios)
            _buildAmortizationSystemInfo(
              context: context,
              title: 'Sistema Francés (Cuota Fija)',
              description: 'Los pagos periódicos (cuotas) son constantes. Cada cuota se compone de una parte de interés (decreciente) y una parte de capital (creciente). Es el sistema más común para hipotecas.',
              formulaLabel: 'Pago Periódico (Pmt ó A):',
              formula: 'A = C × [i × (1 + i)ⁿ] / [(1 + i)ⁿ - 1]',
              variables: ['A = Pago periódico', 'C = Capital inicial (préstamo)', 'i = Tasa de interés por período', 'n = Número de períodos'],
            ),
            _buildAmortizationSystemInfo(
              context: context,
              title: 'Sistema Alemán (Capital Fijo)',
              description: 'La porción de capital amortizado es constante en cada período. Los intereses se calculan sobre el saldo pendiente (decreciente), por lo que la cuota total es decreciente.',
              formulaLabel: 'Amortización de Capital por Período:',
              formula: 'Amort. Capital = C / n',
              formulaLabel2: 'Interés Período k:',
              formula2: 'Interésₖ = Saldo Pendienteₖ₋₁ × i',
              formulaLabel3: 'Cuota Período k:',
              formula3: 'Cuotaₖ = (C / n) + Interésₖ',
               variables: ['C = Capital inicial', 'n = Número de períodos', 'i = Tasa interés por período'],
           ),
            _buildAmortizationSystemInfo(
              context: context,
              title: 'Sistema Americano (Interés Fijo)',
              description: 'Solo se pagan los intereses generados en cada período. El capital principal se devuelve íntegramente en un único pago al finalizar el plazo del préstamo.',
              formulaLabel: 'Pago Periódico (Solo Interés):',
              formula: 'Interés = C × i',
              formulaLabel2: 'Pago Final:',
              formula2: 'Pago Final = (C × i) + C', // Último interés + Capital
              variables: ['C = Capital inicial', 'i = Tasa interés por período'],
            ),
             const SizedBox(height: kDefaultPadding * 4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCalculatorDialog(context),
        tooltip: 'Calculadora Amortización',
        child: const Icon(Icons.calculate),
      ),
    );
  }

  // Widget helper _buildAmortizationSystemInfo... (sin cambios)
   Widget _buildAmortizationSystemInfo({ /* ... igual que antes ... */
      required BuildContext context, required String title, required String description,
      required String formulaLabel, required String formula,
      String? formulaLabel2, String? formula2, String? formulaLabel3, String? formula3,
      List<String>? variables,
    }) {
      final theme = Theme.of(context);
      final textTheme = theme.textTheme;
      return Card( margin: const EdgeInsets.only(bottom: kDefaultPadding),
        child: ExpansionTile( title: Text(title, style: textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
          childrenPadding: const EdgeInsets.all(kDefaultPadding).copyWith(top: 0),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, style: textTheme.bodyMedium, textAlign: TextAlign.justify),
            const SizedBox(height: kDefaultPadding),
            Text(formulaLabel, style: textTheme.titleSmall?.copyWith(color: theme.colorScheme.secondary)),
            _buildFormulaText(formula, textTheme),
             if(formulaLabel2 != null && formula2 != null) ...[ /* ... */
               const SizedBox(height: kDefaultPadding / 2),
               Text(formulaLabel2, style: textTheme.titleSmall?.copyWith(color: theme.colorScheme.secondary)),
               _buildFormulaText(formula2, textTheme),
             ],
              if(formulaLabel3 != null && formula3 != null) ...[ /* ... */
                const SizedBox(height: kDefaultPadding / 2),
                Text(formulaLabel3, style: textTheme.titleSmall?.copyWith(color: theme.colorScheme.secondary)),
                _buildFormulaText(formula3, textTheme),
              ],
            if (variables != null && variables.isNotEmpty) ...[ /* ... */
               const SizedBox(height: kDefaultPadding /2),
               Text('Donde:', style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
               ...variables.map((v) => _buildFormulaDetailText(v, textTheme)).toList(),
            ],
          ],
        ),
      );
    }

   // Helper _buildFormulaText... (sin cambios)
    Widget _buildFormulaText(String text, TextTheme textTheme) { /* ... igual que antes ... */
       return Padding( padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
         child: Center(child: Text(text, style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500), textAlign: TextAlign.center)), );
     }
    // Helper _buildFormulaDetailText... (sin cambios)
     Widget _buildFormulaDetailText(String text, TextTheme textTheme) { /* ... igual que antes ... */
       return Padding( padding: const EdgeInsets.only(left: kDefaultPadding, top: kDefaultPadding / 4), child: Text(text, style: textTheme.bodySmall), );
     }


  // --- Lógica y UI de la Calculadora en un Dialog ---
  void _showCalculatorDialog(BuildContext context) {
    final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();
    final TextEditingController principalController = TextEditingController(); // C
    final TextEditingController rateController = TextEditingController();    // i (%)
    final TextEditingController periodsController = TextEditingController(); // n
    final TextEditingController paymentController = TextEditingController(); // Pmt (A)
    final TextEditingController resultController = TextEditingController();

    String selectedSystem = 'Sistema Francés';
    String selectedVariable = 'Pago Periódico (Pmt)';

     List<String> getCalculableVariables(String system) { /* ... igual que antes ... */
         List<String> options = ['Pago Periódico (Pmt)', 'Capital Inicial (C)', 'Número de Períodos (n)'];
         if (system == 'Sistema Americano') { // Solo Americano permite calcular 'i' fácilmente
            options.add('Tasa de Interés (i)');
         } // No añadir 'i' para Francés o Alemán
         return options;
      }
    List<String> calculableVariables = getCalculableVariables(selectedSystem);
    // Asegurar que la variable seleccionada inicial sea válida
    if (!calculableVariables.contains(selectedVariable)) { selectedVariable = calculableVariables[0]; }


    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final theme = Theme.of(dialogContext);

            // Función de cálculo interna
            void _calcularDialogo() {
               if (dialogFormKey.currentState?.validate() ?? false) {
                  double? c = double.tryParse(principalController.text);
                  double? iPercent = double.tryParse(rateController.text);
                  double? n = double.tryParse(periodsController.text);
                  double? pmt = double.tryParse(paymentController.text);

                  // --- Validaciones ---
                  if ((selectedVariable == 'Pago Periódico (Pmt)' || selectedVariable == 'Número de Períodos (n)' || selectedVariable == 'Tasa de Interés (i)') && c == null) { _showErrorSnackBar(dialogContext, 'Ingrese el Capital Inicial (C).'); return; }
                  if ((selectedVariable != 'Tasa de Interés (i)') && iPercent == null) { _showErrorSnackBar(dialogContext, 'Ingrese la Tasa de Interés (%).'); return; }
                  if ((selectedVariable == 'Pago Periódico (Pmt)' || selectedVariable == 'Capital Inicial (C)' || selectedVariable == 'Tasa de Interés (i)') && n == null && selectedSystem != 'Sistema Americano') { _showErrorSnackBar(dialogContext, 'Ingrese el Número de Períodos (n).'); return; } // n no es input para Americano Pmt/C/i
                  if ((selectedVariable == 'Capital Inicial (C)' || selectedVariable == 'Tasa de Interés (i)' || selectedVariable == 'Número de Períodos (n)') && pmt == null) { _showErrorSnackBar(dialogContext, 'Ingrese el Pago Periódico (Pmt).'); return; }

                  double i = (iPercent ?? 0) / 100.0; // Tasa por período
                  double resultado = 0;
                  // String resultadoLabel = selectedVariable; // No necesitamos esta variable aquí

                  try {
                     // --- Validaciones Adicionales ---
                     if (i <= 0 && selectedVariable != 'Tasa de Interés (i)' && selectedSystem != 'Sistema Americano' ) throw Exception('Tasa debe ser positiva.'); // Permitir tasa 0 o negativa para Am si se calcula C o Pmt
                     if (n != null && n <= 0 && selectedVariable != 'Número de Períodos (n)') throw Exception('Períodos debe ser positivo.');
                     if(c != null && c <=0 && selectedVariable != 'Capital Inicial (C)') throw Exception('Capital debe ser positivo.');
                     if(pmt != null && pmt <=0 && selectedVariable != 'Pago Periódico (Pmt)') throw Exception('Pago debe ser positivo.');


                     switch (selectedSystem) {
                       case 'Sistema Francés':
                         switch (selectedVariable) {
                           case 'Pago Periódico (Pmt)':
                              if (c == null || n == null) throw Exception('Faltan C o n');
                              if (i == 0) { resultado = c / n; } else {
                                // --- CORRECCIÓN pow().toDouble() ---
                                double factor = pow(1 + i, n).toDouble();
                                if ((factor - 1) == 0) throw Exception("División por cero");
                                resultado = (c * i * factor) / (factor - 1);
                              }
                              break;
                           case 'Capital Inicial (C)':
                              if (pmt == null || n == null) throw Exception('Faltan Pmt o n');
                              if (i == 0) { resultado = pmt * n; } else {
                                 // --- CORRECCIÓN pow().toDouble() ---
                                 double factor = pow(1 + i, n).toDouble();
                                 if ((i * factor) == 0) throw Exception("División por cero");
                                 resultado = (pmt * (factor - 1)) / (i * factor);
                              }
                              break;
                            case 'Número de Períodos (n)':
                              if (c == null || pmt == null) throw Exception('Faltan C o Pmt');
                              if (i <= 0) throw Exception('Tasa debe ser > 0 para calcular n');
                              if (pmt <= c * i) throw Exception('Pago insuficiente.');
                              if ((pmt - c * i) <= 0 || (1+i) <= 0) throw Exception("Valores inválidos para logaritmo.");
                              resultado = log(pmt / (pmt - c * i)) / log(1 + i);
                              break;
                            default: throw Exception('Variable desconocida');
                         }
                         break;

                       case 'Sistema Alemán':
                          switch (selectedVariable) {
                             case 'Pago Periódico (Pmt)': // Calcula Amort. Capital
                               if (c == null || n == null) throw Exception('Faltan C o n');
                               resultado = c / n;
                               break;
                             case 'Capital Inicial (C)':
                               if (pmt == null || n == null) throw Exception('Faltan Amort. Capital o n');
                               resultado = pmt * n;
                               break;
                             case 'Número de Períodos (n)':
                                if (c == null || pmt == null) throw Exception('Faltan C o Amort. Capital');
                                if (pmt == 0) throw Exception("División por cero");
                                resultado = c / pmt;
                                break;
                           default: throw Exception('Variable desconocida');
                          }
                          break;

                       case 'Sistema Americano':
                          switch (selectedVariable) {
                            case 'Pago Periódico (Pmt)': // Calcula Pago Interés
                               if (c == null) throw Exception('Falta C');
                               resultado = c * i;
                               break;
                            case 'Capital Inicial (C)':
                               if (pmt == null) throw Exception('Falta Pago Interés');
                               if (i == 0) throw Exception('Tasa no puede ser cero para calcular C');
                               resultado = pmt / i;
                               break;
                            case 'Tasa de Interés (i)':
                                if (c == null || pmt == null) throw Exception('Faltan C o Pago Interés');
                                if (c == 0) throw Exception('Capital no puede ser cero para calcular i');
                                resultado = (pmt / c) * 100; // %
                                break;
                             case 'Número de Períodos (n)': // No se calcula n en Americano
                                throw Exception("No aplica para Sistema Americano.");
                            default: throw Exception('Variable desconocida');
                          }
                          break;
                       default: throw Exception('Sistema desconocido');
                     }

                     setDialogState(() { resultController.text = resultado.toStringAsFixed(2); });

                 } catch (e) {
                    _showErrorSnackBar(dialogContext, 'Error: ${e.toString().replaceFirst("Exception: ","")}');
                 }
               }
            }

            void _limpiarDialogo() { /* ... (igual que antes) ... */
                 dialogFormKey.currentState?.reset();
                 principalController.clear(); rateController.clear(); periodsController.clear();
                 paymentController.clear(); resultController.clear();
                 setDialogState(() {
                     // No resetear sistema, pero sí la variable calculable
                     calculableVariables = getCalculableVariables(selectedSystem);
                     selectedVariable = calculableVariables[0];
                 });
              }

            // --- UI del AlertDialog ---
            return AlertDialog(
              title: Text('Calculadora Amortización', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
              content: Form(
                key: dialogFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selectores...
                       DropdownButtonFormField<String>( /* ... Selector Sistema (sin cambios) ... */
                          value: selectedSystem, items: const [ DropdownMenuItem(value: 'Sistema Francés', child: Text('Sistema Francés')), DropdownMenuItem(value: 'Sistema Alemán', child: Text('Sistema Alemán')), DropdownMenuItem(value: 'Sistema Americano', child: Text('Sistema Americano')), ],
                          onChanged: (String? newValue) { if (newValue != null) { setDialogState(() { selectedSystem = newValue; calculableVariables = getCalculableVariables(selectedSystem); selectedVariable = calculableVariables[0]; _limpiarDialogo(); }); } },
                          decoration: const InputDecoration(labelText: 'Sistema'), validator: (v) => v == null ? 'Selecciona' : null,
                       ),
                       const SizedBox(height: kDefaultPadding / 2),
                       DropdownButtonFormField<String>( /* ... Selector Variable (sin cambios) ... */
                         value: selectedVariable, items: calculableVariables.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                         onChanged: (String? newValue) { if (newValue != null) { setDialogState(() { selectedVariable = newValue; resultController.clear(); }); } },
                         decoration: const InputDecoration(labelText: 'Calcular Variable'), validator: (v) => v == null ? 'Selecciona' : null,
                       ),
                      const SizedBox(height: kDefaultPadding),

                      // Campos Condicionales...
                      if (selectedVariable != 'Capital Inicial (C)')
                         _buildDialogTextField(controller: principalController, label: 'Capital Inicial (C)'),
                      if (selectedVariable != 'Tasa de Interés (i)')
                         _buildDialogTextField(controller: rateController, label: 'Tasa Interés por Período (%)'),
                      // Ocultar 'n' si es Sistema Americano y no se calcula 'n' (que ya está deshabilitado)
                      if (selectedVariable != 'Número de Períodos (n)' && selectedSystem != 'Sistema Americano')
                         _buildDialogTextField(controller: periodsController, label: 'Número de Períodos (n)'),
                      if (selectedVariable != 'Pago Periódico (Pmt)')
                          _buildDialogTextField(controller: paymentController,
                              // Label dinámico según sistema
                              label: selectedSystem == 'Sistema Alemán'
                                      ? 'Amort. Capital Constante'
                                      : selectedSystem == 'Sistema Americano'
                                          ? 'Pago Interés Periódico'
                                          : 'Pago Periódico (Pmt)'),

                      const SizedBox(height: kDefaultPadding * 1.5),
                      // --- CORRECCIÓN Label Resultado ---
                      _buildDialogTextField(
                         controller: resultController,
                         label: 'Resultado ($selectedVariable)', // Usar selectedVariable
                         readOnly: true,
                         labelColor: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[ /* ... Botones (sin cambios) ... */
                  TextButton( onPressed: _limpiarDialogo, child: const Text('Limpiar'),),
                  TextButton( onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cerrar'),),
                  ElevatedButton( onPressed: _calcularDialogo, child: const Text('Calcular'), ),
               ],
            );
          },
        );
      },
    );
  }

   // Helper _buildDialogTextField... (sin cambios)
   Widget _buildDialogTextField({ /* ... igual que antes ... */
       required TextEditingController controller, required String label, String? hint,
       bool readOnly = false, Color? labelColor,
   }) {
      return Padding( padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        child: TextFormField( controller: controller, keyboardType: const TextInputType.numberWithOptions(decimal: true), readOnly: readOnly,
           decoration: InputDecoration( labelText: label, hintText: hint, labelStyle: labelColor != null ? TextStyle(color: labelColor) : null, filled: readOnly, fillColor: readOnly ? Theme.of(context).disabledColor.withOpacity(0.05) : null, ),
            validator: (value) { if (!readOnly) { if (value == null || value.isEmpty) { return 'Requerido'; } if (double.tryParse(value) == null) { return 'Inválido'; } if (!label.contains('Tasa') && !label.contains('Interés') && double.parse(value) <= 0) { return 'Positivo'; } } return null; },
           autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      );
   }

   // Helper _showErrorSnackBar... (sin cambios)
    void _showErrorSnackBar(BuildContext context, String message) { /* ... igual que antes ... */
       ScaffoldMessenger.of(context).showSnackBar( SnackBar( content: Text(message), backgroundColor: Theme.of(context).colorScheme.error, behavior: SnackBarBehavior.floating,),);
    }
}