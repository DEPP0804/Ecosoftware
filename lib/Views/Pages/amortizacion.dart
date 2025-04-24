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
  List<Map<String, dynamic>> amortizationTable = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Sistemas de Amortización')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Concepto General Card... (sin cambios)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Concepto General:',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
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
              description:
                  'Los pagos periódicos (cuotas) son constantes. Cada cuota se compone de una parte de interés (decreciente) y una parte de capital (creciente). Es el sistema más común para hipotecas.',
              formulaLabel: 'Pago Periódico (Pmt ó A):',
              formula: 'A = C × [i × (1 + i)ⁿ] / [(1 + i)ⁿ - 1]',
              variables: [
                'A = Pago periódico',
                'C = Capital inicial (préstamo)',
                'i = Tasa de interés por período',
                'n = Número de períodos',
              ],
            ),
            _buildAmortizationSystemInfo(
              context: context,
              title: 'Sistema Alemán (Capital Fijo)',
              description:
                  'La porción de capital amortizado es constante en cada período. Los intereses se calculan sobre el saldo pendiente (decreciente), por lo que la cuota total es decreciente.',
              formulaLabel: 'Amortización de Capital por Período:',
              formula: 'Amort. Capital = C / n',
              formulaLabel2: 'Interés Período k:',
              formula2: 'Interésₖ = Saldo Pendienteₖ₋₁ × i',
              formulaLabel3: 'Cuota Período k:',
              formula3: 'Cuotaₖ = (C / n) + Interésₖ',
              variables: [
                'C = Capital inicial',
                'n = Número de períodos',
                'i = Tasa interés por período',
              ],
            ),
            _buildAmortizationSystemInfo(
              context: context,
              title: 'Sistema Americano (Interés Fijo)',
              description:
                  'Solo se pagan los intereses generados en cada período. El capital principal se devuelve íntegramente en un único pago al finalizar el plazo del préstamo.',
              formulaLabel: 'Pago Periódico (Solo Interés):',
              formula: 'Interés = C × i',
              formulaLabel2: 'Pago Final:',
              formula2: 'Pago Final = (C × i) + C', // Último interés + Capital
              variables: [
                'C = Capital inicial',
                'i = Tasa interés por período',
              ],
            ),
            const SizedBox(height: kDefaultPadding * 2),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ejemplo (Francés):',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      'Si tomas un préstamo de \$10,000 a una tasa de interés del 5% anual, amortizado mensualmente durante 3 años, el pago mensual sería:',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      'A = 10,000 × [0.004167 × (1 + 0.004167)³⁶] / [(1 + 0.004167)³⁶ - 1]',
                      style: textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      'A = \$299.71',
                      style: textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            // Tabla de Amortización
            if (amortizationTable.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tabla de Amortización:',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: kDefaultPadding / 2),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Periodo')),
                            DataColumn(label: Text('Cuota')),
                            DataColumn(label: Text('Interés')),
                            DataColumn(label: Text('Capital')),
                            DataColumn(label: Text('Saldo')),
                          ],
                          rows:
                              amortizationTable
                                  .map(
                                    (row) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(row['Periodo'].toString()),
                                        ),
                                        DataCell(Text(row['Cuota'])),
                                        DataCell(Text(row['Interés'])),
                                        DataCell(Text(row['Capital'])),
                                        DataCell(Text(row['Saldo'])),
                                      ],
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: kDefaultPadding * 2),
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
  Widget _buildAmortizationSystemInfo({
    /* ... igual que antes ... */
    required BuildContext context,
    required String title,
    required String description,
    required String formulaLabel,
    required String formula,
    String? formulaLabel2,
    String? formula2,
    String? formulaLabel3,
    String? formula3,
    List<String>? variables,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: kDefaultPadding),
      child: ExpansionTile(
        title: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        childrenPadding: const EdgeInsets.all(kDefaultPadding).copyWith(top: 0),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: kDefaultPadding),
          Text(
            formulaLabel,
            style: textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          _buildFormulaText(formula, textTheme),
          if (formulaLabel2 != null && formula2 != null) ...[
            /* ... */
            const SizedBox(height: kDefaultPadding / 2),
            Text(
              formulaLabel2,
              style: textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
            _buildFormulaText(formula2, textTheme),
          ],
          if (formulaLabel3 != null && formula3 != null) ...[
            /* ... */
            const SizedBox(height: kDefaultPadding / 2),
            Text(
              formulaLabel3,
              style: textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
            _buildFormulaText(formula3, textTheme),
          ],
          if (variables != null && variables.isNotEmpty) ...[
            /* ... */
            const SizedBox(height: kDefaultPadding / 2),
            Text(
              'Donde:',
              style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
            ...variables
                .map((v) => _buildFormulaDetailText(v, textTheme))
                .toList(),
          ],
        ],
      ),
    );
  }

  // Helper _buildFormulaText... (sin cambios)
  Widget _buildFormulaText(String text, TextTheme textTheme) {
    /* ... igual que antes ... */
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
      child: Center(
        child: Text(
          text,
          style: textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Helper _buildFormulaDetailText... (sin cambios)
  Widget _buildFormulaDetailText(String text, TextTheme textTheme) {
    /* ... igual que antes ... */
    return Padding(
      padding: const EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 4,
      ),
      child: Text(text, style: textTheme.bodySmall),
    );
  }

  // --- Lógica y UI de la Calculadora en un Dialog ---
  void _showCalculatorDialog(BuildContext context) {
    final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();
    final TextEditingController principalController =
        TextEditingController(); // C
    final TextEditingController rateController =
        TextEditingController(); // i (%)
    final TextEditingController periodsController =
        TextEditingController(); // n
    final TextEditingController paymentController =
        TextEditingController(); // Pmt (A)

    String selectedSystem = 'Sistema Francés';

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

                if (c == null || iPercent == null || n == null) {
                  _showErrorSnackBar(dialogContext, 'Faltan datos requeridos.');
                  return;
                }

                double i = iPercent / 100.0;
                amortizationTable.clear();

                try {
                  switch (selectedSystem) {
                    case 'Sistema Francés':
                      double factor = pow(1 + i, n).toDouble();
                      double cuota = (c * i * factor) / (factor - 1);

                      double saldoPendiente = c;
                      for (int periodo = 1; periodo <= n; periodo++) {
                        double interes = saldoPendiente * i;
                        double capital = cuota - interes;
                        saldoPendiente -= capital;

                        amortizationTable.add({
                          'Periodo': periodo,
                          'Cuota': cuota.toStringAsFixed(2),
                          'Interés': interes.toStringAsFixed(2),
                          'Capital': capital.toStringAsFixed(2),
                          'Saldo': saldoPendiente.toStringAsFixed(2),
                        });
                      }
                      break;

                    case 'Sistema Alemán':
                      double amortizacionCapital = c / n;

                      double saldoPendiente = c;
                      for (int periodo = 1; periodo <= n; periodo++) {
                        double interes = saldoPendiente * i;
                        double cuota = amortizacionCapital + interes;
                        saldoPendiente -= amortizacionCapital;

                        amortizationTable.add({
                          'Periodo': periodo,
                          'Cuota': cuota.toStringAsFixed(2),
                          'Interés': interes.toStringAsFixed(2),
                          'Capital': amortizacionCapital.toStringAsFixed(2),
                          'Saldo': saldoPendiente.toStringAsFixed(2),
                        });
                      }
                      break;

                    case 'Sistema Americano':
                      double interes = c * i;

                      for (int periodo = 1; periodo <= n; periodo++) {
                        amortizationTable.add({
                          'Periodo': periodo,
                          'Cuota': interes.toStringAsFixed(2),
                          'Interés': interes.toStringAsFixed(2),
                          'Capital': '0.00',
                          'Saldo': c.toStringAsFixed(2),
                        });
                      }

                      amortizationTable.add({
                        'Periodo': 'Final',
                        'Cuota': (c + interes).toStringAsFixed(2),
                        'Interés': interes.toStringAsFixed(2),
                        'Capital': c.toStringAsFixed(2),
                        'Saldo': '0.00',
                      });
                      break;

                    default:
                      throw Exception('Sistema desconocido');
                  }

                  setState(() {});
                  Navigator.of(dialogContext).pop();
                } catch (e) {
                  _showErrorSnackBar(
                    dialogContext,
                    'Error: ${e.toString().replaceFirst("Exception: ", "")}',
                  );
                }
              }
            }

            return AlertDialog(
              title: const Text('Calculadora Amortización'),
              content: Form(
                key: dialogFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedSystem,
                        items: const [
                          DropdownMenuItem(
                            value: 'Sistema Francés',
                            child: Text('Sistema Francés'),
                          ),
                          DropdownMenuItem(
                            value: 'Sistema Alemán',
                            child: Text('Sistema Alemán'),
                          ),
                          DropdownMenuItem(
                            value: 'Sistema Americano',
                            child: Text('Sistema Americano'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setDialogState(() {
                              selectedSystem = newValue;
                              principalController.clear();
                              rateController.clear();
                              periodsController.clear();
                              paymentController.clear();
                            });
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Sistema'),
                      ),
                      const SizedBox(height: kDefaultPadding / 2),
                      TextFormField(
                        controller: principalController,
                        decoration: const InputDecoration(
                          labelText: 'Capital Inicial (C)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: kDefaultPadding / 2),
                      TextFormField(
                        controller: rateController,
                        decoration: const InputDecoration(
                          labelText: 'Tasa de Interés (%)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: kDefaultPadding / 2),
                      TextFormField(
                        controller: periodsController,
                        decoration: const InputDecoration(
                          labelText: 'Número de Períodos (n)',
                        ),
                        keyboardType: TextInputType.number,
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
                  onPressed: _calcularDialogo,
                  child: const Text('Calcular'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Helper _showErrorSnackBar... (sin cambios)
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
