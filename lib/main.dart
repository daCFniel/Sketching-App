import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:sketching_app/painter.dart';
import 'package:sketching_app/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinycolor2/tinycolor2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sketching App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Screen dimensions
  late double _width;
  late double _height;

  // List of points
  final _sketchPoints = <SketchPoint?>[];

  // Brush styling
  double _strokeWidth = 20.0;
  final StrokeCap _strokeCap = StrokeCap.round;
  Color _currentBrushColor = Colors.deepOrange;
  Color _displayBrushColor = Colors.deepOrange;
  Color _brushIconColor = Colors.white;

  // Eraser
  Color _eraserIconColor = Colors.black;
  bool _isEraserMode = false;

  //UI styling
  final double _bottomMenuHeight = 70.0;
  Color _currentBackgroundColor = const Color(0xFFABCEEB);

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    // Change the color of brush icon depending on the current brush color
    if (TinyColor(_displayBrushColor).getBrightness() > 200) {
      _brushIconColor = Colors.black;
    } else {
      _brushIconColor = Colors.white;
    }
    // Swap between brush/eraser icon on main button
    if (_isEraserMode) {
      _eraserIconColor = Colors.deepOrange;
      if (_currentBrushColor != _currentBackgroundColor) {
        _currentBrushColor = _currentBackgroundColor;
      }
    } else {
      _eraserIconColor = Colors.black;
      if (_currentBrushColor != _currentBackgroundColor) {
        _displayBrushColor = _currentBrushColor;
      } else {
        _currentBrushColor = _displayBrushColor;
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:
          AppBar(backgroundColor: Colors.transparent, elevation: 0.0, actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const MainPage())),
          child: const Icon(Icons.add),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  TinyColor(Colors.grey).setOpacity(0.1).color),
              elevation: MaterialStateProperty.all(0.0),
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))))),
        )
      ]),
      body: Container(
        color: _currentBackgroundColor,
        width: _width,
        height: _height,
        child: GestureDetector(
          onPanStart: (DragStartDetails details) {
            setState(() {
              _sketchPoints.add(SketchPoint(
                  details.localPosition,
                  Paint()
                    ..strokeWidth = _strokeWidth
                    ..strokeCap = _strokeCap
                    ..color = _currentBrushColor));
            });
          },
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              _sketchPoints.add(SketchPoint(
                  details.localPosition,
                  Paint()
                    ..strokeWidth = _strokeWidth
                    ..strokeCap = _strokeCap
                    ..color = _currentBrushColor));
            });
          },
          onPanEnd: (DragEndDetails details) {
            setState(() {
              _sketchPoints.add(null);
            });
          },
          child: CustomPaint(
            painter: MyPainter(_sketchPoints),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: _bottomMenuHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    if (_sketchPoints.isEmpty) {
                      showDialog(
                          context: context, builder: showColorPickerBackground);
                    } else {
                      showDialog(context: context, builder: showPopupDialog);
                    }
                  },
                  icon: const Icon(Icons.palette_rounded)),
              IconButton(
                  onPressed: () => showDialog(
                      context: context, builder: showLineThicknessDialog),
                  icon: const Icon(Icons.line_style_rounded)),
              IconButton(
                  color: _eraserIconColor,
                  onPressed: () => setState(() {
                        _isEraserMode = true;
                      }),
                  icon: const Icon(Icons.auto_fix_normal_rounded)),
              IconButton(
                  onPressed: () => _sketchPoints.clear(),
                  icon: const Icon(Icons.refresh_rounded)),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onLongPress: () =>
            showDialog(context: context, builder: showColorPickerBrush),
        child: FloatingActionButton(
          onPressed: () => setState(() {
            _isEraserMode = false;
          }),
          child: const Icon(Icons.brush_rounded),
          backgroundColor: _displayBrushColor,
          foregroundColor: _brushIconColor,
          hoverColor: TinyColor(_displayBrushColor).brighten(10).color,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // current brush color setter
  void changeColorBrush(Color color) {
    setState(() {
      _currentBrushColor = color;
    });
  }

  // current bg color setter
  void changeColorBackground(Color color) {
    setState(() {
      _currentBackgroundColor = color;
    });
  }

// brush color picker dialog
  Widget showColorPickerBrush(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Brush Color!',
        style: GoogleFonts.pacifico().copyWith(fontSize: 32),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
          child: MaterialPicker(
        pickerColor: _currentBrushColor,
        onColorChanged: changeColorBrush,
      )),
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

// bg color picker dialog
  Widget showColorPickerBackground(BuildContext context) {
    return AlertDialog(
      title: Text('Background color!',
          style: GoogleFonts.pacifico().copyWith(fontSize: 32),
          textAlign: TextAlign.center),
      content: SingleChildScrollView(
          child: ColorPicker(
        pickerColor: _currentBackgroundColor,
        onColorChanged: changeColorBackground,
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

  // pop up info dialog builder
  Widget showPopupDialog(BuildContext context) {
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

  // pop up info dialog builder
  Widget showLineThicknessDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Line Thickness!",
          style: GoogleFonts.pacifico().copyWith(fontSize: 32),
          textAlign: TextAlign.center),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Slider.adaptive(
          value: _strokeWidth,
          onChanged: (newValue) {
            setState(() => _strokeWidth = newValue);
          },
          min: 1,
          max: 100,
          thumbColor: _displayBrushColor,
          activeColor: _displayBrushColor,
        );
      }),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(_strokeWidth);
            },
            child: const Icon(Icons.done_rounded, size: 32))
      ],
    );
  }
}
