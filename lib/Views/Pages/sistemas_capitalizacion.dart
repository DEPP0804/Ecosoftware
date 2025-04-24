import 'package:ecosoftware/Views/login_view/login_register_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SistemasCapitalizacionPage extends StatefulWidget {
  const SistemasCapitalizacionPage({super.key});

  @override
  State<SistemasCapitalizacionPage> createState() =>
      _SistemasCapitalizacionPageState();
}

class _SistemasCapitalizacionPageState
    extends State<SistemasCapitalizacionPage> {
  String selectedSystem = 'Individual';
  String selectedVariable = 'VF';

  final TextEditingController aportacionController = TextEditingController();
  final TextEditingController tasaController = TextEditingController();
  final TextEditingController periodosController = TextEditingController();
  final TextEditingController resultadoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistemas de Capitalización'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Concepto General Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Concepto General:',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Los sistemas de capitalización son métodos utilizados para acumular fondos a través de aportaciones periódicas o únicas, con el objetivo de alcanzar un monto específico en el futuro. Estos sistemas se utilizan en diversos contextos, como seguros, fondos de inversión y planes de ahorro.',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // ExpansionTiles para los sistemas de capitalización
            _buildCapitalizationSystemInfo(
              context: context,
              title: 'Sistema Individual',
              description:
                  'En un sistema individual, una persona realiza aportaciones periódicas para acumular un fondo que será utilizado en el futuro, como en un plan de ahorro personal.',
              formula: 'VF = A × [(1 + i)^n - 1] / i',
              variables: [
                'VF = Valor Futuro',
                'A = Aportación periódica',
                'i = Tasa de interés por período',
                'n = Número de períodos',
              ],
              example:
                  'Ejemplo: Una persona aporta \$100 mensuales durante 5 años a una tasa de interés del 5% anual. Al final del período, acumula un fondo de \$6,800.',
            ),
            _buildCapitalizationSystemInfo(
              context: context,
              title: 'Sistema Colectivo',
              description:
                  'En un sistema colectivo, un grupo de personas realiza aportaciones para acumular un fondo común, que puede ser utilizado para beneficios compartidos, como en un fondo de pensiones.',
              formula: 'VF = Σ [Aᵢ × (1 + i)^(tᵢ)]',
              variables: [
                'VF = Valor Futuro del fondo colectivo',
                'A = Aportación periódica de cada persona',
                'i = Tasa de interés por período',
                't = Tiempo que lleva la aportación en el fondo',
              ],
              example:
                  'Ejemplo: Un grupo de 10 personas aporta \$200 mensuales durante 10 años a una tasa de interés del 4% anual. El fondo acumulado se distribuye entre los participantes según las reglas del sistema.',
            ),
            _buildCapitalizationSystemInfo(
              context: context,
              title: 'Sistema Mixto',
              description:
                  'En un sistema mixto, se combinan características de los sistemas individuales y colectivos, permitiendo aportaciones individuales dentro de un fondo colectivo.',
              formula: 'VF = αA(1 + i)^n + (1 - α)Ft',
              variables: [
                'VF = Valor Futuro',
                'A = Aportación periódica',
                'α = Proporción de aportación individual',
                'i = Tasa de interés por período',
                'n = Número total de períodos',
                'Ft = Valor Futuro del fondo colectivo',
              ],
              example:
                  'Ejemplo: Una persona aporta \$150 mensuales a un fondo colectivo durante 8 años, obteniendo beneficios individuales y compartidos según las reglas del sistema.',
            ),
            _buildCapitalizationSystemInfo(
              context: context,
              title: 'Sistema de Seguro',
              description:
                  'En un sistema de seguro, las aportaciones se utilizan para garantizar un beneficio futuro en caso de un evento específico, como un seguro de vida o de salud.',
              formula: 'B = P(1 + r)^t - Cs',
              variables: [
                'B = Beneficio garantizado',
                'P = Prima pagada periódicamente',
                'i = Tasa de interés por período',
                'n = Número de períodos',
                'Cs = Costo del seguro',
              ],
              example:
                  'Ejemplo: Una persona paga una prima anual de \$500 durante 20 años para un seguro de vida. En caso de fallecimiento, sus beneficiarios reciben \$50,000.',
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

  // Helper para construir las Cards desplegables
  Widget _buildCapitalizationSystemInfo({
    required BuildContext context,
    required String title,
    required String description,
    required String formula,
    required List<String> variables,
    required String example,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        title: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        childrenPadding: const EdgeInsets.all(16.0).copyWith(top: 0),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Fórmula:',
            style: textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            formula,
            style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Donde:',
            style: textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8.0),
          ...variables.map(
            (variable) => Text(
              variable,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Ejemplo:',
            style: textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            example,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  // Diálogo para calcular
  void _showCalculatorDialog(BuildContext context) {
    final TextEditingController vfController = TextEditingController(); // VF
    final TextEditingController aportacionController =
        TextEditingController(); // A
    final TextEditingController tasaController = TextEditingController(); // i
    final TextEditingController periodosController =
        TextEditingController(); // n
    final TextEditingController alphaController = TextEditingController(); // α
    final TextEditingController costoSeguroController =
        TextEditingController(); // Cs
    final TextEditingController resultadoController =
        TextEditingController(); // Resultado
    final Map<String, List<String>> systemVariables = {
      'Individual': ['VF', 'A', 'i', 'n'],
      'Colectivo': ['VF', 'A', 'i', 'n'],
      'Mixto': ['VF', 'A', 'i', 'n', 'α'],
      'Seguro': ['B', 'P', 'i', 'n', 'Cs'],
    };

    void _clearFields() {
      vfController.clear();
      aportacionController.clear();
      tasaController.clear();
      periodosController.clear();
      alphaController.clear();
      resultadoController.clear();
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Calculadora de Capitalización'),
              content: SingleChildScrollView(
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedSystem,
                        items:
                            ['Individual', 'Colectivo', 'Mixto', 'Seguro'].map((
                              system,
                            ) {
                              return DropdownMenuItem(
                                value: system,
                                child: Text('Sistema $system'),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedSystem = value;
                              selectedVariable = systemVariables[value]!.first;
                              _clearFields();
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Tipo de Sistema',
                        ),
                      ),
                      const SizedBox(height: kDefaultPadding),
                      DropdownButtonFormField<String>(
                        value: selectedVariable,
                        items:
                            (systemVariables[selectedSystem] ?? []).map((
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
                      const SizedBox(height: kDefaultPadding),
                      if (selectedVariable != 'VF' && selectedVariable != 'B')
                        TextFormField(
                          controller: vfController,
                          decoration: InputDecoration(
                            labelText:
                                selectedSystem == 'Seguro'
                                    ? 'Valor Futuro (B)'
                                    : 'Valor Futuro (VF)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      const SizedBox(height: kDefaultPadding),
                      if (selectedVariable != 'A' && selectedVariable != 'P')
                        TextFormField(
                          controller: aportacionController,
                          decoration: InputDecoration(
                            labelText:
                                selectedSystem == 'Seguro'
                                    ? 'Aportación (P)'
                                    : 'Aportación (A)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      const SizedBox(height: kDefaultPadding),
                      if (selectedVariable != 'i')
                        TextFormField(
                          controller: tasaController,
                          decoration: const InputDecoration(
                            labelText: 'Tasa de Interés (%)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      const SizedBox(height: kDefaultPadding),
                      if (selectedVariable != 'n')
                        TextFormField(
                          controller: periodosController,
                          decoration: const InputDecoration(
                            labelText: 'Número de Períodos (n)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      const SizedBox(height: kDefaultPadding),
                      if (selectedSystem == 'Mixto' && selectedVariable != 'α')
                        TextFormField(
                          controller: alphaController,
                          decoration: const InputDecoration(
                            labelText: 'Proporción Individual (α)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      if (selectedSystem == 'Seguro' &&
                          selectedVariable != 'Cs')
                        TextFormField(
                          controller: alphaController,
                          decoration: const InputDecoration(
                            labelText: 'Costo del Seguro (Cs)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      const SizedBox(height: kDefaultPadding),
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
                    double? VF = double.tryParse(vfController.text);
                    double? A = double.tryParse(aportacionController.text);
                    double? i = double.tryParse(tasaController.text) ?? 0 / 100;
                    double? n = double.tryParse(periodosController.text);
                    double? alpha = double.tryParse(alphaController.text);
                    double? Cs = double.tryParse(costoSeguroController.text);
                    double Ft = 0;
                    double resultado = 0;

                    if (selectedSystem == 'Individual') {
                      if (selectedVariable == 'VF' &&
                          A != null &&
                          i != null &&
                          n != null) {
                        resultado = A * (pow(1 + i, n) - 1) / i;
                      } else if (selectedVariable == 'A' &&
                          VF != null &&
                          i != null &&
                          n != null) {
                        resultado = VF * i / (pow(1 + i, n) - 1);
                      }
                    } else if (selectedSystem == 'Colectivo') {
                      if (selectedVariable == 'VF' &&
                          A != null &&
                          i != null &&
                          n != null) {
                        resultado = 0;
                        for (int j = 1; j <= n; j++) {
                          resultado += A * pow(1 + i, j);
                        }
                      }
                    } else if (selectedSystem == 'Mixto') {
                      if (selectedVariable == 'VF' &&
                          A != null &&
                          i != null &&
                          n != null &&
                          alpha != null) {
                        // Parte individual
                        double individualPart = alpha * A * pow(1 + i, n);
                        for (int j = 1; j <= n; j++) {
                          Ft += A * pow(1 + i, j);
                        }
                        // Parte colectiva
                        double collectivePart = (1 - alpha) * Ft;

                        resultado = individualPart + collectivePart;
                      }
                    } else if (selectedSystem == 'Seguro') {
                      if (selectedVariable == 'B' &&
                          A != null &&
                          i != null &&
                          n != null &&
                          Cs != null) {
                        resultado = (A * pow(1 + i, n)) - Cs;
                      }
                    }

                    setDialogState(() {
                      resultadoController.text = resultado.toStringAsFixed(2);
                    });
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
}
