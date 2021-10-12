import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sketching_app/src/brush.dart';

// bg color picker dialog

class BackgroundColorPicker extends StatefulWidget {
  final MyBrush? myBrush;

  const BackgroundColorPicker({Key? key, this.myBrush}) : super(key: key);

  @override
  State<BackgroundColorPicker> createState() => _BackgroundColorPickerState();
}

class _BackgroundColorPickerState extends State<BackgroundColorPicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Background color!',
          style: GoogleFonts.pacifico().copyWith(fontSize: 32),
          textAlign: TextAlign.center),
      content: SingleChildScrollView(
          child: ColorPicker(
        pickerColor: widget.myBrush!.backgroundColor,
        onColorChanged: (color) => setState(() {
          widget.myBrush!.backgroundColor = color;
        }),
        pickerAreaHeightPercent: 0.8,
        enableAlpha: false,
        showLabel: false,
        pickerAreaBorderRadius: BorderRadius.circular(10),
      )),
      actions: [
        TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Icon(Icons.done_rounded, size: 32))
      ],
    );
  }
}
