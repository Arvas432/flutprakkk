import 'package:flutprakkk/di.dart';
import 'package:flutprakkk/searchHistory.dart';
import 'package:flutprakkk/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';

import 'dto.dart';
import 'mainScreen.dart';

void main() {
  setup();
  final ipFindService = IpFindService(
    baseUrl: 'https://api.ipgeolocation.io/ipgeo',
    apiKey: '455322ed084f4554b56ceebebcf907ae',
  );
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  GetIt.I.isRegistered<IpFindService>(instanceName: 'bebus');
  runApp(IpFindServiceProvider(ipFindService: ipFindService, child: MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'IPfinderr',
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/main',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/main',
            builder: (context, state) => IPInfoLayout(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => SettingsScreen(),
          ),
          GoRoute(
            path: '/searchHistory',
            builder: (context, state) => SearchHistoryWidget(),
          ),

        ],
      ),
    ],
  );
}

class ScaffoldWithNavigation extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavigation({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/main');
              break;
            case 1:
              context.go('/searchHistory');
              break;
            case 2:
              context.go('/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Search History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),

        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouter.of(context).location;
    if (location.startsWith('/main')) {
      return 0;
    } else if (location.startsWith('/searchHistory')) {
      return 1;
    } else {
      return 2;
    }
  }
}



class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enable thing',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Switch(value: false, onChanged: (bool value) {  },

            ),
          ],
        ),
      ),
    );
  }
}

class AdditionalInfoScreen extends StatelessWidget {
  final IpInfo ipInfo;

  AdditionalInfoScreen({required this.ipInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация об IP'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            InformationTile(title: 'IP Address', value: ipInfo.ip),
            InformationTile(title: 'Hostname', value: ipInfo.hostname),
            InformationTile(title: 'Continent Code', value: ipInfo.continentCode),
            InformationTile(title: 'Continent Name', value: ipInfo.continentName),
            InformationTile(title: 'Country Code', value: ipInfo.countryCode2),
            InformationTile(title: 'Country Name', value: ipInfo.countryName),
            InformationTile(title: 'State/Province', value: ipInfo.stateProv),
            InformationTile(title: 'City', value: ipInfo.city),
            InformationTile(title: 'Zipcode', value: ipInfo.zipcode),
            InformationTile(title: 'Latitude', value: ipInfo.latitude.toString()),
            InformationTile(title: 'Longitude', value: ipInfo.longitude.toString()),
            InformationTile(title: 'ISP', value: ipInfo.isp),
            InformationTile(title: 'Organization', value: ipInfo.organization),
            InformationTile(title: 'Currency Code', value: ipInfo.currencyCode),
            InformationTile(title: 'Currency Name', value: ipInfo.currencyName),
            InformationTile(title: 'Time Zone Name', value: ipInfo.timeZoneName),
            InformationTile(title: 'Current Time', value: ipInfo.currentTime),
          ],
        ),
      ),
    );
  }
}

class MapsScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapsScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: Stack(
        children: [
          // Псевдокарта
          Positioned.fill(
            child: Container(
              color: Colors.grey[300],
            ),
          ),
          // Метка
          Positioned(
            left: longitudeToPosition(longitude, MediaQuery
                .of(context)
                .size
                .width),
            top: latitudeToPosition(latitude, MediaQuery
                .of(context)
                .size
                .height),
            child: Icon(
              Icons.location_on,
              size: 40,
              color: Colors.red,
            ),
          ),
          // Информация о координатах
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                InformationTile(
                  title: 'Latitude',
                  value: latitude.toString(),
                ),
                SizedBox(height: 8),
                InformationTile(
                  title: 'Longitude',
                  value: longitude.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  double latitudeToPosition(double latitude, double screenHeight) {
    const minLatitude = -90.0;
    const maxLatitude = 90.0;
    return (latitude - minLatitude) / (maxLatitude - minLatitude) * screenHeight;
  }

  double longitudeToPosition(double longitude, double screenWidth) {
    const minLongitude = -180.0;
    const maxLongitude = 180.0;
    return (longitude - minLongitude) / (maxLongitude - minLongitude) * screenWidth;
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



