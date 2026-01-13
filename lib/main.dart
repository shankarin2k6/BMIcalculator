import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const BMICalculator());
}

// ---------------------------
// 1. UNIT ENUMS AND MAPS
// ---------------------------

// Enum for Height Units
enum HeightUnit { m, cm, mm }

// Map to display user-friendly names for Height Units
const Map<HeightUnit, String> heightUnitNames = {
  HeightUnit.m: 'Meters (m)',
  HeightUnit.cm: 'Centimeters (cm)',
  HeightUnit.mm: 'Millimeters (mm)',
};

// Enum for Weight Units
enum WeightUnit { kg, g }

// Map to display user-friendly names for Weight Units
const Map<WeightUnit, String> weightUnitNames = {
  WeightUnit.kg: 'Kilograms (kg)',
  WeightUnit.g: 'Grams (g)',
};

// ---------------------------
// 2. MAIN APPLICATION WIDGETS
// ---------------------------
//POST https://trackapi.nutritionix.com/v2/natural/nutrients
//Content-Type: application/json
//x-app-id: dfsgrzddwdfdfdgdfgzdfhzdfb
//x-app-key: cvyhkvjfht568jijio75

//{
//  "query": "1 apple and 1 cup of rice"
//}

class BMICalculator extends StatelessWidget {
  const BMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const BMICalculatorHome(),
    );
  }
}

class BMICalculatorHome extends StatefulWidget {
  const BMICalculatorHome({super.key});

  @override
  State<BMICalculatorHome> createState() => _BMICalculatorHomeState();
}

class _BMICalculatorHomeState extends State<BMICalculatorHome> {
  // ---------------------------
  // 3. STATE VARIABLES & CONTROLLERS
  // ---------------------------
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  HeightUnit _selectedHeightUnit = HeightUnit.m;
  WeightUnit _selectedWeightUnit = WeightUnit.kg;

  double _bmiResult = 0.0;
  String _resultText = 'Enter your values and press Calculate';
  Color _resultTextColor = Colors.black54;

  // ---------------------------
  // 4. UNIT CONVERSION LOGIC
  // ---------------------------

  double _convertHeightToMeters(double value, HeightUnit unit) {
    switch (unit) {
      case HeightUnit.m:
        return value;
      case HeightUnit.cm:
        return value / 100.0;
      case HeightUnit.mm:
        return value / 1000.0;
    }
  }

  double _convertWeightToKilograms(double value, WeightUnit unit) {
    switch (unit) {
      case WeightUnit.kg:
        return value;
      case WeightUnit.g:
        return value / 1000.0;
    }
  }

  // ---------------------------
  // 5. BMI CALCULATION LOGIC
  // ---------------------------

  void _calculateBMI() {
    final double? heightInput = double.tryParse(_heightController.text);
    final double? weightInput = double.tryParse(_weightController.text);

    if (heightInput == null ||
        weightInput == null ||
        heightInput <= 0 ||
        weightInput <= 0) {
      setState(() {
        _bmiResult = 0.0;
        _resultText = 'Please enter valid positive values.';
        _resultTextColor = Colors.red;
      });
      return;
    }

    final double heightInMeters = _convertHeightToMeters(
      heightInput,
      _selectedHeightUnit,
    );
    final double weightInKgs = _convertWeightToKilograms(
      weightInput,
      _selectedWeightUnit,
    );

    if (heightInMeters == 0.0 || weightInKgs == 0.0) {
      setState(() {
        _bmiResult = 0.0;
        _resultText = 'The converted values are too small or invalid.';
        _resultTextColor = Colors.red;
      });
      return;
    }

    double bmi = weightInKgs / pow(heightInMeters, 2);
    Map<String, dynamic> interpretation = _getBMIInterpretation(bmi);

    setState(() {
      _bmiResult = bmi;
      _resultText = interpretation['text'];
      _resultTextColor = interpretation['color'];
    });
  }

  // ---------------------------
  // 6. INTERPRETATION LOGIC
  // ---------------------------

  Map<String, dynamic> _getBMIInterpretation(double bmi) {
    if (bmi < 18.5) {
      return {'text': 'Underweight', 'color': Colors.blue};
    } else if (bmi >= 18.5 && bmi < 25) {
      return {'text': 'Normal Weight', 'color': Colors.green};
    } else if (bmi >= 25 && bmi < 30) {
      return {'text': 'Overweight', 'color': Colors.orange};
    } else {
      return {'text': 'Obesity', 'color': Colors.red};
    }
  }

  // ---------------------------
  // 7. BUILD METHOD (UI)
  // ---------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced BMI Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- Height Input Row ---
            _buildInputRow(
              'Height',
              _heightController,
              _selectedHeightUnit,
              heightUnitNames.keys.toList(),
              (HeightUnit? newValue) {
                setState(() {
                  _selectedHeightUnit = newValue!;
                });
              },
            ),
            const SizedBox(height: 30),

            // --- Weight Input Row ---
            _buildInputRow(
              'Weight',
              _weightController,
              _selectedWeightUnit,
              weightUnitNames.keys.toList(),
              (WeightUnit? newValue) {
                setState(() {
                  _selectedWeightUnit = newValue!;
                });
              },
            ),
            const SizedBox(height: 40),

            // --- Calculate Button ---
            ElevatedButton(
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Calculate BMI'),
            ),
            const SizedBox(height: 50),

            // --- Result Display ---
            const Text(
              'Your BMI Result:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              _bmiResult == 0.0 ? '---' : _bmiResult.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w900,
                color: _resultTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              _resultText,
              style: TextStyle(
                fontSize: 22,
                fontStyle: FontStyle.italic,
                color: _resultTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildBmiCategoryTable(),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // 8. FIXED INPUT ROW (NO OVERFLOW)
  // ---------------------------

  Widget _buildInputRow<T extends Enum>(
    String label,
    TextEditingController controller,
    T selectedUnit,
    List<T> unitList,
    ValueChanged<T?> onChanged,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text input
        Expanded(
          flex: 2,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: label,
              hintText: 'Enter $label value',
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Dropdown with flexible layout
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<T>(
            value: selectedUnit,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 14,
              ),
            ),
            isExpanded: true,
            items: unitList.map<DropdownMenuItem<T>>((T unit) {
              final String name = (unit is HeightUnit)
                  ? heightUnitNames[unit]!
                  : weightUnitNames[unit as WeightUnit]!;
              return DropdownMenuItem<T>(
                value: unit,
                child: Text(name, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // ---------------------------
  // 9. BMI CATEGORY TABLE
  // ---------------------------

  Widget _buildBmiCategoryTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        _buildTableRow('BMI Range', 'Category', header: true),
        _buildTableRow('< 18.5', 'Underweight', color: Colors.blue.shade100),
        _buildTableRow(
          '18.5 - 24.9',
          'Normal Weight',
          color: Colors.green.shade100,
        ),
        _buildTableRow(
          '25.0 - 29.9',
          'Overweight',
          color: Colors.orange.shade100,
        ),
        _buildTableRow('>= 30.0', 'Obesity', color: Colors.red.shade100),
      ],
    );
  }

  TableRow _buildTableRow(
    String range,
    String category, {
    bool header = false,
    Color color = Colors.transparent,
  }) {
    return TableRow(
      decoration: BoxDecoration(color: color),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            range,
            style: TextStyle(
              fontWeight: header ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: TextStyle(
              fontWeight: header ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
