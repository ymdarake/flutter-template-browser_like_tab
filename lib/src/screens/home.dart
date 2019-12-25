import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final double topMargin = 20.0;
  final double adHeight = 60.0;

  List pages;
  void _initializePages() {
    if (pages != null) return;
    pages = [_buildTab(), _buildBottomSheet()];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initializePages();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello!'),
        elevation: 0,
        leading: Icon(
          Icons.menu,
          size: 30,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: PageView.builder(
        itemBuilder: (context, position) => pages[position],
        itemCount: pages.length,
        scrollDirection: Axis.vertical,
      ),
    );
  }

  Widget _buildTab() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: topMargin),
            decoration: BoxDecoration(
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
        ),
        _buildAd(),
      ],
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
    return BottomNavigationBar(
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
    );
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
