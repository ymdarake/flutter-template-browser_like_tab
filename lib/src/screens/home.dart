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

  List<BrowserLikeTab> tabs; // 最初にTermの合計数を取得しておいて、それだけ空の箱を用意しておく?
  List pages;
  void _initializePages() {
    if (pages != null) return;
    pages = [_buildMain(), _buildBottomSheet()];
  }

  void _initializeTabs() {
    if (tabs != null) return;
    tabs = [
      BrowserLikeTab(),
      BrowserLikeTab(),
      BrowserLikeTab(),
    ];
    // TODO: cannot mutate (these widgets are immutable)
    // for (var i = 0; i < tabs.length; ++i) {
    //   final tab = tabs[i];
    //   tab.onTopBarTap = () {
    //     currentIndex = i;
    //     tabs.forEach((t) {
    //       t.goToSurfaceOrHide();
    //     });
    //   };
    //   tab.onDraggedDown = () {
    //     tabs.forEach((t) {
    //       t.goToDraggDownPosition();
    //     });
    //   };
    // }
  }

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
    _initializeTabs();
    _initializePages();

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
        itemBuilder: (context, position) => pages[position],
        itemCount: pages.length,
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
            children: tabs,
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
}

class BrowserLikeTab extends StatefulWidget {
  final void Function() onTopBarTap;
  final void Function() onDragDown;
  final int index;

  BrowserLikeTab({this.onTopBarTap, this.onDragDown, this.index});

  @override
  _BrowserLikeTabState createState() => _BrowserLikeTabState();
}

class _BrowserLikeTabState extends State<BrowserLikeTab>
    with SingleTickerProviderStateMixin {
  Animation<double> tabListAnimation;
  AnimationController tabListAnimationController;
  double dragDeltaY = 0.0;

  // DEBUG:
  List<Color> colors = [Colors.white, Colors.white70, Colors.white30];

  @override
  void initState() {
    super.initState();
    tabListAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    tabListAnimation =
        Tween(begin: 0.0, end: tabDistance).animate(tabListAnimationController);
  }

// must be wrapped by Stack
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tabListAnimation,
      builder: (context, child) {
        return Positioned(
          top: _getTabTopPosition(currentIndex),
          bottom: _getTabBottomPosition(currentIndex),
          child: child,
        );
      },
      child: _buildTabContent(context),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(27.0),
          topRight: Radius.circular(27.0),
        ),
        boxShadow: _buildTabShadow(),
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentIndex = widget.index;
              widget.onTopBarTap();
            }, // update currentIndex and notify all children
            onVerticalDragUpdate: (DragUpdateDetails details) {
              dragDeltaY += details.delta.dy;
              if (dragDeltaY < 10.0) return;
              dragDeltaY = 0.0;
              currentIndex = -1;
              widget.onDragDown();
            },
            child: Container(
              height: 60,
              child: Text('Drag Area'),
              color: Colors.grey,
            ),
          ),
          Text('Hi!'),
          Text('Hi!'),
          Text('Hi!'),
        ],
      ),
    );
  }

  double _getTabTopPosition(int currentIndex) {
    if (widget.index == currentIndex) return 0.0;
    return tabListAnimation.value - tabDistance + (widget.index * tabDistance);
  }

  double _getTabBottomPosition(int currentIndex) {
    if (widget.index == currentIndex) return 0.0;
    return -tabListAnimation.value - tabDistance + (widget.index * tabDistance);
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

  // interface
  void goToSurfaceOrHide() {
    if (widget.index < currentIndex) return;
    tabListAnimationController.reverse();
  }

  // interface
  void goToDraggDownPosition() {
    if (widget.index < currentIndex) return;
    tabListAnimationController.reverse();
  }
}
