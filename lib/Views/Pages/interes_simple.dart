import 'package:flutter/material.dart';
import 'package:ecosoftware/styles/app_styles.dart'; // Para kDefaultPadding y AppTheme
//import 'dart:math'; // Necesario para cálculos si se usan potencias, etc. (Aunque no para interés simple)

class InteresSimplePage extends StatefulWidget {
  // Hacer el constructor const si es posible
  const InteresSimplePage({Key? key}) : super(key: key);

  @override
  _InteresSimplePageState createState() => _InteresSimplePageState();
}

class _InteresSimplePageState extends State<InteresSimplePage> {
  // No se necesita estado aquí si toda la lógica está en el Dialog

  @override
  Widget build(BuildContext context) {
    // --- Obtener el Tema ---
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        // title y backgroundColor vienen del appBarTheme en AppTheme
        title: const Text('Interés Simple'),
      ),
      body: SingleChildScrollView(
        // Usar constante kDefaultPadding si está definida en app_styles.dart
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Usar Card para agrupar la información
            Card(
              // Estilos (elevation, shape, color, margin) vienen de cardTheme
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Concepto:',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ), // Resaltar título de sección
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      'El interés simple se calcula únicamente sobre el capital inicial (principal) durante todo el período del préstamo o inversión. No se capitaliza, lo que significa que el interés ganado en cada período no se añade al capital para calcular el interés del siguiente período.',
                      style:
                          textTheme.bodyMedium, // Usar estilo base para cuerpo
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: kDefaultPadding),
                    Text(
                      'Fórmulas Principales:',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    _buildFormulaText('Interés (I) = C × i × t', textTheme),
                    _buildFormulaText(
                      'Monto Total (M ó VF) = C × (1 + i × t)',
                      textTheme,
                    ),
                    const SizedBox(height: kDefaultPadding),
                    Text(
                      'Despejes Comunes:',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ), // Usar título más pequeño
                    _buildFormulaText(
                      'Capital (C ó VP) = I / (i × t)',
                      textTheme,
                    ),
                    _buildFormulaText(
                      'Capital (C ó VP) = VF / (1 + i × t)',
                      textTheme,
                    ),
                    _buildFormulaText('Tasa (i) = I / (C × t)', textTheme),
                    _buildFormulaText('Tiempo (t) = I / (C × i)', textTheme),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            // Ejemplo (dentro de otra Card)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ejemplo:',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      'Si inviertes \$1,000 (C) a una tasa de interés anual del 5% (i = 0.05) durante 3 años (t = 3):',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    _buildFormulaText(
                      'Interés (I) = 1000 × 0.05 × 3 = \$150',
                      textTheme,
                    ),
                    _buildFormulaText(
                      'Monto Total (M) = 1000 + 150 = \$1150',
                      textTheme,
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
        // El color de fondo y del icono deberían venir del tema
        // backgroundColor: colorScheme.secondary, // Puedes forzarlo si quieres
        // foregroundColor: colorScheme.onSecondary,
        tooltip: 'Calculadora Interés Simple', // Añadir tooltip
        child: const Icon(Icons.calculate),
      ),
    );
  }

  // Helper para mostrar fórmulas con estilo consistente
  Widget _buildFormulaText(String text, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
      child: Center(
        child: Text(
          text,
          style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  // --- Lógica y UI de la Calculadora en un Dialog ---
  void _showCalculatorDialog(BuildContext context) {
    // Clave de formulario específica para el diálogo
    final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();
    // Controladores para los campos del diálogo
    final TextEditingController principalController = TextEditingController();
    final TextEditingController rateController = TextEditingController();
    final TextEditingController interestController = TextEditingController();
    final TextEditingController timeYearsController = TextEditingController();
    final TextEditingController timeMonthsController = TextEditingController();
    final TextEditingController timeDaysController = TextEditingController();
    final TextEditingController resultController = TextEditingController();
    // Variable para manejar el estado del Dropdown dentro del diálogo
    String selectedVariable = 'I'; // Calcular Interés por defecto

    showDialog(
      context: context,
      // Evitar cerrar el diálogo tocando fuera si se está calculando algo
      // barrierDismissible: !_isLoading, // Necesitarías manejar _isLoading aquí
      builder: (dialogContext) {
        // Usar dialogContext
        // StatefulBuilder para manejar el estado del Dropdown dentro del Dialog
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final theme = Theme.of(
              dialogContext,
            ); // Usar tema del contexto del diálogo

            // Función de cálculo interna del diálogo
            void _calcularDialogo() {
              if (dialogFormKey.currentState?.validate() ?? false) {
                double? c = double.tryParse(principalController.text);
                double? iPorcentaje = double.tryParse(rateController.text);
                double? I = double.tryParse(interestController.text);
                double tAnos = double.tryParse(timeYearsController.text) ?? 0;
                double tMeses = double.tryParse(timeMonthsController.text) ?? 0;
                double tDias = double.tryParse(timeDaysController.text) ?? 0;

                // Validaciones de entradas
                if ((selectedVariable == 'I' ||
                        selectedVariable == 't' ||
                        selectedVariable == 'i') &&
                    c == null) {
                  _showErrorSnackBar(
                    dialogContext,
                    'Ingrese el Principal (C).',
                  );
                  return;
                }
                if ((selectedVariable == 'I' ||
                        selectedVariable == 'C' ||
                        selectedVariable == 't') &&
                    iPorcentaje == null) {
                  _showErrorSnackBar(
                    dialogContext,
                    'Ingrese la Tasa de Interés (%).',
                  );
                  return;
                }
                if ((selectedVariable == 'C' ||
                        selectedVariable == 'i' ||
                        selectedVariable == 't') &&
                    I == null) {
                  _showErrorSnackBar(
                    dialogContext,
                    'Ingrese el Interés Simple (I).',
                  );
                  return;
                }

                double iDecimal = (iPorcentaje ?? 0) / 100.0;
                double tTotalAnos =
                    tAnos + (tMeses / 12.0) + (tDias / 360.0); // Año comercial

                if (selectedVariable != 't' && tTotalAnos <= 0) {
                  _showErrorSnackBar(
                    dialogContext,
                    'El tiempo total debe ser positivo.',
                  );
                  return;
                }

                double resultado = 0;

                try {
                  switch (selectedVariable) {
                    case 'I':
                      if (c == null)
                        throw Exception(
                          'Principal no válido',
                        ); // Ya validado arriba, pero por si acaso
                      resultado = c * iDecimal * tTotalAnos;
                      break;
                    case 'C':
                      if (I == null) throw Exception('Interés no válido');
                      if (iDecimal <= 0 || tTotalAnos <= 0)
                        throw Exception(
                          'Tasa o tiempo deben ser positivos para calcular C.',
                        );
                      resultado = I / (iDecimal * tTotalAnos);
                      break;
                    case 'i':
                      if (c == null || I == null)
                        throw Exception('Principal o Interés no válidos');
                      if (c <= 0 || tTotalAnos <= 0)
                        throw Exception(
                          'Principal y tiempo deben ser positivos para calcular i.',
                        );
                      resultado =
                          (I / (c * tTotalAnos)) * 100; // Mostrar como %
                      break;
                    case 't':
                      if (c == null || I == null)
                        throw Exception('Principal o Interés no válidos');
                      if (c <= 0 || iDecimal <= 0)
                        throw Exception(
                          'Principal y tasa deben ser positivos para calcular t.',
                        );
                      resultado = I / (c * iDecimal);
                      break;
                    default:
                      throw Exception('Variable desconocida seleccionada.');
                  }

                  // Actualizar el campo de resultado DENTRO del diálogo
                  setDialogState(() {
                    resultController.text = resultado.toStringAsFixed(2);
                  });
                } catch (e) {
                  _showErrorSnackBar(
                    dialogContext,
                    'Error: ${e.toString().replaceFirst("Exception: ", "")}',
                  );
                }
              }
            }

            // Función para limpiar campos del diálogo
            void _limpiarDialogo() {
              dialogFormKey.currentState?.reset();
              principalController.clear();
              rateController.clear();
              interestController.clear();
              timeYearsController.clear();
              timeMonthsController.clear();
              timeDaysController.clear();
              resultController.clear();
              setDialogState(() {
                selectedVariable = 'I';
              }); // Resetear dropdown
            }

            // --- UI del AlertDialog ---
            return AlertDialog(
              title: Text(
                'Calculadora I. Simple',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ), // Usar estilo de tema
              content: Form(
                // Envolver en Form
                key: dialogFormKey,
                child: SingleChildScrollView(
                  // Para evitar overflow
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Ajustar al contenido
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedVariable,
                        items: const [
                          DropdownMenuItem(
                            value: 'I',
                            child: Text('Calcular Interés (I)'),
                          ),
                          DropdownMenuItem(
                            value: 'C',
                            child: Text('Calcular Principal (C)'),
                          ),
                          DropdownMenuItem(
                            value: 'i',
                            child: Text('Calcular Tasa (%)'),
                          ),
                          DropdownMenuItem(
                            value: 't',
                            child: Text('Calcular Tiempo (años)'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setDialogState(() {
                              selectedVariable = newValue;

                              // Limpiar los campos relacionados
                              principalController.clear();
                              rateController.clear();
                              interestController.clear();
                              timeYearsController.clear();
                              timeMonthsController.clear();
                              timeDaysController.clear();
                              resultController.clear();
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Calcular Variable',
                        ),
                        validator:
                            (v) => v == null ? 'Selecciona una opción' : null,
                      ),
                      const SizedBox(height: kDefaultPadding),

                      // Campos condicionales
                      if (selectedVariable != 'C')
                        _buildDialogTextField(
                          controller: principalController,
                          label: 'Principal (C)',
                        ),
                      if (selectedVariable != 'i')
                        _buildDialogTextField(
                          controller: rateController,
                          label: 'Tasa Interés Anual (%)',
                        ),
                      if (selectedVariable != 'I')
                        _buildDialogTextField(
                          controller: interestController,
                          label: 'Interés Simple (I)',
                        ),
                      if (selectedVariable != 't') ...[
                        const SizedBox(height: kDefaultPadding / 2),
                        Text('Tiempo:', style: theme.textTheme.bodySmall),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDialogTextField(
                                controller: timeYearsController,
                                label: 'Años',
                                hint: '0',
                              ),
                            ),
                            const SizedBox(width: kDefaultPadding / 2),
                            Expanded(
                              child: _buildDialogTextField(
                                controller: timeMonthsController,
                                label: 'Meses',
                                hint: '0',
                              ),
                            ),
                            const SizedBox(width: kDefaultPadding / 2),
                            Expanded(
                              child: _buildDialogTextField(
                                controller: timeDaysController,
                                label: 'Días',
                                hint: '0',
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: kDefaultPadding * 1.5),
                      _buildDialogTextField(
                        controller: resultController,
                        label:
                            'Resultado ($selectedVariable)', // Label dinámico
                        readOnly: true, // Campo de solo lectura
                        labelColor:
                            theme.colorScheme.primary, // Resaltar resultado
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: _limpiarDialogo, // Botón Limpiar
                  child: const Text('Limpiar'),
                ),
                TextButton(
                  onPressed:
                      () =>
                          Navigator.of(
                            dialogContext,
                          ).pop(), // Usar dialogContext
                  child: const Text('Cerrar'),
                ),
                ElevatedButton(
                  onPressed: _calcularDialogo, // Llamar a la función de cálculo
                  child: const Text('Calcular'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Limpiar controladores del diálogo después de cerrarlo si es necesario,
      // aunque al definirse dentro de la función, se deberían liberar.
      // No es estrictamente necesario aquí.
    });
  }

  // Helper para crear TextFormField dentro del diálogo (reutilizable)
  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    String? hint, // Placeholder opcional
    bool readOnly = false,
    Color? labelColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ), // Numérico siempre
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint, // Mostrar placeholder si se proporciona
          labelStyle: labelColor != null ? TextStyle(color: labelColor) : null,
          // Estilo del tema se aplica automáticamente
          // Cambiar apariencia si es readonly
          filled: readOnly,
          fillColor:
              readOnly
                  ? Theme.of(context).disabledColor.withOpacity(0.05)
                  : null,
        ),
        validator: (value) {
          if (!readOnly) {
            // Solo validar si no es de solo lectura
            if (value == null || value.isEmpty) {
              // Permitir 0 en tiempo, pero no en otros campos requeridos
              if (label.contains('Tiempo'))
                return null; // 0 es válido para tiempo
              return 'Requerido';
            }
            if (double.tryParse(value) == null) {
              return 'Inválido';
            }
            if (double.parse(value) < 0) {
              return 'Positivo'; // Requerir valores positivos
            }
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  // Helper para mostrar SnackBar de error DENTRO del diálogo si es posible
  // o en el Scaffold principal si el diálogo ya se cerró.
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
