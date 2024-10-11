import 'package:flutprakkk/searchHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    IPInfoLayout(),
    SearchHistoryWidgetColumn(),
    SearchHistoryWidget(),
    SearchHistoryWidgetSeparated()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool get isDesktop {
    if (kIsWeb) return true;
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP Finder',
      home: Scaffold(
        body: Row(
          children: [
            if (isDesktop)
              NavigationRail(
                backgroundColor: Color(0xFFE6E8EB),
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: Icon(Icons.search),
                    selectedIcon: Icon(Icons.search),
                    label: Text('Поиск'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.history),
                    selectedIcon: Icon(Icons.history),
                    label: Text('История поиска'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.history),
                    selectedIcon: Icon(Icons.history),
                    label: Text('История поиска'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.history),
                    selectedIcon: Icon(Icons.history),
                    label: Text('История поиска'),
                  ),
                ],
              ),
            Expanded(
              child: Container(
                color: const Color(0xFFFAFAFA),
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ),
          ],
        ),
        bottomNavigationBar: isDesktop
            ? null
            : BottomNavigationBar(
          backgroundColor: Color(0xFFFAFAFA),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Color(0xFFFAFAFA),
              icon: Icon(Icons.search),
              label: 'Поиск',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFFFAFAFA),
              icon: Icon(Icons.history),
              label: 'История поиска',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFFFAFAFA),
              icon: Icon(Icons.history),
              label: 'История поиска',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'История поиска'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class IPInfoLayout extends StatefulWidget {
  const IPInfoLayout({super.key});

  @override
  _IPInfoLayoutState createState() => _IPInfoLayoutState();
}

class _IPInfoLayoutState extends State<IPInfoLayout> {
  String _currentFlag = 'assets/images/flag.png';
  String _countryName = 'Russian Federation';
  String _cityName = "Moscow";
  String _ipAddr = "192.168.1.1";
  String _provider = "MGTS";

  void _updateCountryInfo() {
    if (_countryName == 'Russian Federation') {
      setState(() {
        _currentFlag = 'assets/images/uk_flag.png';
        _countryName = 'United Kingdom';
        _cityName = "London";
        _ipAddr = "192.168.1.2";
        _provider = "Vodafone";
      });
    } else {
      setState(() {
        _currentFlag = 'assets/images/flag.png';
        _countryName = 'Russian Federation';
        _cityName = "Moscow";
        _ipAddr = "192.168.1.1";
        _provider = "MGTS";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Color(0xFFE6E8EB),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '192.168.1.1',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/images/world_map.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Center(
                      child: Image.asset(
                        _currentFlag,
                        fit: BoxFit.contain,
                        height: 150,
                        width: 225,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _countryName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          InformationTile(title: 'Страна', value: _countryName),
          InformationTile(title: 'Город', value: _cityName),
          InformationTile(title: 'Провайдер', value: _provider),
          InformationTile(title: 'Подсеть', value: _ipAddr),
          InformationTile(title: 'Широта', value: '77.245233'),
          InformationTile(title: 'Долгота', value: '32.234232'),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  iconPath: 'assets/icons/show_on_map_ic.svg',
                  label: 'Показать\nна карте',
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 10), // Space between buttons
              Expanded(
                child: ActionButton(
                  iconPath: 'assets/icons/more_data_ic.svg',
                  label: 'Полные\nданные',
                  onPressed: _updateCountryInfo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InformationTile extends StatelessWidget {
  final String title;
  final String value;

  InformationTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xFFE6E8EB),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16)),
            Text(value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onPressed;

  ActionButton(
      {required this.iconPath, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD4D4D4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(width: 24),
            SvgPicture.asset(
              iconPath,
              height: 50,
              width: 50,
            )
          ],
        ),
      ),
    );
  }
}
