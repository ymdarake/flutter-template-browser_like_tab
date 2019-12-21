import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Offset _offset = Offset.zero;
  double _elevation = 1.0;
  bool isTabListMode = true;
  int space = 20;
  List colors = [];

  @override
  Widget build(BuildContext context) {
    colors = [Theme.of(context).primaryColorDark, Theme.of(context).primaryColor, Theme.of(context).primaryColorLight];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: _getContent()),
    );
  }

  Widget _getContent() {
    return isTabListMode
        ? _buildTabList()
        : GestureDetector(
            child: Text("Hi"),
            onTap: () {
              setState(() {
                isTabListMode = !isTabListMode;
              });
            });
  }

  Widget _buildTabList() {
    return Stack(
      children: <Widget>[
        _buildCard(0),
        _buildCard(1),
        _buildCard(2)
      ],
    );
  }

  Widget _buildCard(int cardIndex) {
    return Positioned(
        top: math.max(
            20.0 + space * cardIndex, math.min(_offset.dy * (1 + 0.2 * cardIndex) + space * cardIndex, 60*(cardIndex+1.0))),
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails detail) {
            setState(() {
              _offset += detail.delta;
              _elevation = _offset.dy < 100 ? 1 : 0;
            });
          },
          onVerticalDragEnd: (DragEndDetails detail) {},
          onTap: () {
            setState(() {
              isTabListMode = !isTabListMode;
            });
          },
          child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0.01 * math.max(0, math.min(_offset.dy, 60))),
              child: Card(
                  elevation: 4 * (cardIndex + 2) * _elevation,
                  color: colors[cardIndex % colors.length],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: 240,
                    height: 300,
                  ))),
        ));
  }
}
