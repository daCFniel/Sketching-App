import 'dart:ui';
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
  // List of points for eraser
  final _erasedPoints = <SketchPoint>[];
  bool _isEraserMode = false;

  // Brush styling
  final double _strokeWidth = 45.0;
  final StrokeCap _strokeCap = StrokeCap.round;
  Color _currentBrushColor = Colors.deepOrange;
  Color _brushIconColor = Colors.white;

  //UI styling
  final double _bottomMenuHeight = 70.0;
  Color _currentBackgroundColor = Color(0xFFABCEEB);

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    // Change the color of brush icon depending on the current brush color
    if (TinyColor(_currentBrushColor).getBrightness() > 200) {
      _brushIconColor = Colors.black;
    } else {
      _brushIconColor = Colors.white;
    }

    return Scaffold(
      body: Container(
        color: _currentBackgroundColor,
        width: _width,
        height: _height,
        child: GestureDetector(
          onPanStart: (DragStartDetails details) {
            setState(() {
              if (_isEraserMode) {
                _erasedPoints.add(SketchPoint(
                    details.localPosition,
                    Paint()
                      ..strokeWidth = _strokeWidth
                      ..strokeCap = _strokeCap
                      ..color = _currentBackgroundColor));
              } else {
                _sketchPoints.add(SketchPoint(
                    details.localPosition,
                    Paint()
                      ..strokeWidth = _strokeWidth
                      ..strokeCap = _strokeCap
                      ..color = _currentBrushColor));
              }
            });
          },
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              if (_isEraserMode) {
                _erasedPoints.add(SketchPoint(
                    details.localPosition,
                    Paint()
                      ..strokeWidth = _strokeWidth
                      ..strokeCap = _strokeCap
                      ..color = _currentBackgroundColor));
              } else {
                _sketchPoints.add(SketchPoint(
                    details.localPosition,
                    Paint()
                      ..strokeWidth = _strokeWidth
                      ..strokeCap = _strokeCap
                      ..color = _currentBrushColor));
              }
            });
          },
          onPanEnd: (DragEndDetails details) {
            setState(() {
              _sketchPoints.add(null);
            });
          },
          child: CustomPaint(
            painter: MyPainter(_sketchPoints, _erasedPoints, _isEraserMode),
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
                  onPressed: () => showDialog(
                      context: context, builder: showColorPickerBackground),
                  icon: const Icon(Icons.palette_rounded)),
              IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.line_style_rounded)),
              IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.auto_fix_normal_rounded)),
              IconButton(
                  onPressed: () => _sketchPoints.clear(),
                  icon: const Icon(Icons.refresh_rounded))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showDialog(context: context, builder: showColorPickerBrush),
        child: const Icon(Icons.brush_rounded),
        backgroundColor: _currentBrushColor,
        foregroundColor: _brushIconColor,
        hoverColor: TinyColor(_currentBrushColor).brighten(10).color,
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
}
