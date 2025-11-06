import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formkey = GlobalKey<FormState>();

  final _amountcontroller = TextEditingController();
  final _interestcontroller = TextEditingController();
  final _tenurecontroller = TextEditingController();

  String _result = "";

  void _calculateEmi() {
    if (_formkey.currentState!.validate()) {
      double p = double.tryParse(_amountcontroller.text) ?? 0.0;
      double annualInterest = double.tryParse(_interestcontroller.text) ?? 0.0;
      double r = annualInterest / 12 / 100;
      int n = int.tryParse(_tenurecontroller.text) ?? 0;

      double emi;
      if (r == 0) {
        emi = p / n;
      } else {
        emi = (p * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
      }

      double totalInterest = (emi * n) - p;

      setState(() {
        _result =
            "Loan Amount : ₹ ${p.toStringAsFixed(2)}\nEMI Amount : ₹ ${emi.toStringAsFixed(2)}\nTotal Interest : ₹ ${totalInterest.toStringAsFixed(2)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EMI Calculator App",
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 242, 225),
        appBar: AppBar(
          title: const Text("EMI Calculator App"),
          backgroundColor: const Color.fromARGB(255, 255, 175, 2),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: _amountcontroller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Loan Amount", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the loan amount";
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return "Please enter a valid positive number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _interestcontroller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Annual Interest Rate (%)",
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the interest rate";
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return "Please enter a valid positive number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _tenurecontroller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Loan Tenure (Months)",
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the loan tenure";
                    }
                    if (int.tryParse(value) == null ||
                        int.parse(value) <= 0) {
                      return "Please enter a valid positive number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 132, 31),
                        foregroundColor: Colors.black),
                    onPressed: _calculateEmi,
                    child: const Text("Calculate EMI")),
                const SizedBox(height: 20),
                Text(
                  _result,
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
