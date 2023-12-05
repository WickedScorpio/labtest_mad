import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

enum Gender { male, female }

void main() {
  runApp(BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BMICalculatorPage(),
    );
  }
}


class BMICalculatorPage extends StatefulWidget {
  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  final TextEditingController _textFieldController3 = TextEditingController();
  Gender selectedGender = Gender.male;

  void _onSubmit() {
    double weight = double.tryParse(_textFieldController3.text) ?? 0;
    double height = double.tryParse(_textFieldController2.text) ?? 0;
    String fullName = _textFieldController1.text;

    double bmi = _calculateBMI(weight, height / 100); // convert height to meters
    print('Full Name: $fullName');
    print('Height: $height cm');
    print('Weight: $weight kg');
    print('BMI: $bmi');

    String category;
    if (bmi < 18.5) {
      category = 'Underweight. Careful during strong wind!';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      category = "That's Ideal";
    } else if (bmi >= 25.0 && bmi <= 29.9) {
      category = 'Overweight!';
    } else {
      category = 'Whoa Obese! Dangerous mate';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('BMI Result'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your BMI is: $bmi'),
              const SizedBox(height: 10),
              Text('Category: $category'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  double _calculateBMI(double weight, double height) {
    return weight / (height * height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _textFieldController1,
              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textFieldController2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textFieldController3,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Male circle button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = Gender.male;
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedGender == Gender.male
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    child: Icon(
                      Icons.male,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Female circle button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = Gender.female;
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedGender == Gender.female
                          ? Colors.pink
                          : Colors.grey,
                    ),
                    child: Icon(
                      Icons.female,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text('Calculate BMI and Save'),
            ),
          ],
        ),
      ),
    );
  }
}