import 'dart:math'; // Necesario para pow y log
import 'package:flutter/material.dart';
import 'package:ecosoftware/styles/app_styles.dart'; // Para kDefaultPadding y AppTheme

class AnualidadesPage extends StatefulWidget {
  const AnualidadesPage({Key? key}) : super(key: key);

  @override
  _AnualidadesPageState createState() => _AnualidadesPageState();
}

class _AnualidadesPageState extends State<AnualidadesPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anualidades'),
        // Estilos vienen del tema
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Concepto:', style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      'Una anualidad es una serie de pagos iguales (A) realizados a intervalos regulares durante un número específico de períodos (n) a una tasa de interés por período (i).',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text('Fórmulas (Anualidad Ordinaria Vencida):', style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
                     const SizedBox(height: kDefaultPadding),
                     Text('Valor Futuro (VF ó A):', style: textTheme.titleSmall?.copyWith(color: colorScheme.secondary)),
                     _buildFormulaText('VF = A × [((1 + i)ⁿ - 1) / i]', textTheme),
                     const SizedBox(height: kDefaultPadding),
                     Text('Valor Actual (VA ó P):', style: textTheme.titleSmall?.copyWith(color: colorScheme.secondary)),
                      _buildFormulaText('VA = A × [(1 - (1 + i)⁻ⁿ) / i]', textTheme),
                     const SizedBox(height: kDefaultPadding / 2),
                     Text('Donde:', style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
                     _buildFormulaDetailText('A = Pago periódico (anualidad)', textTheme),
                     _buildFormulaDetailText('i = Tasa de interés por período', textTheme),
                     _buildFormulaDetailText('n = Número de períodos', textTheme),
                  ],
                ),
              ),
            ),
             const SizedBox(height: kDefaultPadding),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text('Ejemplo (Valor Futuro):', style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
                     const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      'Si realizas pagos (A) de \$100 al final de cada mes durante 5 años (n = 60 meses) a una tasa de interés del 6% anual (i = 0.06 / 12 = 0.005 mensual), el valor futuro de la anualidad sería:',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    _buildFormulaText('VF = 100 × [((1 + 0.005)⁶⁰ - 1) / 0.005]', textTheme),
                    _buildFormulaText('VF ≈ 100 × [(1.34885 - 1) / 0.005]', textTheme),
                    _buildFormulaText('VF ≈ 100 × [0.34885 / 0.005]', textTheme),
                    _buildFormulaText('VF ≈ 100 × 69.77', textTheme),
                     _buildFormulaText('VF ≈ \$6977.00', textTheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCalculatorDialog(context),
         tooltip: 'Calculadora Anualidades',
        child: const Icon(Icons.calculate),
        // Estilos vienen del tema
      ),
    );
  }

   // Helper para fórmulas
   Widget _buildFormulaText(String text, TextTheme textTheme) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
       child: Center(child: Text(text, style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
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
    final TextEditingController paymentController = TextEditingController(); // A
    final TextEditingController rateController = TextEditingController();    // i (%)
    final TextEditingController periodsController = TextEditingController(); // n
    final TextEditingController futureValueController = TextEditingController(); // VF
    final TextEditingController presentValueController = TextEditingController(); // VA
    final TextEditingController resultController = TextEditingController();
    // Variable a calcular: VF, VA, A (Pago), n (Periodos). 'i' es muy complejo.
    String selectedVariable = 'VF';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final theme = Theme.of(dialogContext);

            // Función de cálculo interna
            void _calcularDialogo() {
               if (dialogFormKey.currentState?.validate() ?? false) {
                 double? a = double.tryParse(paymentController.text);
                 double? iPercent = double.tryParse(rateController.text);
                 double? n = double.tryParse(periodsController.text);
                 double? vf = double.tryParse(futureValueController.text);
                 double? va = double.tryParse(presentValueController.text);

                  // Validar entradas requeridas según lo que se calcula
                 if ((selectedVariable == 'VF' || selectedVariable == 'VA' || selectedVariable == 'n' || selectedVariable == 'i_disabled') && a == null) {
                    _showErrorSnackBar(dialogContext, 'Ingrese el Pago Periódico (A).'); return;
                 }
                 if ((selectedVariable == 'VF' || selectedVariable == 'VA' || selectedVariable == 'A' || selectedVariable == 'n') && iPercent == null) {
                    _showErrorSnackBar(dialogContext, 'Ingrese la Tasa de Interés (%).'); return;
                 }
                 if ((selectedVariable == 'VF' || selectedVariable == 'VA' || selectedVariable == 'A' || selectedVariable == 'i_disabled') && n == null) {
                    _showErrorSnackBar(dialogContext, 'Ingrese el Número de Períodos (n).'); return;
                 }
                  // Validar VF o VA si son necesarios para calcular A, n, i
                  if ((selectedVariable == 'A' || selectedVariable == 'n' || selectedVariable == 'i_disabled') && vf == null && va == null) {
                     _showErrorSnackBar(dialogContext, 'Ingrese el Valor Futuro (VF) o el Valor Actual (VA).'); return;
                  }
                   if ((selectedVariable == 'A' || selectedVariable == 'n' || selectedVariable == 'i_disabled') && vf != null && va != null) {
                     // Opcional: Decidir cuál usar si ambos se ingresan, o dar error.
                     // Por simplicidad, usaremos VF si está disponible, si no VA.
                     // Podrías tener radio buttons para elegir cuál usar.
                     va = null; // Priorizar VF si ambos están llenos
                     // O mostrar error: _showErrorSnackBar(dialogContext, 'Ingrese solo VF o VA, no ambos.'); return;
                   }


                 double i = (iPercent ?? 0) / 100.0; // Tasa por período
                 double resultado = 0;

                 try {
                   if (i <= 0 && selectedVariable != 'i_disabled') throw Exception('Tasa debe ser positiva.'); // Validar tasa positiva (excepto al calcularla)
                   if (n != null && n <= 0 && selectedVariable != 'n') throw Exception('Períodos debe ser positivo.'); // Validar periodos positivos

                   switch (selectedVariable) {
                     case 'VF':
                       if (a == null || n == null) throw Exception('Faltan A o n');
                       if (i == 0) { // Caso especial: interés cero
                          resultado = a * n;
                       } else {
                          resultado = a * ((pow(1 + i, n) - 1) / i);
                       }
                       break;
                     case 'VA':
                        if (a == null || n == null) throw Exception('Faltan A o n');
                       if (i == 0) { // Caso especial: interés cero
                          resultado = a * n;
                       } else {
                          resultado = a * ((1 - pow(1 + i, -n)) / i);
                       }
                       break;
                     case 'A': // Calcular Pago
                       if (i == 0) { // Caso especial: interés cero
                           if (n != null && n != 0) {
                              resultado = (vf ?? va ?? 0) / n;
                           } else {
                              throw Exception('Períodos (n) debe ser > 0 si i=0');
                           }
                       } else if (vf != null) { // Calcular A basado en VF
                          if (n == null) throw Exception('Falta n');
                          double factorVF = (pow(1 + i, n) - 1) / i;
                          if (factorVF == 0) throw Exception('Cálculo inválido (división por cero)');
                          resultado = vf / factorVF;
                       } else if (va != null) { // Calcular A basado en VA
                          if (n == null) throw Exception('Falta n');
                          double factorVA = (1 - pow(1 + i, -n)) / i;
                          if (factorVA == 0) throw Exception('Cálculo inválido (división por cero)');
                           resultado = va / factorVA;
                       } else {
                           throw Exception('Se requiere VF o VA para calcular A');
                       }
                       break;
                     case 'n': // Calcular Número de Períodos
                       if (a == null || a <= 0) throw Exception('Pago (A) debe ser positivo.');
                       if (i == 0) { // Caso especial: interés cero
                          if (vf != null && a != 0) resultado = vf / a;
                          else if (va != null && a != 0) resultado = va / a;
                          else throw Exception('Se requiere VF o VA y A != 0 si i=0');
                       } else if (vf != null) { // Calcular n basado en VF
                           if (vf <= 0) throw Exception('VF debe ser positivo.');
                           if ((vf * i / a) <= -1) throw Exception('Valores inválidos para logaritmo (VF)');
                           resultado = log(1 + (vf * i / a)) / log(1 + i);
                       } else if (va != null) { // Calcular n basado en VA
                           if (va <= 0) throw Exception('VA debe ser positivo.');
                           if ((va * i / a) >= 1) throw Exception('Valores inválidos para logaritmo (VA)');
                           resultado = -log(1 - (va * i / a)) / log(1 + i);
                       } else {
                           throw Exception('Se requiere VF o VA para calcular n');
                       }
                       break;
                     case 'i_disabled': // Tasa de interés deshabilitada
                        throw Exception('El cálculo de la tasa (i) requiere métodos numéricos y no está implementado.');
                    default: throw Exception('Variable desconocida');
                   }

                   setDialogState(() { resultController.text = resultado.toStringAsFixed(2); });

                 } catch (e) {
                    _showErrorSnackBar(dialogContext, 'Error: ${e.toString().replaceFirst("Exception: ","")}');
                 }
               }
            }

             void _limpiarDialogo() { /* ... (igual que antes) ... */
                 dialogFormKey.currentState?.reset();
                 paymentController.clear(); rateController.clear(); periodsController.clear();
                 futureValueController.clear(); presentValueController.clear(); resultController.clear();
                 setDialogState(() { selectedVariable = 'VF'; });
              }

            // --- UI del AlertDialog ---
            return AlertDialog(
              title: Text('Calculadora Anualidades', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
              content: Form(
                key: dialogFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedVariable,
                        items: const [
                          DropdownMenuItem(value: 'VF', child: Text('Calcular Valor Futuro (VF)')),
                          DropdownMenuItem(value: 'VA', child: Text('Calcular Valor Actual (VA)')),
                          DropdownMenuItem(value: 'A', child: Text('Calcular Pago Periódico (A)')),
                          DropdownMenuItem(value: 'n', child: Text('Calcular Núm. Períodos (n)')),
                          // Opción deshabilitada para tasa
                          // DropdownMenuItem(value: 'i_disabled', child: Text('Calcular Tasa (i) - No disp.')),
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
                      if (selectedVariable != 'A')
                         _buildDialogTextField(controller: paymentController, label: 'Pago Periódico (A)'),
                       if (selectedVariable != 'i_disabled') // Siempre mostrar tasa, excepto si se calculara
                         _buildDialogTextField(controller: rateController, label: 'Tasa Interés por Período (%)'),
                       if (selectedVariable != 'n')
                          _buildDialogTextField(controller: periodsController, label: 'Número de Períodos (n)'),
                       // Mostrar campo VF o VA si son necesarios como entrada
                       if (selectedVariable == 'A' || selectedVariable == 'n' || selectedVariable == 'i_disabled')
                          _buildDialogTextField(controller: futureValueController, label: 'Valor Futuro (VF) (Opcional)'),
                       if (selectedVariable == 'A' || selectedVariable == 'n' || selectedVariable == 'i_disabled')
                          _buildDialogTextField(controller: presentValueController, label: 'Valor Actual (VA) (Opcional)'),

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

  // Helper para crear TextFormField dentro del diálogo (igual que antes)
  Widget _buildDialogTextField({
      required TextEditingController controller,
      required String label,
      String? hint, bool readOnly = false, Color? labelColor,
  }) {
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
                 // Permitir tasa 0? Depende. Pero otros deben ser > 0 usualmente
                 if (!label.contains('Tasa') && double.parse(value) <= 0 && !label.contains('Valor')) {
                    // Permitir VA/VF 0 si es input, pero no A o n
                    if(!label.contains('Pago') && !label.contains('Períodos')) return null;
                    return 'Positivo';
                 }
             }
              return null;
           },
          autovalidateMode: AutovalidateMode.onUserInteraction,
       ),
     );
  }

   // Helper para mostrar SnackBar de error (igual que antes)
   void _showErrorSnackBar(BuildContext context, String message) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar( content: Text(message), backgroundColor: Theme.of(context).colorScheme.error, behavior: SnackBarBehavior.floating,),
       );
    }
}