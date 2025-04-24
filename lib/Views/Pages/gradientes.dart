import 'package:flutter/material.dart';
import 'dart:math';

class GradientesPage extends StatefulWidget {
  const GradientesPage({super.key});

  @override
  State<GradientesPage> createState() => _GradientesPageState();
}

class _GradientesPageState extends State<GradientesPage> {
  String selectedGradient = 'Aritmético Creciente';
  String selectedVariable = 'VP';

  final TextEditingController flujoInicialController =
      TextEditingController(); // A
  final TextEditingController incrementoController =
      TextEditingController(); // G o g
  final TextEditingController tasaController = TextEditingController(); // i
  final TextEditingController periodosController = TextEditingController(); // n
  final TextEditingController resultadoController =
      TextEditingController(); // Resultado

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Gradientes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Concepto General
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Concepto General',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Los gradientes son flujos de efectivo que aumentan o disminuyen de manera uniforme (aritmética) o proporcional (geométrica) en cada período. '
                      'Se utilizan en análisis financiero para modelar ingresos o costos que cambian con el tiempo.',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Gradiente Aritmético Creciente
            _buildGradientInfo(
              context: context,
              title: 'Gradiente Aritmético Creciente',
              description:
                  'El gradiente aritmético creciente es un flujo de efectivo que aumenta en una cantidad fija en cada período.',
              formulaLabel: 'Fórmulas:',
              formula: '''
Valor Presente (VP): VP = A × [1 - (1 + i)^-n] / i + G / i × [1 - (1 + i)^-n] / i - n / (1 + i)^n
Valor Futuro (VF): VF = A × [(1 + i)^n - 1] / i + G / i × [(1 + i)^n - 1] / i - n
              ''',
              variables: [
                'A = Flujo de efectivo uniforme inicial',
                'G = Incremento constante por período',
                'i = Tasa de interés por período',
                'n = Número de períodos',
              ],
            ),
            const SizedBox(height: 16.0),

            // Gradiente Aritmético Decreciente
            _buildGradientInfo(
              context: context,
              title: 'Gradiente Aritmético Decreciente',
              description:
                  'El gradiente aritmético decreciente es un flujo de efectivo que disminuye en una cantidad fija en cada período.',
              formulaLabel: 'Fórmulas:',
              formula: '''
Valor Presente (VP): VP = A × [1 - (1 + i)^-n] / i - G / i × [1 - (1 + i)^-n] / i - n / (1 + i)^n
Valor Futuro (VF): VF = A × [(1 + i)^n - 1] / i - G / i × [(1 + i)^n - 1] / i - n
              ''',
              variables: [
                'A = Flujo de efectivo uniforme inicial',
                'G = Decremento constante por período',
                'i = Tasa de interés por período',
                'n = Número de períodos',
              ],
            ),
            const SizedBox(height: 16.0),

            // Gradiente Geométrico Creciente
            _buildGradientInfo(
              context: context,
              title: 'Gradiente Geométrico Creciente',
              description:
                  'El gradiente geométrico creciente es un flujo de efectivo que aumenta en una proporción constante en cada período.',
              formulaLabel: 'Fórmulas:',
              formula: '''
Valor Presente (VP): VP = A × [(1 + g)^n - (1 + i)^n] / [(g - i) × (1 + i)^n]
Valor Futuro (VF): VF = A × [(1 + g)^n - (1 + i)^n] / (g - i)
              ''',
              variables: [
                'A = Flujo de efectivo inicial',
                'g = Tasa de crecimiento por período',
                'i = Tasa de interés por período',
                'n = Número de períodos',
              ],
            ),
            const SizedBox(height: 16.0),

            // Gradiente Geométrico Decreciente
            _buildGradientInfo(
              context: context,
              title: 'Gradiente Geométrico Decreciente',
              description:
                  'El gradiente geométrico decreciente es un flujo de efectivo que disminuye en una proporción constante en cada período.',
              formulaLabel: 'Fórmulas:',
              formula: '''
Valor Presente (VP): VP = A × [(1 + i)^n - (1 - g)^n] / [(g + i) × (1 + i)^n]
Valor Futuro (VF): VF = A × [(1 + i)^n - (1 - g)^n] / (g + i)
              ''',
              variables: [
                'A = Flujo de efectivo inicial',
                'g = Tasa de decrecimiento por período',
                'i = Tasa de interés por período',
                'n = Número de períodos',
              ],
            ),
            const SizedBox(height: 16.0),

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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Supongamos que tienes un flujo de efectivo inicial de \$1,000 que aumenta en \$100 cada año durante 5 años. '
                      'La tasa de interés es del 10% anual. Usando la fórmula del gradiente aritmético creciente:',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'VP = 1,000 × [1 - (1 + 0.1)^-5] / 0.1 + 100 / 0.1 × [1 - (1 + 0.1)^-5] / 0.1 - 5 / (1 + 0.1)^5',
                      style: textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'VP ≈ \$4,578.95',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCalculatorDialog(context),
        tooltip: 'Calcular',
        child: const Icon(Icons.calculate),
      ),
    );
  }

  void _showCalculatorDialog(BuildContext context) {
    final Map<String, List<String>> gradientVariables = {
      'Aritmético Creciente': ['VP', 'VF', 'A', 'G', 'i', 'n'],
      'Aritmético Decreciente': ['VP', 'VF', 'A', 'G', 'i', 'n'],
      'Geométrico Creciente': ['VP', 'VF', 'A', 'g', 'i', 'n'],
      'Geométrico Decreciente': ['VP', 'VF', 'A', 'g', 'i', 'n'],
    };

    void _clearFields() {
      flujoInicialController.clear();
      incrementoController.clear();
      tasaController.clear();
      periodosController.clear();
      resultadoController.clear();
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Calculadora de Gradientes'),
              content: SingleChildScrollView(
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedGradient,
                        items:
                            gradientVariables.keys.map((gradient) {
                              return DropdownMenuItem(
                                value: gradient,
                                child: Text(gradient),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedGradient = value;
                              selectedVariable =
                                  gradientVariables[value]!.first;
                              _clearFields();
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Tipo de Gradiente',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        value: selectedVariable,
                        items:
                            gradientVariables[selectedGradient]!.map((
                              variable,
                            ) {
                              return DropdownMenuItem(
                                value: variable,
                                child: Text('Calcular $variable'),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedVariable = value;
                              _clearFields();
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Variable a Calcular',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      if (selectedVariable != 'A')
                        TextFormField(
                          controller: flujoInicialController,
                          decoration: const InputDecoration(
                            labelText: 'Flujo Inicial (A)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      const SizedBox(height: 16.0),
                      if (selectedVariable != 'G' && selectedVariable != 'g')
                        TextFormField(
                          controller: incrementoController,
                          decoration: InputDecoration(
                            labelText:
                                selectedGradient.contains('Geométrico')
                                    ? 'Tasa de Crecimiento (g)'
                                    : 'Incremento (G)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      const SizedBox(height: 16.0),
                      if (selectedVariable != 'i')
                        TextFormField(
                          controller: tasaController,
                          decoration: const InputDecoration(
                            labelText: 'Tasa de Interés (i)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      const SizedBox(height: 16.0),
                      if (selectedVariable != 'n')
                        TextFormField(
                          controller: periodosController,
                          decoration: const InputDecoration(
                            labelText: 'Número de Períodos (n)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: resultadoController,
                        decoration: const InputDecoration(
                          labelText: 'Resultado',
                        ),
                        readOnly: true,
                      ),
                    ],
                  ),
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
                      // Obtener valores ingresados
                      final double? A = double.tryParse(
                        flujoInicialController.text,
                      );
                      final double? G = double.tryParse(
                        incrementoController.text,
                      );
                      final double? g = double.tryParse(
                        incrementoController.text,
                      );
                      final double? i = double.tryParse(tasaController.text);
                      final int? n = int.tryParse(periodosController.text);

                      if (A == null || i == null || n == null) {
                        throw Exception(
                          'Por favor, completa todos los campos requeridos.',
                        );
                      }

                      double resultado = 0;

                      // Lógica de cálculo
                      if (selectedGradient.contains('Aritmético')) {
                        if (selectedVariable == 'VP') {
                          if (G == null)
                            throw Exception(
                              'Por favor, ingresa el valor de G.',
                            );
                          resultado =
                              A * ((1 - pow(1 + i, -n)) / i) +
                              G /
                                  i *
                                  ((1 - pow(1 + i, -n)) / i -
                                      n / pow(1 + i, n));
                        } else if (selectedVariable == 'VF') {
                          if (G == null)
                            throw Exception(
                              'Por favor, ingresa el valor de G.',
                            );
                          resultado =
                              A * ((pow(1 + i, n) - 1) / i) +
                              G / i * ((pow(1 + i, n) - 1) / i - n);
                        }
                      } else if (selectedGradient.contains('Geométrico')) {
                        if (selectedVariable == 'VP') {
                          if (g == null || g == i) {
                            throw Exception(
                              'Por favor, ingresa un valor válido para g (g ≠ i).',
                            );
                          }
                          resultado =
                              A * ((1 - pow((1 + g) / (1 + i), n)) / (i - g));
                        } else if (selectedVariable == 'VF') {
                          if (g == null || g == i) {
                            throw Exception(
                              'Por favor, ingresa un valor válido para g (g ≠ i).',
                            );
                          }
                          resultado =
                              A * ((pow(1 + g, n) - pow(1 + i, n)) / (g - i));
                        }
                      }

                      // Mostrar resultado
                      setDialogState(() {
                        resultadoController.text = resultado.toStringAsFixed(2);
                      });
                    } catch (e) {
                      setDialogState(() {
                        resultadoController.text = 'Error: ${e.toString()}';
                      });
                    }
                  },
                  child: const Text('Calcular'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      _clearFields();
    });
  }

  Widget _buildGradientInfo({
    required BuildContext context,
    required String title,
    required String description,
    required String formulaLabel,
    required String formula,
    List<String>? variables,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        childrenPadding: const EdgeInsets.all(16.0),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16.0),
          Text(
            formulaLabel,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            formula,
            style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
          if (variables != null && variables.isNotEmpty) ...[
            const SizedBox(height: 16.0),
            Text(
              'Donde:',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4.0),
            ...variables.map(
              (variable) => Text('- $variable', style: textTheme.bodyMedium),
            ),
          ],
        ],
      ),
    );
  }
}
