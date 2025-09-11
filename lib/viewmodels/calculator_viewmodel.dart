import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorViewModel with ChangeNotifier {
  String _output = "0";
  String _expression = "";
  List<String> _history = [];
  String _viewMode = 'calculator';

  String get output => _output;
  String get expression => _expression;
  List<String> get history => _history;
  String get viewMode => _viewMode;

  void buttonPressed(String buttonText) {
    if (buttonText == "C") {
      _output = "0";
      _expression = "";
    } else if (buttonText == "⌫") {
      _backspace();
      return;
    } else if (["+", "-", "x", "÷", "%"].contains(buttonText)) { // <--- PERBAIKAN DI SINI
      if (_expression.isNotEmpty && ["+", "-", "x", "÷", "%"].contains(_expression.substring(_expression.length - 1))) {
        _expression = _expression.substring(0, _expression.length - 1) + buttonText;
      } else {
        _expression += buttonText;
      }
      _calculateResult();
    } else if (buttonText == "=") {
      if (_expression.isNotEmpty) {
        _history.add("$_expression = $_output");
      }
      _expression = _output;
    } else {
      _expression += buttonText;
      _calculateResult();
    }
    
    notifyListeners();
  }

  void _backspace() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      if (_expression.isEmpty) {
        _expression = "0";
      }
    }
    _calculateResult();
    notifyListeners();
  }

  void _calculateResult() {
    String currentExpression = _expression;

    if (currentExpression.isNotEmpty && ["+", "-", "x", "÷", "%"].contains(currentExpression.substring(currentExpression.length - 1))) { // <--- PERBAIKAN DI SINI JUGA
      currentExpression = currentExpression.substring(0, currentExpression.length - 1);
    }
    
    if (currentExpression.isEmpty || currentExpression == "0") {
      _output = "0";
      return;
    }
    
    try {
      String finalExpression = currentExpression.replaceAll('x', '*').replaceAll('÷', '/');
      
      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      
      double result = exp.evaluate(EvaluationType.REAL, cm);
      
      if (result == result.toInt()) {
        _output = result.toInt().toString();
      } else {
        _output = result.toString();
      }
    } catch (e) {
      // Biarkan _output tetap pada nilai sebelumnya
    }
  }

  void toggleHistoryView() {
    _viewMode = _viewMode == 'calculator' ? 'history' : 'calculator';
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}