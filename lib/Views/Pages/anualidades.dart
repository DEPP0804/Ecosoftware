import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ecosoftware/styles/app_styles.dart';

class AnualidadesPage extends StatefulWidget {
  @override
  _AnualidadesPageState createState() => _AnualidadesPageState();
}

class _AnualidadesPageState extends State<AnualidadesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anualidades', style: headingStyle),
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
              'Una anualidad es una serie de pagos iguales realizados a intervalos regulares durante un período de tiempo específico.',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Text('Fórmulas:', style: subHeadingStyle),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Monto o valor final (VF) de las anualidades (A) simple cierta:',
                style: bodyTextStyle,
              ),
            ),
            Center(
              child: Text('VF = A[((1 + i)^n - 1) / i]', style: bodyTextStyle),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Valor actual (VA) de las anualidades simple cierta:',
                style: bodyTextStyle,
              ),
            ),
            Center(
              child: Text('VA = A[(1 - (1 + i)^-n) / i]', style: bodyTextStyle),
            ),
            Text('Donde:', style: bodyTextStyle, textAlign: TextAlign.justify),
            Center(child: Text('Pmt = Pago periódico', style: bodyTextStyle)),
            Center(
              child: Text(
                'i = Tasa de interés por período',
                style: bodyTextStyle,
              ),
            ),
            Center(child: Text('n = Número de períodos', style: bodyTextStyle)),
            SizedBox(height: 20),
            Text('Ejemplo:', style: subHeadingStyle),
            SizedBox(height: 10),
            Text(
              'Si realizas pagos de \$100 al final de cada mes durante 5 años a una tasa de interés del 6% anual, el valor futuro de la anualidad sería:',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            Center(
              child: Text(
                'VF = 100 * [(1 + 0.005)^60 - 1] / 0.005',
                style: bodyTextStyle,
              ),
            ),
            Center(
              child: Text(
                'VF ≈ 100 * [1.34885 - 1] / 0.005',
                style: bodyTextStyle,
              ),
            ),
            Center(
              child: Text('VF ≈ 100 * 69.77 = 6977', style: bodyTextStyle),
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
    final TextEditingController paymentController = TextEditingController();
    final TextEditingController rateController = TextEditingController();
    final TextEditingController timeYearsController = TextEditingController();
    final TextEditingController timeMonthsController = TextEditingController();
    final TextEditingController resultController = TextEditingController();
    String selectedVariable = 'Valor Futuro (VF)';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Calcular Anualidad', style: headingStyle2),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: selectedVariable,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedVariable = newValue!;
                        });
                      },
                      items:
                          <String>[
                            'Valor Futuro (VF)',
                            'Valor Actual (VA)',
                            'Pago Periódico (A)',
                            'Tasa de Interés (i)',
                            'Número de Períodos (n)',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                    if (selectedVariable != 'Pago Periódico (A)')
                      TextField(
                        controller: paymentController,
                        decoration: inputDecoration('Pago Periódico (A)'),
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
                      double payment =
                          double.tryParse(paymentController.text) ?? 0;
                      double rate = double.tryParse(rateController.text) ?? 0;
                      double timeYears =
                          double.tryParse(timeYearsController.text) ?? 0;
                      double timeMonths =
                          double.tryParse(timeMonthsController.text) ?? 0;

                      // Convertir el tiempo total a años
                      double periods = timeYears + (timeMonths / 12);

                      double result = 0;
                      switch (selectedVariable) {
                        case 'Valor Futuro (VF)':
                          result =
                              payment * (pow((1 + rate), periods) - 1) / rate;
                          break;
                        case 'Valor Actual (VA)':
                          result =
                              payment * (1 - pow((1 + rate), -periods)) / rate;
                          break;
                        case 'Pago Periódico (A)':
                          result =
                              (double.tryParse(resultController.text) ?? 0) *
                              rate /
                              (pow((1 + rate), periods) - 1);
                          break;
                        case 'Tasa de Interés (i)':
                          result =
                              pow(
                                (double.tryParse(resultController.text) ?? 0) /
                                    payment,
                                (1 / periods),
                              ) -
                              1;
                          break;
                        case 'Número de Períodos (n)':
                          result =
                              log(
                                (double.tryParse(resultController.text) ?? 0) /
                                    payment,
                              ) /
                              log(1 + rate);
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
