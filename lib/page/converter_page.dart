import 'package:flutter/material.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final TextEditingController _temperatureController = TextEditingController();
  String _selectedConversion = 'Fahrenheit to Celsius';
  String _convertedValue = '';
  List<String> _conversionHistory = [];
  final List<String> _conversionOptions = [
    'Fahrenheit to Celsius',
    'Celsius to Fahrenheit',
  ];

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  void _convertTemperature() {
    String inputText = _temperatureController.text.trim();

    if (inputText.isEmpty) {
      _showErrorDialog('Please enter a temperature value');
      return;
    }

    double? inputTemp = double.tryParse(inputText);
    if (inputTemp == null) {
      _showErrorDialog('Please enter a valid number');
      return;
    }

    double result;
    String operation;

    if (_selectedConversion == 'Fahrenheit to Celsius') {
      result = (inputTemp - 32) * 5 / 9;
      operation = 'F to C: $inputTemp → ${result.toStringAsFixed(2)}';
    } else {
      result = inputTemp * 9 / 5 + 32;
      operation = 'C to F: $inputTemp → ${result.toStringAsFixed(2)}';
    }

    setState(() {
      _convertedValue = result.toStringAsFixed(2);
      _conversionHistory.insert(0, operation);

      if (_conversionHistory.length > 10) {
        _conversionHistory = _conversionHistory.take(10).toList();
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Converter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 2,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildConversionSelection(),
                const SizedBox(height: 20),
                _buildTemperatureInputRow(),
                const SizedBox(height: 20),
                _buildConvertButton(),
                const SizedBox(height: 30),
                _buildHistorySection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConversionSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conversion:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[50],
          ),
          child: Row(
            children: _conversionOptions.map((option) {
              return Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    option,
                    style: const TextStyle(fontSize: 14),
                  ),
                  value: option,
                  groupValue: _selectedConversion,
                  onChanged: (value) {
                    setState(() {
                      _selectedConversion = value!;
                      _convertedValue = '';
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureInputRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],

            ),
            child: TextField(
              controller: _temperatureController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter temp',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            '=',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: Text(
              _convertedValue.isEmpty ? '0.00' : _convertedValue,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConvertButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _convertTemperature,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[400]!),
          ),
        ),
        child: const Text(
          'CONVERT',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 150,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: _conversionHistory.isEmpty
              ? const Center(
            child: Text(
              'No conversions yet',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
              : ListView.builder(
            itemCount: _conversionHistory.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  _conversionHistory[index],
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}