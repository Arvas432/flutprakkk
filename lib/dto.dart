import 'package:flutter/cupertino.dart';

import 'dart:convert';

class IpInfo {
  final String ip;
  final String hostname;
  final String continentCode;
  final String continentName;
  final String countryCode2;
  final String countryName;
  final String stateProv;
  final String city;
  final String zipcode;
  final double latitude;
  final double longitude;
  final String isp;
  final String organization;
  final String currencyCode;
  final String currencyName;
  final String timeZoneName;
  final String currentTime;
  final String countryFlag;

  IpInfo({
    required this.ip,
    required this.hostname,
    required this.continentCode,
    required this.continentName,
    required this.countryCode2,
    required this.countryName,
    required this.stateProv,
    required this.city,
    required this.zipcode,
    required this.latitude,
    required this.longitude,
    required this.isp,
    required this.organization,
    required this.currencyCode,
    required this.currencyName,
    required this.timeZoneName,
    required this.currentTime,
    required this.countryFlag,
  });

  Map<String, dynamic> toJson() => {
    'ip': ip,
    'hostname': hostname,
    'continentCode': continentCode,
    'continentName': continentName,
    'countryCode2': countryCode2,
    'countryName': countryName,
    'stateProv': stateProv,
    'city': city,
    'zipcode': zipcode,
    'latitude': latitude,
    'longitude': longitude,
    'isp': isp,
    'organization': organization,
    'currencyCode': currencyCode,
    'currencyName': currencyName,
    'timeZoneName': timeZoneName,
    'currentTime': currentTime,
    'countryFlag': countryFlag,
  };

  factory IpInfo.fromJson(Map<String, dynamic> json) => IpInfo(
    ip: json['ip'],
    hostname: json['hostname'],
    continentCode: json['continentCode'],
    continentName: json['continentName'],
    countryCode2: json['countryCode2'],
    countryName: json['countryName'],
    stateProv: json['stateProv'],
    city: json['city'],
    zipcode: json['zipcode'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    isp: json['isp'],
    organization: json['organization'],
    currencyCode: json['currencyCode'],
    currencyName: json['currencyName'],
    timeZoneName: json['timeZoneName'],
    currentTime: json['currentTime'],
    countryFlag: json['countryFlag'],
  );
}



