import 'package:flutter/material.dart';
import 'package:ecosoftware/styles/app_styles.dart';
import 'dart:math';

class TasaInteresRetornoPage extends StatefulWidget {
  const TasaInteresRetornoPage({super.key});

  @override
  State<TasaInteresRetornoPage> createState() => _TasaInteresRetornoPageState();
}

class _TasaInteresRetornoPageState extends State<TasaInteresRetornoPage> {
  final TextEditingController cashFlowsController = TextEditingController();
  final TextEditingController guessController = TextEditingController();
  final TextEditingController resultController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tasa de Interés y Retorno')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            // Concepto
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Concepto',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'La Tasa Interna de Retorno (TIR) es la tasa de descuento que hace que el valor presente neto (VPN) de los flujos de efectivo sea igual a cero.',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding),

            // Fórmula
            buildFormulaInfo(
              context: context,
              title: 'Fórmula General',
              formula: '0 = Σ (Ct / (1 + TIR)^t)',
              variables: [
                'Ct: Flujo de caja en el periodo t',
                'TIR: Tasa interna de retorno',
                't: Periodo de tiempo (0, 1, 2, ...)',
              ],
            ),
            const SizedBox(height: kDefaultPadding),

            // Ejemplo
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ejemplo',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Supongamos que realizas una inversión inicial de \$1,000 y recibes los siguientes flujos de efectivo durante 3 años:\n\n'
                      'Año 1: \$400\n'
                      'Año 2: \$500\n'
                      'Año 3: \$600\n\n'
                      'Queremos calcular la Tasa Interna de Retorno (TIR) que hace que el valor presente neto (VPN) sea igual a 0.\n\n'
                      'Fórmula:\n'
                      '0 = Σ (Ct / (1 + TIR)^t)\n\n'
                      'Resolviendo iterativamente, obtenemos:\n'
                      'TIR ≈ 14.49%',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCalculationDialog(context),
        child: const Icon(Icons.calculate),
      ),
    );
  }

  void _showCalculationDialog(BuildContext context) {
    void _clearFields() {
      cashFlowsController.clear();
      guessController.clear();
      resultController.clear();
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Calcular TIR',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cashFlowsController,
                  decoration: const InputDecoration(
                    labelText: 'Flujos de efectivo (separados por comas)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: kDefaultPadding),
                TextField(
                  controller: guessController,
                  decoration: const InputDecoration(
                    labelText: 'Suposición inicial para la TIR (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: kDefaultPadding),
                // Campo para mostrar el resultado
                TextField(
                  controller: resultController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Resultado',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearFields();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  // Convertir los flujos de efectivo ingresados
                  final cashFlows =
                      cashFlowsController.text
                          .split(',')
                          .map((e) => double.parse(e.trim()))
                          .toList();

                  // Obtener la suposición inicial
                  final guess = double.tryParse(guessController.text) ?? 0.1;

                  // Calcular la TIR
                  final tir = calculateTIR(cashFlows, guess: guess) * 100;

                  // Actualizar el resultado en el controlador
                  setState(() {
                    resultController.text =
                        'La TIR es ${tir.toStringAsFixed(2)}%';
                  });

                  // Depuración: Verificar el resultado
                  print('Resultado: ${resultController.text}');
                } catch (e) {
                  // Mostrar el error en el controlador
                  setState(() {
                    resultController.text = 'Error: ${e.toString()}';
                  });

                  // Depuración: Mostrar el error en la consola
                  print('Error: ${e.toString()}');
                }
              },
              child: const Text('Calcular'),
            ),
          ],
        );
      },
    ).then((_) {
      _clearFields();
    });
  }

  // Método para calcular la TIR
  double calculateTIR(List<double> cashFlows, {double guess = 0.1}) {
    const double tolerance = 1e-6;
    const int maxIterations = 1000;
    double tir = guess;

    // Validar que los flujos de efectivo incluyan al menos un valor negativo y uno positivo
    if (!cashFlows.any((cf) => cf < 0) || !cashFlows.any((cf) => cf > 0)) {
      throw Exception(
        'Los flujos de efectivo deben incluir al menos un valor negativo (inversión) y uno positivo (retorno).',
      );
    }

    for (int iteration = 0; iteration < maxIterations; iteration++) {
      double npv = 0;
      double derivative = 0;

      for (int t = 0; t < cashFlows.length; t++) {
        npv += cashFlows[t] / pow(1 + tir, t);
        derivative -= t * cashFlows[t] / pow(1 + tir, t + 1);
      }

      // Si el derivado es cero, evita la división por cero
      if (derivative == 0) {
        throw Exception(
          'El cálculo no puede continuar porque el derivado es cero.',
        );
      }

      double newTir = tir - npv / derivative;

      // Verificar si la diferencia es menor que la tolerancia
      if ((newTir - tir).abs() < tolerance) {
        return newTir;
      }

      tir = newTir;
    }

    // Si no converge en el número máximo de iteraciones
    throw Exception(
      'No se pudo calcular la TIR en $maxIterations iteraciones.',
    );
  }

  Widget buildFormulaInfo({
    required BuildContext context,
    required String title,
    required String formula,
    List<String>? variables,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 100,
          minWidth: 500,
        ), // Tamaño mínimo uniforme
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),

              // Fórmula
              Text(
                formula,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),

              // Variables (Donde:)
              if (variables != null) ...[
                const SizedBox(height: 16.0),
                Text(
                  'Donde:',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4.0),
                ...variables.map(
                  (variable) =>
                      Text('- $variable', style: textTheme.bodyMedium),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
