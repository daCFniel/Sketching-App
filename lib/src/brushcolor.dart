import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sketching_app/src/brush.dart';

// brush color picker dialog

class BrushColorPicker extends StatefulWidget {
  const BrushColorPicker({Key? key}) : super(key: key);

  @override
  State<BrushColorPicker> createState() => _BrushColorPickerState();
}

class _BrushColorPickerState extends State<BrushColorPicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Brush Color!',
        style: GoogleFonts.pacifico().copyWith(fontSize: 32),
        textAlign: TextAlign.center,
      ),
      content: Consumer<MyBrush>(
        builder: (context, brush, child) => SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: brush.brushColor,
            onColorChanged: (color) => brush.brushColor = color,
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.done_rounded,
              size: 32,
            ))
      ],
    );
  }
}
