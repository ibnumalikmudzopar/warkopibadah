import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/calculator_viewmodel.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalculatorViewModel>(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      color: Colors.blueGrey[900],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  viewModel.expression,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.normal, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  viewModel.output,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white54),

          if (viewModel.viewMode == 'calculator')
            _buildCalculatorButtons(context, viewModel)
          else
            _buildHistoryView(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildCalculatorButtons(BuildContext context, CalculatorViewModel viewModel) {
    return Column(
      children: [
        _buildButtonRow(context, ["C", "%", "⌫", "÷"], viewModel.buttonPressed),
        _buildButtonRow(context, ["7", "8", "9", "x"], viewModel.buttonPressed),
        _buildButtonRow(context, ["4", "5", "6", "-"], viewModel.buttonPressed),
        _buildButtonRow(context, ["1", "2", "3", "+"], viewModel.buttonPressed),
        _buildLastRow(context, ["History", ".", "="], viewModel.buttonPressed, viewModel),
      ],
    );
  }

  Widget _buildHistoryView(BuildContext context, CalculatorViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 300, 
          child: viewModel.history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, color: Colors.white54, size: 64),
                      SizedBox(height: 16),
                      Text("Tidak ada riwayat", style: TextStyle(color: Colors.white54, fontSize: 18)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: viewModel.history.length,
                  itemBuilder: (context, index) {
                    final reversedIndex = viewModel.history.length - 1 - index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        viewModel.history[reversedIndex],
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    );
                  },
                ),
        ),
        _buildHistoryControlButtons(context, viewModel),
      ],
    );
  }

  Widget _buildHistoryControlButtons(BuildContext context, CalculatorViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(context, "Hapus Riwayat", () { viewModel.clearHistory(); }),
        _buildActionButton(context, "Kembali", () { viewModel.toggleHistoryView(); }),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String text, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[600],
            foregroundColor: Colors.white,
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context, List<String> buttons, Function(String) onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((text) => _buildButton(context, text, onPressed)).toList(),
    );
  }

  Widget _buildLastRow(BuildContext context, List<String> buttons, Function(String) onPressed, CalculatorViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.blueGrey[600],
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
              ),
              onPressed: () => viewModel.toggleHistoryView(),
              child: const Icon(Icons.history),
            ),
          ),
        ),
        _buildButton(context, buttons[1], onPressed),
        _buildButton(context, buttons[2], onPressed),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, Function(String) onPressed) {
    Color buttonColor = Colors.blueGrey[700]!;
    Color textColor = Colors.white;

    if (["+", "-", "x", "/", "="].contains(text)) {
      buttonColor = Colors.lightGreen;
    } else if (["C", "⌫", "%"].contains(text)) {
      buttonColor = Colors.blueGrey[600]!;
    }
    
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            shape: const CircleBorder(),
          ),
          onPressed: () => onPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}