import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sketching_app/src/brush.dart';

class ThicknessDialog extends StatefulWidget {
  const ThicknessDialog({Key? key}) : super(key: key);

  @override
  State<ThicknessDialog> createState() => _ThicknessDialogState();
}

class _ThicknessDialogState extends State<ThicknessDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Line Thickness!",
          style: GoogleFonts.pacifico().copyWith(fontSize: 32),
          textAlign: TextAlign.center),
      content: Consumer<MyBrush>(
        builder: (context, brush, child) => Slider.adaptive(
            value: brush.lineThickness,
            onChanged: (newValue) => brush.lineThickness = newValue,
            min: 1,
            max: 100,
            thumbColor: Colors.yellow, //_displayBrushColor,
            activeColor: Colors.yellow //_displayBrushColor,
            ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.done_rounded, size: 32))
      ],
    );
  }
}
