import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/Profile/Profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../AppointmentHistory/AppointmentHistory.dart';
import '../Homepage/Homepage.dart';
import '../Discover/Discover.dart';

class Home extends StatefulWidget {
  Home({Key key, }) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Homepage(),
    AppointmentHistory(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void goToDiscover() {
    setState(() {
      _selectedIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Colors.green[700]),
        unselectedIconTheme: IconThemeData(color: Colors.grey.shade400),
        backgroundColor: Colors.white,
        elevation: 10.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new Icon(
              FontAwesomeIcons.solidComment,
              size: 24.0,
            ),
            label:'',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.bookMedical,
              size: 24.0,
            ),
            label:'',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.solidUserCircle,
              size: 24.0,
            ),
            label:'',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[700],
        onTap: _onItemTapped,
      ),
    );
  }
}