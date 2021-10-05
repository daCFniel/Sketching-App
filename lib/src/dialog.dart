import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.info_rounded),
          const SizedBox(
            width: 10,
          ),
          Text(
            "Can't change color",
            style: GoogleFonts.itim().copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text("Canvas must be empty", style: GoogleFonts.itim()),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
