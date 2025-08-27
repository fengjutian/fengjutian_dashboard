import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    // Wrap content in MaterialApp to provide Directionality and other essential contexts
    return MaterialApp(
      home: ColoredBox(
        color: colors.primary,
        child: Text(
          'Hello World!',
          style: TextStyle(color: colors.primaryForeground),
        ),
      ),
    );
  }
}

