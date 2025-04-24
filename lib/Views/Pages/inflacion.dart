import 'package:flutter/material.dart';

class InflacionPage extends StatefulWidget {
  const InflacionPage({super.key});

  @override
  State<InflacionPage> createState() => _InflacionPageState();
}

class _InflacionPageState extends State<InflacionPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Inflación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Card: Concepto
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'La inflación es el aumento generalizado y sostenido de los precios de bienes y servicios en una economía durante un período de tiempo.',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Card: Fórmulas
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fórmula',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Tasa de Inflación:',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Tasa de Inflación = ((Precio Final - Precio Inicial) / Precio Inicial) * 100',
                      style: textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Donde:',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '- Precio Final: Precio del bien o servicio al final del período.',
                      style: textTheme.bodyMedium,
                    ),
                    Text(
                      '- Precio Inicial: Precio del bien o servicio al inicio del período.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Card: Ejemplo
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
                      'Supongamos que el precio de un bien era \$50 al inicio del año y aumentó a \$55 al final del año. '
                      'La tasa de inflación se calcula de la siguiente manera:\n\n'
                      'Tasa de Inflación = ((55 - 50) / 50) * 100 = 10%\n\n'
                      'Por lo tanto, la tasa de inflación para este período es del 10%.',
                      style: textTheme.bodyMedium,
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
        tooltip: 'Calcular Inflación',
        child: const Icon(Icons.calculate),
      ),
    );
  }

  void _showCalculatorDialog(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController precioInicialController =
        TextEditingController();
    final TextEditingController precioFinalController = TextEditingController();
    final TextEditingController tasaInflacionController =
        TextEditingController();
    final TextEditingController resultadoController = TextEditingController();
    String selectedVariable = 'Tasa de Inflación';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void _calcular() {
              if (formKey.currentState?.validate() ?? false) {
                try {
                  double? precioInicial = double.tryParse(
                    precioInicialController.text,
                  );
                  double? precioFinal = double.tryParse(
                    precioFinalController.text,
                  );
                  double? tasaInflacion = double.tryParse(
                    tasaInflacionController.text,
                  );

                  double resultado = 0;

                  switch (selectedVariable) {
                    case 'Tasa de Inflación':
                      if (precioInicial != null && precioFinal != null) {
                        resultado =
                            ((precioFinal - precioInicial) / precioInicial) *
                            100;
                        tasaInflacionController.text = resultado
                            .toStringAsFixed(2);
                        resultadoController.text =
                            'Tasa de Inflación: ${resultado.toStringAsFixed(2)}%';
                      }
                      break;
                    case 'Precio Final':
                      if (precioInicial != null && tasaInflacion != null) {
                        resultado = precioInicial * (1 + (tasaInflacion / 100));
                        precioFinalController.text = resultado.toStringAsFixed(
                          2,
                        );
                        resultadoController.text =
                            'Precio Final: \$${resultado.toStringAsFixed(2)}';
                      }
                      break;
                    case 'Precio Inicial':
                      if (precioFinal != null && tasaInflacion != null) {
                        resultado = precioFinal / (1 + (tasaInflacion / 100));
                        precioInicialController.text = resultado
                            .toStringAsFixed(2);
                        resultadoController.text =
                            'Precio Inicial: \$${resultado.toStringAsFixed(2)}';
                      }
                      break;
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            }

            return AlertDialog(
              title: Text(
                'Calculadora de Inflación',
                style: TextStyle(
                  color: Theme.of(dialogContext).colorScheme.primary,
                ),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedVariable,
                        items: const [
                          DropdownMenuItem(
                            value: 'Tasa de Inflación',
                            child: Text('Calcular Tasa de Inflación'),
                          ),
                          DropdownMenuItem(
                            value: 'Precio Final',
                            child: Text('Calcular Precio Final'),
                          ),
                          DropdownMenuItem(
                            value: 'Precio Inicial',
                            child: Text('Calcular Precio Inicial'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedVariable = value;
                              precioInicialController.clear();
                              precioFinalController.clear();
                              tasaInflacionController.clear();
                              resultadoController.clear();
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Seleccionar Variable',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      if (selectedVariable != 'Precio Inicial')
                        TextFormField(
                          controller: precioInicialController,
                          decoration: const InputDecoration(
                            labelText: 'Precio Inicial',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo requerido';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 16.0),
                      if (selectedVariable != 'Precio Final')
                        TextFormField(
                          controller: precioFinalController,
                          decoration: const InputDecoration(
                            labelText: 'Precio Final',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo requerido';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 16.0),
                      if (selectedVariable != 'Tasa de Inflación')
                        TextFormField(
                          controller: tasaInflacionController,
                          decoration: const InputDecoration(
                            labelText: 'Tasa de Inflación (%)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo requerido';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 16.0),
                      // Campo para mostrar el resultado
                      TextField(
                        controller: resultadoController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Resultado',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cerrar'),
                ),
                ElevatedButton(
                  onPressed: _calcular,
                  child: const Text('Calcular'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
