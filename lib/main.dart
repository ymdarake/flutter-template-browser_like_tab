import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Offset _offset = Offset(0, 20);
  double _opacity = 0.00;
  int space = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 0,
                child: Opacity(
                    opacity: _opacity,
                    child: Card(
                      elevation: 0,
                      color: Colors.red,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ))),
            Positioned(
                top: 20,
                child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(0.01 * math.max(0, math.min(_offset.dy, 60))),
                    child: Card(
                        elevation: 8,
                        color: Theme.of(context).primaryColorDark,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: 240,
                          height: 300,
                        )))),
            Positioned(
                top: math.max(20.0+space, math.min(_offset.dy * 1.2 + space, 120)),
                child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(0.01 * math.max(0, math.min(_offset.dy, 60))),
                    child: Card(
                        elevation: 12,
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: 240,
                          height: 300,
                        )))),
            Positioned(
                top: math.max(20.0+space*2, math.min(_offset.dy * 1.4 + space * 2, 180)),
                child: GestureDetector(
                  onVerticalDragDown: (DragDownDetails detail) {
                    print(detail.globalPosition.dy);
                  },
                  onVerticalDragUpdate: (DragUpdateDetails detail) {
                    print(detail.globalPosition.dy);
                    setState(() {
                      _offset += detail.delta;
                    });
                  },
                  onVerticalDragEnd: (DragEndDetails detail) {
                    print(detail.velocity);
                  },
                  onTap: () {
                    setState(() {
                      _opacity = _opacity == 0.00 ? 1.0 : 0.00;
                    });
                  },
                  child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(0.01 * math.max(0, math.min(_offset.dy, 60))),
                      child: Card(
                          elevation: 16,
                          color: Theme.of(context).primaryColorLight,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            width: 240,
                            height: 300,
                          ))),
                ))
          ],
        ),
      ),
    );
  }
}
