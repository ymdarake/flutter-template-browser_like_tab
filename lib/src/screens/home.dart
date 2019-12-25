import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Animation<double> tabAnimation;
  Animation<double> adAnimation;
  Animation<double> bottomSheetAnimation;
  AnimationController tabAnimationController;
  final double bottomSheetHeight = 500.0; // TODO: preferable: calc dynamically
  final double adHeight = 60.0;
  final double appBarHeight = 32.0;

  @override
  void initState() {
    super.initState();
    tabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    tabAnimation = Tween(begin: 0.0, end: -bottomSheetHeight).animate(
      CurvedAnimation(
        curve: Curves.easeInOut,
        parent: tabAnimationController,
      ),
    );
    adAnimation = Tween(begin: 0.0, end: bottomSheetHeight).animate(
      CurvedAnimation(
        curve: Curves.easeInOut,
        parent: tabAnimationController,
      ),
    );
    bottomSheetAnimation =
        Tween(begin: -adHeight - bottomSheetHeight, end: 0.0).animate(
      CurvedAnimation(
        curve: Curves.easeInOut,
        parent: tabAnimationController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: _buildTab(),
    );
  }

  Widget _buildTab() {
    return GestureDetector(
      onVerticalDragDown: null,
      onVerticalDragUpdate: _handleDragUpdate,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          _buildTabAnimation(),
          _buildAdAnimation(),
          _buildBottomSheetAnimation(),
        ],
      ),
    );
  }

  Widget _buildTabAnimation() {
    return AnimatedBuilder(
      animation: tabAnimation,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height:
            MediaQuery.of(context).size.height - 30 - appBarHeight - adHeight,
        margin: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          boxShadow: _buildTabShadow(),
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(27.0),
            topRight: Radius.circular(27.0),
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Text('hoi!'),
              Text('hoi!'),
              Text('hoi!'),
            ],
          ),
        ),
      ),
      builder: (context, child) {
        return Positioned(
          top: tabAnimation.value,
          child: child,
        );
      },
    );
  }

  Widget _buildAdAnimation() {
    return AnimatedBuilder(
      animation: adAnimation,
      child: Container(
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
      ),
      builder: (context, child) {
        return Positioned(
          bottom: adAnimation.value,
          child: child,
        );
      },
    );
  }

  Widget _buildBottomSheetAnimation() {
    return AnimatedBuilder(
      animation: bottomSheetAnimation,
      child: Container(
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
      ),
      builder: (context, child) {
        return Positioned(
          bottom: bottomSheetAnimation.value,
          child: child,
        );
      },
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
}
