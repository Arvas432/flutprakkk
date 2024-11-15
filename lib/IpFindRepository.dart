import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dto.dart';

Future<IpInfo?> fetchIpInfoWithFuture(String ipAddress, String apiKey) {
  final url = Uri.parse('https://api.ipgeolocation.io/ipgeo?apiKey=$apiKey&ip=$ipAddress');
  return http.get(url).then((response) {
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return IpInfo.fromJson(data);
    } else {
      throw Exception('Failed to load IP info: ${response.statusCode}');
    }
  }).catchError((error) {
    print(error);
    return null;
  }).whenComplete(() {
    print("Request completed.");
  });
}

Future<IpInfo?> fetchIpInfoWithAsyncAwait(String ipAddress, String apiKey) async {
  final url = Uri.parse('https://api.ipgeolocation.io/ipgeo?apiKey=$apiKey&ip=$ipAddress');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return IpInfo.fromJson(data);
    } else {
      throw Exception('Failed to load IP info: ${response.statusCode}');
    }
  } catch (error) {
    print(error);
    return null;
  } finally {
    print("Request completed.");
  }
}

