import 'dart:ui';
import 'package:sketching_app/painter.dart';
import 'package:sketching_app/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
  late double _width;
  late double _height;
  final _sketchPoints = <SketchPoint?>[];

  // Brush styling
  final double _strokeWidth = 45.0;
  final StrokeCap _strokeCap = StrokeCap.round;
  Color _currentBrushColor = Colors.amber;

  //UI styling
  final double _bottomMenuHeight = 70.0;
  Color _currentBackgroundColor = Colors.blue.shade400;

  // currentColor setter
  void changeColorBrush(Color color) {
    setState(() {
      _currentBrushColor = color;
    });
  }

  void changeColorBackground(Color color) {
    setState(() {
      _currentBackgroundColor = color;
    });
  }

  Widget showColorPickerBrush(BuildContext context) {
    return AlertDialog(
      title: const Text('Brush color!'),
      content: SingleChildScrollView(
          child: ColorPicker(
        pickerColor: _currentBrushColor,
        onColorChanged: changeColorBrush,
        showLabel: true,
        pickerAreaHeightPercent: 0.8,
      )),
      actions: [
        TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Done'))
      ],
    );
  }

  Widget showColorPickerBackground(BuildContext context) {
    return AlertDialog(
      title: const Text('Background coslor!'),
      content: SingleChildScrollView(
          child: ColorPicker(
        pickerColor: _currentBackgroundColor,
        onColorChanged: changeColorBackground,
        showLabel: true,
        pickerAreaHeightPercent: 0.8,
      )),
      actions: [
        TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Done'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
