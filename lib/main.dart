import 'dart:ui';
import 'package:sketching_app/painter.dart';
import 'package:sketching_app/point.dart';
import 'package:flutter/material.dart';

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
  final Color _color = Colors.amber;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.blue[400],
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
                    ..color = _color));
            });
          },
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              _sketchPoints.add(SketchPoint(
                  details.localPosition,
                  Paint()
                    ..strokeWidth = _strokeWidth
                    ..strokeCap = _strokeCap
                    ..color = _color));
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
          height: 100.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () => {}, icon: const Icon(Icons.menu)),
              IconButton(onPressed: () => {}, icon: const Icon(Icons.face)),
              IconButton(onPressed: () => {}, icon: const Icon(Icons.nat)),
              IconButton(onPressed: () => {}, icon: const Icon(Icons.kayaking))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(Icons.brush_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
