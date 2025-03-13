import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ecosoftware/styles/app_styles.dart';

class AmortizacionPage extends StatefulWidget {
  @override
  _AmortizacionPageState createState() => _AmortizacionPageState();
}

class _AmortizacionPageState extends State<AmortizacionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amortización', style: headingStyle),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Concepto:', style: subHeadingStyle),
            SizedBox(height: 10),
            Text(
              'La amortización es el proceso de pagar una deuda a través de pagos periódicos regulares que incluyen tanto el interés como el principal. Existen tres sistemas principales de amortización: francés, alemán y americano.',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Text('Sistema Francés:', style: subHeadingStyle),
            SizedBox(height: 10),
            Text(
              'En el sistema de amortización francés, los pagos periódicos son iguales durante toda la vida del préstamo. Cada pago incluye una parte de interés y una parte de capital. La fórmula para calcular el pago periódico es:',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            Center(
              child: Text(
                'Pmt = [C * i(1 + i)^n] / [(1 + i)^n - 1]',
                style: bodyTextStyle,
              ),
            ),
            Text('Donde:', style: bodyTextStyle, textAlign: TextAlign.justify),
            Center(child: Text('P = Capital inicial', style: bodyTextStyle)),
            Center(
              child: Text(
                'i = Tasa de interés por período',
                style: bodyTextStyle,
              ),
            ),
            Center(child: Text('n = Número de períodos', style: bodyTextStyle)),
            SizedBox(height: 20),
            Text('Sistema Alemán:', style: subHeadingStyle),
            SizedBox(height: 10),
            Text(
              'En el sistema de amortización alemán, el pago de capital es constante en cada período, mientras que el pago de interés disminuye a medida que se reduce el saldo del préstamo. La fórmula para calcular el pago de capital es:',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            Center(
              child: Text('Pago de Capital = C / n', style: bodyTextStyle),
            ),
            Text(
              'El pago de interés se calcula sobre el saldo restante del préstamo.',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Text('Sistema Americano:', style: subHeadingStyle),
            SizedBox(height: 10),
            Text(
              'En el sistema de amortización americano, solo se pagan intereses periódicamente y el capital se paga en su totalidad al final del período del préstamo. La fórmula para calcular el pago de interés es:',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            Center(
              child: Text('Pago de Interés = C * i', style: bodyTextStyle),
            ),
            SizedBox(height: 20),
            Text('Ejemplo:', style: subHeadingStyle),
            SizedBox(height: 10),
            Text(
              'Si tomas un préstamo de \$10,000 a una tasa de interés del 5% anual, amortizado mensualmente durante 3 años, el pago mensual sería:',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            Center(
              child: Text(
                'Sistema Francés: Pmt = [10000 * 0.004167(1 + 0.004167)^36] / [(1 + 0.004167)^36 - 1]',
                style: bodyTextStyle,
              ),
            ),
            Center(
              child: Text(
                'Pmt ≈ [10000 * 0.004167 * 1.1616] / [1.1616 - 1]',
                style: bodyTextStyle,
              ),
            ),
            Center(child: Text('Pmt ≈ 299.71', style: bodyTextStyle)),
            SizedBox(height: 10),
            Text(
              'Sistema Alemán: Pago de Capital = 10000 / 36 ≈ 277.78',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            Text(
              'El pago de interés se calcula sobre el saldo restante del préstamo.',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              'Sistema Americano: Pago de Interés = 10000 * 0.05 / 12 ≈ 41.67',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            Text(
              'El capital se paga en su totalidad al final del período del préstamo.',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInputDialog(context),
        child: Icon(Icons.calculate, color: primaryColor),
        backgroundColor: Color(0xFFF1F8E9),
      ),
    );
  }

  void _showInputDialog(BuildContext context) {
    final TextEditingController principalController = TextEditingController();
    final TextEditingController rateController = TextEditingController();
    final TextEditingController timeYearsController = TextEditingController();
    final TextEditingController timeMonthsController = TextEditingController();
    final TextEditingController paymentController = TextEditingController();
    final TextEditingController resultController = TextEditingController();
    String selectedSystem = 'Sistema Francés';
    String selectedVariable = 'Pago Periódico (Pmt)';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Calcular Amortización', style: headingStyle2),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: selectedSystem,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSystem = newValue!;
                        });
                      },
                      items:
                          <String>[
                            'Sistema Francés',
                            'Sistema Alemán',
                            'Sistema Americano',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                    DropdownButton<String>(
                      value: selectedVariable,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedVariable = newValue!;
                        });
                      },
                      items:
                          <String>[
                            'Pago Periódico (Pmt)',
                            'Capital Inicial (C)',
                            'Tasa de Interés (i)',
                            'Número de Períodos (n)',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                    if (selectedVariable != 'Capital Inicial (C)')
                      TextField(
                        controller: principalController,
                        decoration: inputDecoration('Capital Inicial (C)'),
                        keyboardType: TextInputType.number,
                      ),
                    SizedBox(height: 10),
                    if (selectedVariable != 'Tasa de Interés (i)')
                      TextField(
                        controller: rateController,
                        decoration: inputDecoration('Tasa de Interés (i)'),
                        keyboardType: TextInputType.number,
                      ),
                    SizedBox(height: 10),
                    if (selectedVariable != 'Número de Períodos (n)')
                      Column(
                        children: [
                          TextField(
                            controller: timeYearsController,
                            decoration: inputDecoration('Tiempo (Años)'),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: timeMonthsController,
                            decoration: inputDecoration('Tiempo (Meses)'),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                    if (selectedVariable != 'Pago Periódico (Pmt)')
                      TextField(
                        controller: paymentController,
                        decoration: inputDecoration('Pago Periódico (Pmt)'),
                        keyboardType: TextInputType.number,
                      ),
                    SizedBox(height: 10),
                    TextField(
                      controller: resultController,
                      decoration: inputDecoration('Resultado'),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancelar',
                    style: subHeadingStyle.copyWith(color: accentColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    try {
                      double principal =
                          double.tryParse(principalController.text) ?? 0;
                      double rate = double.tryParse(rateController.text) ?? 0;
                      double timeYears =
                          double.tryParse(timeYearsController.text) ?? 0;
                      double timeMonths =
                          double.tryParse(timeMonthsController.text) ?? 0;
                      double payment =
                          double.tryParse(paymentController.text) ?? 0;

                      // Convertir el tiempo total a años
                      double periods = timeYears + (timeMonths / 12);

                      double result = 0;
                      switch (selectedSystem) {
                        case 'Sistema Francés':
                          switch (selectedVariable) {
                            case 'Pago Periódico (Pmt)':
                              result =
                                  (principal *
                                      rate *
                                      pow((1 + rate), periods)) /
                                  (pow((1 + rate), periods) - 1);
                              break;
                            case 'Capital Inicial (C)':
                              result =
                                  (payment * (pow((1 + rate), periods) - 1)) /
                                  (rate * pow((1 + rate), periods));
                              break;
                            case 'Tasa de Interés (i)':
                              result =
                                  pow(
                                    (payment * (pow((1 + rate), periods) - 1)) /
                                        (principal * pow((1 + rate), periods)),
                                    (1 / periods),
                                  ) -
                                  1;
                              break;
                            case 'Número de Períodos (n)':
                              result =
                                  log(payment / (payment - principal * rate)) /
                                  log(1 + rate);
                              break;
                          }
                          break;
                        case 'Sistema Alemán':
                          switch (selectedVariable) {
                            case 'Pago Periódico (Pmt)':
                              result = principal / periods;
                              break;
                            case 'Capital Inicial (C)':
                              result = payment * periods;
                              break;
                            case 'Tasa de Interés (i)':
                              result = (payment / principal) / periods;
                              break;
                            case 'Número de Períodos (n)':
                              result = principal / payment;
                              break;
                          }
                          break;
                        case 'Sistema Americano':
                          switch (selectedVariable) {
                            case 'Pago Periódico (Pmt)':
                              result = principal * rate;
                              break;
                            case 'Capital Inicial (C)':
                              result = payment / rate;
                              break;
                            case 'Tasa de Interés (i)':
                              result = payment / principal;
                              break;
                            case 'Número de Períodos (n)':
                              result = (payment / (principal * rate)) * 12;
                              break;
                          }
                          break;
                      }

                      resultController.text = result.toStringAsFixed(2);
                      Navigator.of(context).pop();
                      showCustomSnackBar(
                        context,
                        'Resultado: \$${result.toStringAsFixed(2)}',
                        isError: false,
                      );
                    } catch (e) {
                      showCustomSnackBar(
                        context,
                        'Por favor, ingrese valores válidos',
                        isError: true,
                      );
                    }
                  },
                  child: Text(
                    'Calcular',
                    style: subHeadingStyle.copyWith(color: primaryColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
