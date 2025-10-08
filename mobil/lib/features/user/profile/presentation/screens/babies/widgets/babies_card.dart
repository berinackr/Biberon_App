import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    super.key,
  });
  final String name;
  final int age;
  final double weight;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            color: Colors.red,
          ),
          const SizedBox(
            width: 8,
          ), // Add some space between the blue column and the text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLine(name, bold: true),
                _buildLine('Yaş: $age'),
                _buildLine('Kilo: $weight kg'),
                _buildLine('Boy: $height cm'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(String text, {bool bold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 1, // Adjust the height of the grey line
          thickness: 0.75, // Adjust the thickness of the grey line
        ),
      ],
    );
  }
}
