import 'package:flutter/material.dart';

class SearchHistoryWidget extends StatefulWidget {
  @override
  _SearchHistoryWidgetState createState() => _SearchHistoryWidgetState();
}

class _SearchHistoryWidgetState extends State<SearchHistoryWidget> {
  List<String> searchHistory = [
    '192.168.1.1/25',
    '192.168.1.2/25',
    '192.168.1.3/25',
    '192.168.1.4/25',
  ];

  void _addNewSearchEntry() {
    setState(() {
      searchHistory.insert(0, '192.168.1.${searchHistory.length + 1}/25');
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
                      onTap: () => _deleteSearchEntry(index), // Deletes the tapped entry
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE6E8EB),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(
                            searchHistory[index],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          trailing: Image.asset(
                            'assets/images/flag.png',
                            height: 24,
                            width: 24,
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

class SearchHistoryWidgetColumn extends StatefulWidget {
  @override
  _SearchHistoryWidgetStateColumn createState() => _SearchHistoryWidgetStateColumn();
}

class _SearchHistoryWidgetStateColumn extends State<SearchHistoryWidgetColumn> {
  List<String> searchHistory = [
    '192.168.1.1/25',
    '192.168.1.2/25',
    '192.168.1.3/25',
    '192.168.1.4/25',
  ];

  // Function to add a new entry at the start of the list
  void _addNewSearchEntry() {
    setState(() {
      searchHistory.insert(0, '192.168.1.${searchHistory.length + 1}/25');
    });
  }

  // Function to delete an entry from the list
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
              onPressed: _addNewSearchEntry, // Button adds a new entry to the list
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white, // Text color
              ),
              child: Text('Добавить элемент'),
            ),
            SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: searchHistory.asMap().entries.map((entry) {
                    int index = entry.key;
                    String ip = entry.value;

                    return GestureDetector(
                      onTap: () {
                        _deleteSearchEntry(index); // Delete the tapped item
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE6E8EB),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(
                              ip,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            trailing: Image.asset(
                              'assets/images/flag.png',
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchHistoryWidgetSeparated extends StatefulWidget {
  @override
  _SearchHistoryWidgetSeparatedState createState() => _SearchHistoryWidgetSeparatedState();
}

class _SearchHistoryWidgetSeparatedState extends State<SearchHistoryWidgetSeparated> {
  List<String> searchHistory = [
    '192.168.1.1/25',
    '192.168.1.2/25',
    '192.168.1.3/25',
    '192.168.1.4/25',
  ];

  // Function to add a new entry at the start of the list
  void _addNewSearchEntry() {
    setState(() {
      searchHistory.insert(0, '192.168.1.${searchHistory.length + 1}/25');
    });
  }

  // Function to delete an entry from the list
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
              onPressed: _addNewSearchEntry, // Button adds a new entry to the list
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white, // Text color
              ),
              child: Text('Добавить элемент'),
            ),
            SizedBox(height: 20),
            // ListView.separated for displaying list with separators
            Expanded(
              child: ListView.separated(
                itemCount: searchHistory.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _deleteSearchEntry(index); // Delete the tapped item
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE6E8EB),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(
                            searchHistory[index],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          trailing: Image.asset(
                            'assets/images/flag.png',
                            height: 24,
                            width: 24,
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