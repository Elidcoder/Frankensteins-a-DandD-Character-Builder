import 'package:flutter/material.dart';

class SimpleColorPicker extends StatefulWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;

  const SimpleColorPicker({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  @override
  State<SimpleColorPicker> createState() => _SimpleColorPickerState();
}

class _SimpleColorPickerState extends State<SimpleColorPicker> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.currentColor;
  }

  @override
  void didUpdateWidget(SimpleColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentColor != oldWidget.currentColor) {
      setState(() {
        _currentColor = widget.currentColor;
      });
    }
  }

  // Predefined color palette
  static const List<Color> _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
    Colors.white,
  ];

  // Helper method to build individual color boxes
  Widget _buildColorBox(Color color) {
    // Check if this color should be highlighted based on the current color
    Color closestToCurrentColor = _findClosestColor(_currentColor);
    bool isSelected = color == closestToCurrentColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentColor = color;
        });
        widget.onColorChanged(color);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Helper method to find the closest color in the palette
  Color _findClosestColor(Color targetColor) {
    if (_colors.contains(targetColor)) {
      return targetColor;
    }

    Color closestColor = _colors.first;
    double minDistance = _colorDistance(targetColor, closestColor);

    for (Color color in _colors) {
      double distance = _colorDistance(targetColor, color);
      if (distance < minDistance) {
        minDistance = distance;
        closestColor = color;
      }
    }

    return closestColor;
  }

  // Calculate color distance using RGB values
  double _colorDistance(Color color1, Color color2) {
    double rDiff = (color1.red - color2.red).toDouble();
    double gDiff = (color1.green - color2.green).toDouble();
    double bDiff = (color1.blue - color2.blue).toDouble();
    return rDiff * rDiff + gDiff * gDiff + bDiff * bDiff;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current color display
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: _currentColor,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Current Color',
              style: TextStyle(
                color: _currentColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Color palette in a 4x5 grid using Column and Row
        Column(
          children: [
            for (int row = 0; row < 4; row++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int col = 0; col < 5; col++)
                      if (row * 5 + col < _colors.length)
                        _buildColorBox(_colors[row * 5 + col])
                      else
                        const SizedBox(
                            width: 40,
                            height: 40), // Empty space for incomplete rows
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
