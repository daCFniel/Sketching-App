import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:sketching_app/classes.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyBrush(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sketching App',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  // Animation
  late ConfettiController _controller;

  // Screen dimensions
  late double _width;
  late double _height;

  // List of points
  final _sketchPoints = <SketchPoint?>[];

  // Brush styling
  final StrokeCap _strokeCap = StrokeCap.round;
  Color _displayBrushColor = Colors.deepOrange;
  Color _brushIconColor = Colors.white;
  Color _backgroundColor = const Color(0xFFABCEEB);

  // Eraser
  Color _eraserIconColor = Colors.black;
  bool _isEraserMode = false;

  //UI styling
  final double _bottomMenuHeight = 70.0;

  @override
  void initState() {
    super.initState();
    _controller =
        ConfettiController(duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      // if (_provider.brushColor != _backgroundColor) {
      //   _provider.brushColor = _backgroundColor;
      // }
    } else {
      _eraserIconColor = Colors.black;
      // if (_provider.brushColor != _backgroundColor) {
      //   _displayBrushColor = _provider.brushColor;
      // } else {
      //   _provider.brushColor = _displayBrushColor;
      // }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:
          AppBar(backgroundColor: Colors.transparent, elevation: 0.0, actions: [
        Tooltip(
          message: "New Page",
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(createRoute()),
            child: const Icon(Icons.add),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    TinyColor(Colors.grey).setOpacity(0.1).color),
                elevation: MaterialStateProperty.all(0.0),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))))),
          ),
        )
      ]),
      body: Consumer<MyBrush>(
        builder: (context, brush, child) => Container(
          color: _backgroundColor,
          width: _width,
          height: _height,
          child: GestureDetector(
            onPanStart: (DragStartDetails details) {
              setState(() {
                _sketchPoints.add(SketchPoint(
                    details.localPosition,
                    Paint()
                      ..strokeWidth = brush.lineThickness
                      ..strokeCap = _strokeCap
                      ..color = brush.brushColor));
              });
            },
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                _sketchPoints.add(SketchPoint(
                    details.localPosition,
                    Paint()
                      ..strokeWidth = brush.lineThickness
                      ..strokeCap = _strokeCap
                      ..color = brush.brushColor));
              });
            },
            onPanEnd: (DragEndDetails details) {
              setState(() {
                _sketchPoints.add(null);
              });
            },
            child: CustomPaint(
                painter: MyPainter(_sketchPoints),
                child: Align(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    confettiController: _controller,
                    blastDirectionality: BlastDirectionality.explosive,
                    numberOfParticles: 20,
                    minBlastForce: 20,
                    maxBlastForce: 30,
                    gravity: 0.5,
                    shouldLoop: false,
                  ),
                )),
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
                      context: context,
                      builder: showBackgroundColorPicker,
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => const MyDialog());
                  }
                },
                icon: const Icon(Icons.palette_rounded),
                tooltip: "Background Color",
              ),
              IconButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const ThicknessDialog()),
                icon: const Icon(Icons.line_style_rounded),
                tooltip: "Line Thickness",
              ),
              IconButton(
                color: _eraserIconColor,
                onPressed: () => setState(() {
                  _isEraserMode = true;
                }),
                icon: const Icon(Icons.auto_fix_normal_rounded),
                tooltip: "Rubber",
              ),
              IconButton(
                onPressed: () async {
                  await magicErase();
                  _controller.play();
                  setState(() {});
                },
                icon: const Icon(Icons.refresh_rounded),
                tooltip: "Reset",
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onLongPress: () => showDialog(
            context: context, builder: (context) => const BrushColorPicker()),
        child: Consumer<MyBrush>(
          builder: (context, brush, child) => FloatingActionButton(
            onPressed: () => setState(() {
              _isEraserMode = false;
            }),
            child: const Icon(Icons.brush_rounded),
            backgroundColor: brush.brushColor,
            foregroundColor: _brushIconColor,
            hoverColor: TinyColor(_displayBrushColor).brighten(10).color,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> magicErase() async {
    for (int i = _sketchPoints.length - 1; i >= 0; i--) {
      setState(() {
        _sketchPoints.removeAt(i);
      });
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }

  // bg color picker dialog
  Widget showBackgroundColorPicker(BuildContext context) {
    return AlertDialog(
      title: Text('Background color!',
          style: GoogleFonts.pacifico().copyWith(fontSize: 32),
          textAlign: TextAlign.center),
      content: SingleChildScrollView(
          child: ColorPicker(
        pickerColor: _backgroundColor,
        onColorChanged: (color) => setState(() {
          _backgroundColor = color;
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
