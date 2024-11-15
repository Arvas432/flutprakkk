import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'dto.dart';
import 'package:http/http.dart' as http;

class IpFindService {
  final String baseUrl;
  final String apiKey;

  IpFindService({required this.baseUrl, required this.apiKey});

  Future<IpInfo?> fetchIpInfoWithFuture(String ipAddress) {
    final url = Uri.parse('$baseUrl?apiKey=$apiKey&ip=$ipAddress');
    return http.get(url).then((response) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return IpInfo.fromJson(data);
      } else {
        throw Exception('Failed to load IP info: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error fetching IP info with Future: $error');
      return null;
    }).whenComplete(() {
      print("Request completed.");
    });
  }

  Future<IpInfo?> fetchIpInfoWithAsyncAwait(String ipAddress) async {
    final url = Uri.parse('$baseUrl?apiKey=$apiKey&ip=$ipAddress');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return IpInfo.fromJson(data);
      } else {
        throw Exception('Failed to load IP info: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching IP info with async/await: $error');
      return null;
    } finally {
      print("Request completed.");
    }
  }
}



class SearchHistoryProvider extends InheritedWidget {
  final List<IpInfo> ipInfoList;

  const SearchHistoryProvider({
    required this.ipInfoList,
    required Widget child,
  }) : super(child: child);

  static SearchHistoryProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SearchHistoryProvider>();
  }

  @override
  bool updateShouldNotify(SearchHistoryProvider oldWidget) => ipInfoList != oldWidget.ipInfoList;
}