import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ecosoftware/styles/app_styles.dart';

class InteresCompuestoPage extends StatefulWidget {
  @override
  _InteresCompuestoPageState createState() => _InteresCompuestoPageState();
}

class _InteresCompuestoPageState extends State<InteresCompuestoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interés Compuesto', style: headingStyle),
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
              'El interés compuesto es un método para calcular el interés ganado o pagado sobre un capital inicial (principal) donde el interés ganado se añade al capital para calcular el interés del siguiente período.',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Text('Fórmulas:', style: subHeadingStyle),
            SizedBox(height: 10),
            Center(
              child: Text('Monto Total: A = P(1 + r)^n', style: bodyTextStyle),
            ),
            Text('Donde:', style: bodyTextStyle, textAlign: TextAlign.justify),
            Center(
              child: Text(
                'P = Principal (capital inicial)',
                style: bodyTextStyle,
              ),
            ),
            Center(child: Text('r = Tasa de interés', style: bodyTextStyle)),
            Center(child: Text('n = Tiempo', style: bodyTextStyle)),
            SizedBox(height: 20),
            Text('Ejemplo:', style: subHeadingStyle),
            SizedBox(height: 10),
            Text(
              'Si inviertes \$1,000 a una tasa de interés del 5% anual, capitalizado mensualmente, durante 3 años, el monto total sería:',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            Center(child: Text('A = 1000(1 + 0.05)^3', style: bodyTextStyle)),
            Center(child: Text('A = 1000(1.157625)', style: bodyTextStyle)),
            Center(child: Text('A ≈ 1157.63', style: bodyTextStyle)),
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
    final TextEditingController amountController = TextEditingController();
    final TextEditingController resultController = TextEditingController();
    String selectedVariable = 'Monto Total (A)';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Calcular Interés Compuesto', style: headingStyle2),
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
                            'Monto Total (A)',
                            'Principal (P)',
                            'Tasa de Interés (r)',
                            'Tiempo (n)',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                    if (selectedVariable != 'Principal (P)')
                      TextField(
                        controller: principalController,
                        decoration: inputDecoration('Principal (P)'),
                        keyboardType: TextInputType.number,
                      ),
                    SizedBox(height: 10),
                    if (selectedVariable != 'Tasa de Interés (r)')
                      TextField(
                        controller: rateController,
                        decoration: inputDecoration('Tasa de Interés (r)'),
                        keyboardType: TextInputType.number,
                      ),
                    SizedBox(height: 10),
                    if (selectedVariable != 'Monto Total (A)')
                      TextField(
                        controller: amountController,
                        decoration: inputDecoration('Monto Total (A)'),
                        keyboardType: TextInputType.number,
                      ),
                    SizedBox(height: 10),
                    if (selectedVariable != 'Tiempo (n)')
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
                      double principal =
                          double.tryParse(principalController.text) ?? 0;
                      double rate = double.tryParse(rateController.text) ?? 0;
                      double timeYears =
                          double.tryParse(timeYearsController.text) ?? 0;
                      double timeMonths =
                          double.tryParse(timeMonthsController.text) ?? 0;
                      double amount =
                          double.tryParse(amountController.text) ?? 0;

                      // Convertir el tiempo total a años
                      double time = timeYears + (timeMonths / 12);

                      double result = 0;
                      switch (selectedVariable) {
                        case 'Monto Total (A)':
                          result = principal * pow((1 + rate), time);
                          break;
                        case 'Principal (P)':
                          result = amount / pow((1 + rate), time);
                          break;
                        case 'Tasa de Interés (r)':
                          result = pow((amount / principal), (1 / time)) - 1;
                          break;
                        case 'Tiempo (n)':
                          result =
                              (log(amount) - log(principal)) / log(1 + rate);
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
