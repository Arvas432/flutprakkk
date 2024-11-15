import 'package:flutprakkk/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  GetIt.I.allowReassignment = true;
  getIt.registerSingleton<IpFindService>(IpFindService(baseUrl: 'https://api.ipgeolocation.io/ipgeo', apiKey: '455322ed084f4554b56ceebebcf907ae'));
  // GetIt.I.registerSingleton(IpFindService(baseUrl: 'https://api.ipgeolocation.io/ipgeo', apiKey: '455322ed084f4554b56ceebebcf907ae'), instanceName: 'bobus');
  // GetIt.I.registerFactory(() => IpFindService(baseUrl: 'https://api.ipgeolocation.io/ipgeo', apiKey: '455322ed084f4554b56ceebebcf907ae'), instanceName: 'bebus');
}
class IpFindServiceProvider extends InheritedWidget {
  final IpFindService ipFindService;

  const IpFindServiceProvider({
    required this.ipFindService,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  static IpFindServiceProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<IpFindServiceProvider>();
  }

  @override
  bool updateShouldNotify(IpFindServiceProvider oldWidget) {
    return ipFindService != oldWidget.ipFindService;
  }
}