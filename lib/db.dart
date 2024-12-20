import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dto.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ip_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          ip TEXT NOT NULL,
          hostname TEXT,
          continentCode TEXT,
          continentName TEXT,
          countryCode2 TEXT,
          countryName TEXT,
          stateProv TEXT,
          city TEXT,
          zipcode TEXT,
          latitude REAL,
          longitude REAL,
          isp TEXT,
          organization TEXT,
          currencyCode TEXT,
          currencyName TEXT,
          timeZoneName TEXT,
          currentTime TEXT,
          countryFlag TEXT,
          timestamp TEXT
        )
      ''');
      },
    );
  }


  Future<void> insertIpInfo(IpInfo ipInfo) async {
    final db = await database;
    await db.insert('history', {
      'ip': ipInfo.ip,
      'hostname': ipInfo.hostname,
      'continentCode': ipInfo.continentCode,
      'continentName': ipInfo.continentName,
      'countryCode2': ipInfo.countryCode2,
      'countryName': ipInfo.countryName,
      'stateProv': ipInfo.stateProv,
      'city': ipInfo.city,
      'zipcode': ipInfo.zipcode,
      'latitude': ipInfo.latitude,
      'longitude': ipInfo.longitude,
      'isp': ipInfo.isp,
      'organization': ipInfo.organization,
      'currencyCode': ipInfo.currencyCode,
      'currencyName': ipInfo.currencyName,
      'timeZoneName': ipInfo.timeZoneName,
      'currentTime': ipInfo.currentTime,
      'countryFlag': ipInfo.countryFlag,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }


  Future<List<Map<String, dynamic>>> fetchHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'timestamp DESC');
  }
}
