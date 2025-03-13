import 'package:flutter/material.dart';
import 'package:ecosoftware/styles/app_styles.dart';

class InteresSimplePage extends StatefulWidget {
  @override
  _InteresSimplePageState createState() => _InteresSimplePageState();
}

class _InteresSimplePageState extends State<InteresSimplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interés Simple', style: headingStyle),
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
              'El interés simple es un método para calcular el interés ganado o pagado sobre un capital inicial (principal) durante un período de tiempo específico. No se capitaliza, lo que significa que el interés ganado en cada período no se añade al capital para calcular el interés del siguiente período.',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Text('Fórmulas:', style: subHeadingStyle),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Interés Simple: I = C × i × t',
                style: bodyTextStyle,
              ),
            ),
            Center(child: Text('Monto Total: M = C + I', style: bodyTextStyle)),
            Center(
              child: Text(
                'O, combinando con la fórmula del interés simple:',
                style: bodyTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                'Monto Total: M = C × (1 + i × t)',
                style: bodyTextStyle,
              ),
            ),
            Center(
              child: Text(
                'Otra forma de expresarse: VF = VP × (1 + i × t)',
                style: bodyTextStyle,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'De la fórmula anterior, podemos despejar las distintas variables que contiene, como:',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            Center(child: Text('VP = VF / (1 + i × t)', style: bodyTextStyle)),
            Center(
              child: Text('i = ((VF / VP) - 1) / t', style: bodyTextStyle),
            ),
            Center(
              child: Text('t = ((VF / VP) - 1) / i', style: bodyTextStyle),
            ),
            SizedBox(height: 20),
            Text('Ejemplo:', style: subHeadingStyle),
            SizedBox(height: 10),
            Text(
              'Si inviertes \$1,000 a una tasa de interés del 5% anual durante 3 años, el interés simple ganado sería:',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
            Center(
              child: Text('I = 1000 × 0.05 × 3 = 150', style: bodyTextStyle),
            ),
            Center(
              child: Text(
                'El monto total después de 3 años sería:',
                style: bodyTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Center(child: Text('M = 1000 + 150 = 1150', style: bodyTextStyle)),
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
    final TextEditingController timeDaysController = TextEditingController();
    final TextEditingController interestController = TextEditingController();
    final TextEditingController resultController = TextEditingController();
    String selectedVariable = 'Interés (I)';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Calcular Interés Simple', style: headingStyle2),
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
                            'Interés (I)',
                            'Principal (C)',
                            'Tasa de Interés (i)',
                            'Tiempo (t)',
                            'Monto Total (M)',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                    if (selectedVariable != 'Principal (C)')
                      TextField(
                        controller: principalController,
                        decoration: inputDecoration('Principal (C)'),
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
                    if (selectedVariable != 'Interés (I)')
                      TextField(
                        controller: interestController,
                        decoration: inputDecoration('Interés (I)'),
                        keyboardType: TextInputType.number,
                      ),
                    SizedBox(height: 10),
                    if (selectedVariable != 'Tiempo (t)')
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
                          SizedBox(height: 10),
                          TextField(
                            controller: timeDaysController,
                            decoration: inputDecoration('Tiempo (Días)'),
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
                      double interest =
                          double.tryParse(interestController.text) ?? 0;
                      double timeYears =
                          double.tryParse(timeYearsController.text) ?? 0;
                      double timeMonths =
                          double.tryParse(timeMonthsController.text) ?? 0;
                      double timeDays =
                          double.tryParse(timeDaysController.text) ?? 0;

                      // Convertir el tiempo total a años
                      double time =
                          timeYears + (timeMonths / 12) + (timeDays / 360);

                      double result = 0;
                      switch (selectedVariable) {
                        case 'Interés (I)':
                          result = principal * rate * time;
                          break;
                        case 'Principal (C)':
                          result = interest / (rate * time);
                          break;
                        case 'Tasa de Interés (i)':
                          result = interest / (principal * time);
                          break;
                        case 'Tiempo (t)':
                          result = interest / (principal * rate);
                          break;
                        case 'Monto Total (M)':
                          result = principal * (1 + rate * time);
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
