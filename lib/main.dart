import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late double _numberFrom;
  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds (lbs)',
    'ounces',
  ];
  final Map<String, int> _measureMap = {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds (lbs)': 6,
    'ounces': 7,
  };
  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };
  late String _startMeasure;
  late String _convertedMeasure;
  late String _resultMessage;

  @override
  void initState() {
    _numberFrom = 0;
    _startMeasure = _measures[0];
    _convertedMeasure = _measures[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle inputStyle = TextStyle(
      fontSize: 16,
      color: Colors.blue[900],
    );
    final TextStyle labelStyle = TextStyle(
      fontSize: 24,
      color: Colors.grey[700],
    );
    return MaterialApp(
      title: "Measures Converter",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text('Measures Converter'),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  'Value',
                  style: labelStyle,
                ),
                TextField(
                  style: inputStyle,
                  decoration: const InputDecoration(
                    hintText: "Please insert the measure to be converted",
                  ),
                  onChanged: (text) {
                    var rv = double.tryParse(text);
                    if (rv != null) {
                      setState(() {
                        _numberFrom = rv;
                      });
                    }
                  },
                ),
                //Spacer(),
                Text(
                  'From',
                  style: labelStyle,
                ),
                DropdownButton(
                  isExpanded: true,
                  items: _measures.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _startMeasure = value!;
                    });
                  },
                  value: _startMeasure,
                ),
                Text(
                  'To',
                  style: labelStyle,
                ),

                DropdownButton(
                  isExpanded: true,
                  items: _measures.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _convertedMeasure = value!;
                    });
                  },
                  value: _convertedMeasure,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_startMeasure.isEmpty ||
                          _convertedMeasure.isEmpty ||
                          _numberFrom == 0) {
                        return;
                      } else {
                        convert(_numberFrom, _startMeasure, _convertedMeasure);
                      }
                    },
                    child: const Text('Convert')),
                Text(
                  _resultMessage,
                  style: labelStyle,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void convert(double value, String from, String to) {
    int? nFrom = _measureMap[from];
    int? nTo = _measureMap[to];

    var multiplier = _formulas[nFrom.toString()][nTo];
    var result = value * multiplier;

    if (result == 0) {
      _resultMessage = 'This conversion cannot be performed';
    } else {
      _resultMessage =
          '${_numberFrom.toString()} $_startMeasure are ${result.toString()} $_convertedMeasure';
    }
    setState(() {
      _resultMessage = _resultMessage;
    });
  }
}
