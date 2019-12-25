import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Animation<double> tabAnimation;
  AnimationController tabAnimationController;
  final double toolbarHeight = 20.0; // TODO: calc.
  final double topMargin = 20.0;
  final double adHeight = 60.0;
  double bottomSheetHeight;
  final double appBarHeight = 32.0;
  final double bottomNavigationBarHeight = 60.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initializeAnimation();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title: Text('Hello!'),
          elevation: 0,
          leading: Icon(
            Icons.menu,
            size: 30,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: _buildTab(),
    );
  }

  Widget _buildTab() {
    return GestureDetector(
        onVerticalDragDown: null,
        onVerticalDragUpdate: _handleDragUpdate,
        child: Stack(
          children: <Widget>[
            _buildTabAnimation(),
          ],
        ));
  }

  Widget _buildTabAnimation() {
    return AnimatedBuilder(
      animation: tabAnimation,
      builder: (context, child) {
        return Positioned(
          top: tabAnimation.value,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height -
                    toolbarHeight -
                    topMargin -
                    adHeight -
                    appBarHeight -
                    bottomNavigationBarHeight,
                margin: EdgeInsets.only(top: topMargin),
                decoration: BoxDecoration(
                  boxShadow: _buildTabShadow(),
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(27.0),
                    topRight: Radius.circular(27.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Text('Hi!'),
                    Text('Hi!'),
                    Text('Hi!'),
                  ],
                ),
              ),
              _buildAd(),
              _buildBottomSheet(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAd() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: adHeight,
      decoration: BoxDecoration(
        color: Colors.green,
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Text('Ad!'),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: bottomSheetHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Text('bottom'),
            Text('bottom'),
            Text('bottom'),
            Text('bottom'),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SizedBox(
      height: bottomNavigationBarHeight,
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Calendar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Caht'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }

  _handleDragUpdate(DragUpdateDetails details) {
    if (details.delta.dy < 0) {
      tabAnimationController.forward();
    } else {
      tabAnimationController.reverse();
    }
  }

  List<BoxShadow> _buildTabShadow() {
    return <BoxShadow>[
      BoxShadow(
        color: Colors.grey[600],
        blurRadius: 1.5, // soften the shadow
        spreadRadius: 1.0, //extend the shadow
        offset: Offset(
          0, // Move to right horizontally
          0, // Move to bottom Vertically
        ),
      ),
    ];
  }

  _initializeAnimation() {
    if (tabAnimation != null) return;

    bottomSheetHeight = MediaQuery.of(context).size.height;
    tabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    tabAnimation = Tween(
            begin: 0.0,
            end: -bottomSheetHeight +
                adHeight +
                appBarHeight +
                toolbarHeight +
                topMargin)
        .animate(
      CurvedAnimation(
        curve: Curves.easeInOut,
        parent: tabAnimationController,
      ),
    );
  }
}
