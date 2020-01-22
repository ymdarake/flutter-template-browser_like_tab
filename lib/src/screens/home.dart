import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

const double tabDistance = 60.0;
int currentIndex = 0;

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final double adHeight = 60.0;
  PageController pageController = PageController();
  Animation<double> iconAnimation;
  AnimationController iconAnimationController;

  bool isTimetableVisible = true;

  List tabs; // 最初にTermの合計数を取得しておいて、それだけ空の箱を用意しておく?

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    iconAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    iconAnimation =
        Tween(begin: 0.0, end: 1.0).animate(iconAnimationController);
  }

  @override
  void dispose() {
    pageController.dispose();
    iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello!'),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            var nextPage = pageController.page == 0.0 ? 1 : 0;
            nextPage == 0
                ? iconAnimationController.reverse()
                : iconAnimationController.forward();
            pageController.animateToPage(
              nextPage,
              curve: Curves.easeIn,
              duration: Duration(
                milliseconds: 800,
              ),
            );
          },
          child: AnimatedIcon(
            progress: iconAnimation,
            icon: AnimatedIcons.menu_close,
            size: 30,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: PageView.builder(
        onPageChanged: (int page) {
          page == 0
              ? iconAnimationController.reverse()
              : iconAnimationController.forward();
        },
        controller: pageController,
        itemBuilder: (context, position) =>
            [_buildMain(), _buildBottomSheet()][position],
        itemCount: 2,
        scrollDirection: Axis.vertical,
      ),
    );
  }

  Widget _buildMain() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            overflow: Overflow.visible,
            children: [
              _buildTermHeadersSheet(),
              AnimatedPositioned(
                top: isTimetableVisible ? 0 : 600,
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeIn,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isTimetableVisible = !isTimetableVisible;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height - adHeight,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color:
                            isTimetableVisible ? Colors.white : Colors.purple),
                    child: Center(child: Text("時間割表")),
                  ),
                ),
              ),
            ],
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

  Widget _buildTermHeadersSheet() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeIn,
      top: isTimetableVisible ? 600 : 0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isTimetableVisible = !isTimetableVisible;
          });
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.amber),
          child: Column(
            children: <Widget>[
              Text('学期1'),
              Text('学期2'),
              Text('学期3'),
              Text('学期4'),
              Text('学期5'),
              Text('学期6'),
            ],
          ),
        ),
      ),
    );
  }
}
