import 'dart:math'; // Necesario para pow y log
import 'package:flutter/material.dart';
import 'package:ecosoftware/styles/app_styles.dart'; // Para kDefaultPadding y AppTheme

class InteresCompuestoPage extends StatefulWidget {
  // Hacer const si no recibe parámetros
  const InteresCompuestoPage({Key? key}) : super(key: key);

  @override
  _InteresCompuestoPageState createState() => _InteresCompuestoPageState();
}

class _InteresCompuestoPageState extends State<InteresCompuestoPage> {
  @override
  Widget build(BuildContext context) {
    // --- Obtener el Tema ---
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        // Estilos vienen del appBarTheme
        title: const Text('Interés Compuesto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding), // Usar constante
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Sección de Información ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Concepto:', style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      'El interés compuesto se calcula sobre el capital inicial y también sobre los intereses acumulados de períodos anteriores. Es decir, "el interés gana interés", lo que lleva a un crecimiento exponencial del capital.',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: kDefaultPadding),
                    Text('Fórmula Principal:', style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
                    const SizedBox(height: kDefaultPadding / 2),
                    // Usar un widget específico o formateo para fórmulas complejas
                    _buildFormulaText('Monto Total (A ó VF) = P × (1 + i)ⁿ', textTheme),
                    const SizedBox(height: kDefaultPadding / 2),
                     Text('Donde:', style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
                     _buildFormulaDetailText('A (ó VF) = Monto futuro o valor final', textTheme),
                     _buildFormulaDetailText('P (ó VP) = Principal o valor presente', textTheme),
                     _buildFormulaDetailText('i (ó r) = Tasa de interés por período', textTheme),
                     _buildFormulaDetailText('n = Número de períodos de capitalización', textTheme),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            // --- Ejemplo ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ejemplo:', style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      'Si inviertes \$1,000 (P) a una tasa de interés anual del 5% (i = 0.05) capitalizable anualmente durante 3 años (n = 3):',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    _buildFormulaText('A = 1000 × (1 + 0.05)³', textTheme),
                    _buildFormulaText('A = 1000 × (1.05)³', textTheme),
                    _buildFormulaText('A = 1000 × 1.157625', textTheme),
                    _buildFormulaText('A ≈ \$1157.63', textTheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCalculatorDialog(context),
        tooltip: 'Calculadora Interés Compuesto',
        child: const Icon(Icons.calculate),
        // Estilos vienen del tema
      ),
    );
  }

  // Helper para fórmulas
   Widget _buildFormulaText(String text, TextTheme textTheme) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
       child: Center(child: Text(text, style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500))),
     );
   }
    Widget _buildFormulaDetailText(String text, TextTheme textTheme) {
     return Padding(
       padding: const EdgeInsets.only(left: kDefaultPadding, top: kDefaultPadding / 4),
       child: Text(text, style: textTheme.bodySmall),
     );
   }


  // --- Lógica y UI de la Calculadora en un Dialog ---
  void _showCalculatorDialog(BuildContext context) {
    final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();
    final TextEditingController principalController = TextEditingController();
    final TextEditingController rateController = TextEditingController();
    final TextEditingController timeYearsController = TextEditingController();
    // final TextEditingController timeMonthsController = TextEditingController(); // Podría añadirse si se requiere capitalización < 1 año
    final TextEditingController amountController = TextEditingController(); // Monto Futuro (A)
    final TextEditingController resultController = TextEditingController();
    String selectedVariable = 'A'; // Calcular Monto Total por defecto

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final theme = Theme.of(dialogContext);

            void _calcularDialogo() {
              if (dialogFormKey.currentState?.validate() ?? false) {
                double? p = double.tryParse(principalController.text);
                double? rPorcentaje = double.tryParse(rateController.text);
                double? n = double.tryParse(timeYearsController.text); // Asumiendo n en años y tasa anual
                double? a = double.tryParse(amountController.text); // Monto Futuro

                 // Validaciones de entradas necesarias
                if ((selectedVariable == 'A' || selectedVariable == 'r' || selectedVariable == 'n') && p == null) {
                   _showErrorSnackBar(dialogContext, 'Ingrese el Principal (P).'); return;
                }
                 if ((selectedVariable == 'A' || selectedVariable == 'P' || selectedVariable == 'n') && rPorcentaje == null) {
                   _showErrorSnackBar(dialogContext, 'Ingrese la Tasa de Interés (%).'); return;
                }
                 if ((selectedVariable == 'P' || selectedVariable == 'r' || selectedVariable == 'n') && a == null) {
                   _showErrorSnackBar(dialogContext, 'Ingrese el Monto Total (A).'); return;
                }
                 if ((selectedVariable == 'A' || selectedVariable == 'P' || selectedVariable == 'r') && n == null) {
                   _showErrorSnackBar(dialogContext, 'Ingrese el Tiempo (n).'); return;
                }

                double rDecimal = (rPorcentaje ?? 0) / 100.0;
                double resultado = 0;

                try {
                  switch (selectedVariable) {
                    case 'A': // Monto Total
                      if (p == null || n == null) throw Exception("Valores inválidos"); // Redundante por validación previa
                      resultado = p * pow((1 + rDecimal), n);
                      break;
                    case 'P': // Principal
                       if (a == null || n == null) throw Exception("Valores inválidos");
                      if (rDecimal <= -1) throw Exception("Tasa inválida para calcular P");
                      resultado = a / pow((1 + rDecimal), n);
                      break;
                    case 'r': // Tasa de Interés
                      if (a == null || p == null || n == null) throw Exception("Valores inválidos");
                      if (a <= 0 || p <= 0) throw Exception("A y P deben ser positivos para calcular r.");
                      if (n == 0) throw Exception("Tiempo no puede ser cero para calcular r.");
                      // r = (A/P)^(1/n) - 1
                      resultado = (pow((a / p), (1 / n)) - 1) * 100; // Mostrar como %
                      break;
                    case 'n': // Tiempo
                       if (a == null || p == null) throw Exception("Valores inválidos");
                       if (a <= 0 || p <= 0) throw Exception("A y P deben ser positivos para calcular n.");
                       if (rDecimal <= 0) throw Exception("Tasa debe ser positiva para calcular n.");
                       // n = log(A/P) / log(1+r)
                       if ((a / p) <= 0 || (1 + rDecimal) <= 0) throw Exception("Valores inválidos para logaritmo.");
                       resultado = log(a / p) / log(1 + rDecimal);
                       break;
                    default: throw Exception('Variable desconocida');
                  }

                   setDialogState(() { resultController.text = resultado.toStringAsFixed(2); });

                } catch (e) {
                   _showErrorSnackBar(dialogContext, 'Error: ${e.toString().replaceFirst("Exception: ","")}');
                }
              }
            }

             void _limpiarDialogo() { /* ... (igual que en InteresSimplePage) ... */
                dialogFormKey.currentState?.reset();
                principalController.clear(); rateController.clear(); timeYearsController.clear();
                amountController.clear(); resultController.clear();
                setDialogState(() { selectedVariable = 'A'; });
             }

            // --- UI del AlertDialog ---
            return AlertDialog(
              title: Text('Calculadora I. Compuesto', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
              content: Form(
                key: dialogFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       DropdownButtonFormField<String>(
                         value: selectedVariable,
                         items: const [
                           DropdownMenuItem(value: 'A', child: Text('Calcular Monto Total (A)')),
                           DropdownMenuItem(value: 'P', child: Text('Calcular Principal (P)')),
                           DropdownMenuItem(value: 'r', child: Text('Calcular Tasa Interés (%)')),
                           DropdownMenuItem(value: 'n', child: Text('Calcular Tiempo (períodos)')),
                         ],
                         onChanged: (String? newValue) {
                            if (newValue != null) {
                               setDialogState(() { selectedVariable = newValue; _limpiarDialogo(); });
                            }
                         },
                         decoration: const InputDecoration(labelText: 'Calcular Variable'),
                         validator: (v) => v == null ? 'Selecciona' : null,
                       ),
                      const SizedBox(height: kDefaultPadding),

                      // Campos Condicionales
                      if (selectedVariable != 'P')
                         _buildDialogTextField(controller: principalController, label: 'Principal (P)'),
                      if (selectedVariable != 'r')
                         _buildDialogTextField(controller: rateController, label: 'Tasa Interés por Período (%)'), // Aclarar 'por período'
                      if (selectedVariable != 'n')
                          _buildDialogTextField(controller: timeYearsController, label: 'Número de Períodos (n)'), // Aclarar que es 'n'
                       if (selectedVariable != 'A')
                          _buildDialogTextField(controller: amountController, label: 'Monto Total (A)'),


                      const SizedBox(height: kDefaultPadding * 1.5),
                      _buildDialogTextField(
                         controller: resultController,
                         label: 'Resultado ($selectedVariable)',
                         readOnly: true,
                         labelColor: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
               actions: <Widget>[
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

   // Helper para crear TextFormField dentro del diálogo (reutilizable)
   Widget _buildDialogTextField({
       required TextEditingController controller,
       required String label,
       String? hint,
       bool readOnly = false,
       Color? labelColor,
   }) {
      // ... (igual que en InteresSimplePage, con validación de número positivo) ...
       return Padding(
         padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
         child: TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            readOnly: readOnly,
            decoration: InputDecoration(
               labelText: label, hintText: hint,
               labelStyle: labelColor != null ? TextStyle(color: labelColor) : null,
               filled: readOnly, fillColor: readOnly ? Theme.of(context).disabledColor.withOpacity(0.05) : null,
            ),
             validator: (value) {
               if (!readOnly) {
                   if (value == null || value.isEmpty) { return 'Requerido'; }
                   if (double.tryParse(value) == null) { return 'Inválido'; }
                   // Permitir tasa 0, pero no principal/monto/tiempo 0 o negativo usualmente
                   if (!label.contains('Tasa') && double.parse(value) <= 0) { return 'Positivo'; }
               }
                return null;
             },
            autovalidateMode: AutovalidateMode.onUserInteraction,
         ),
       );
    }

   // Helper para mostrar SnackBar de error
   void _showErrorSnackBar(BuildContext context, String message) {
     // ... (igual que en InteresSimplePage) ...
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(message),
           backgroundColor: Theme.of(context).colorScheme.error,
           behavior: SnackBarBehavior.floating,
         ),
       );
    }
}