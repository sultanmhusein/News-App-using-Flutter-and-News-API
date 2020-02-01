import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'pages/aboutPage.dart';
import 'pages/headlinesPage.dart';
import 'pages/listNewsPage.dart';
import 'pages/localPage.dart';
import 'pages/otherPage.dart';

void main() => runApp(MaterialApp(home: BottomNavBar()));

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int pageIndex = 0;

  //Create All Pages
  final AboutPage _about = AboutPage();
  final HeadlinesPage _headlines = HeadlinesPage();
  final SourceScreen _listNews = SourceScreen();
  final LocalPage _local = LocalPage();
  final OtherPage _other = OtherPage();

  Widget _showPage = new SourceScreen();

  Widget _pageChooser(int page){
    switch (page){
      case 0: return _listNews;   break;
      case 1: return _headlines;  break;
      case 2: return _local;      break;
      case 3: return _other;      break;
      case 4: return _about;      break;
      default:
        return new Container(
          child: new Center(
            child: new Text('Page not Found 404', style: new TextStyle(fontSize: 30),
          ),
        )
      );
    }
  }


  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: pageIndex,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.list, size: 30),
          Icon(Icons.whatshot, size: 30),
          Icon(Icons.compare_arrows, size: 30),
          Icon(Icons.call_split, size: 30),
          Icon(Icons.perm_identity, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (int tappedIndex) {
            setState(() {
              _showPage = _pageChooser(tappedIndex);
            });
          },
      ), //Curved NavigationBar
      body: Container(
        color: Colors.blueAccent,
        child: Center(
          child: _showPage,
        ),
      ));
  }
}