import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchHistoryWidget extends StatefulWidget {
  @override
  _SearchHistoryWidgetState createState() => _SearchHistoryWidgetState();
}

class _SearchHistoryWidgetState extends State<SearchHistoryWidget> {
  List<Map<String, String>> searchHistory = [
    {'ip': '192.168.1.1/25', 'flagUrl': 'https://ipgeolocation.io/static/flags/cn_64.png'},
    {'ip': '192.168.1.2/25', 'flagUrl': 'https://ipgeolocation.io/static/flags/de_64.png'},
    {'ip': '192.168.1.3/25', 'flagUrl': 'https://ipgeolocation.io/static/flags/us_64.png'},
    {'ip': '192.168.1.4/25', 'flagUrl': 'https://ipgeolocation.io/static/flags/jp_64.png'},
    {'ip': '192.168.1.4/25', 'flagUrl': 'https://ipgeolocation.io/static/flags/kr_64.png'}
  ];

  void _addNewSearchEntry() {
    setState(() {
      searchHistory.insert(
        0,
        {'ip': '192.168.1.${searchHistory.length + 1}/25', 'flagUrl': 'https://ipgeolocation.io/static/flags/us_64.png'},
      );
    });
  }

  void _deleteSearchEntry(int index) {
    setState(() {
      searchHistory.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        title: Text('История запросов'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addNewSearchEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
              child: Text('Добавить элемент'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
                      onTap: () => _deleteSearchEntry(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE6E8EB),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(
                            searchHistory[index]['ip']!,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          trailing: CachedNetworkImage(
                            imageUrl: searchHistory[index]['flagUrl']!,
                            height: 24,
                            width: 24,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
