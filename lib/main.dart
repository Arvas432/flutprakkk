import 'package:flutprakkk/di.dart';
import 'package:flutprakkk/searchHistory.dart';
import 'package:flutprakkk/service.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'dart:io' show Platform;

import 'package:go_router/go_router.dart';

import 'mainScreen.dart';

void main() {
  setup();
  final ipFindService = IpFindService(
    baseUrl: 'https://api.ipgeolocation.io/ipgeo',
    apiKey: '455322ed084f4554b56ceebebcf907ae',
  );
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
            builder: (context, state) => SettingsFragment2(),
          ),
          GoRoute(
            path: '/searchHistory',
            builder: (context, state) => SearchHistoryWidget(),
          ),

        ],
      ),
      GoRoute(
        path: '/main/additionalInfo',
        builder: (context, state) => AdditionalInfoFragment(),
      ),
      GoRoute(
        path: '/main/mapsHost',
        builder: (context, state) => MapsHostFragment(),
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

class SettingsFragment2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Settings Fragment Placeholder'));
  }
}
class AdditionalInfoFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Additional Info Screen Placeholder'));
  }
}

class MapsHostFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Maps Host Screen Placeholder'));
  }
}



