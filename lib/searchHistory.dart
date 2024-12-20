import 'package:flutprakkk/searchHistoryBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchHistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchHistoryBloc()..add(LoadSearchHistory()),
      child: Scaffold(
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
                onPressed: () {
                  final ip = '192.168.1.${DateTime.now().second}';
                  final flagUrl = 'https://ipgeolocation.io/static/flags/us_64.png';
                  context
                      .read<SearchHistoryBloc>()
                      .add(AddSearchHistory(ip: ip, flagUrl: flagUrl));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: Text('Добавить элемент'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
                  builder: (context, state) {
                    if (state is SearchHistoryLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is SearchHistoryLoaded) {
                      final history = state.history;
                      return ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final entry = history[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                context
                                    .read<SearchHistoryBloc>()
                                    .add(DeleteSearchHistory(id: entry['id']));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFE6E8EB),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ListTile(
                                  title: Text(
                                    entry['ip']!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: CachedNetworkImage(
                                    imageUrl: entry['countryFlag']!,
                                    height: 24,
                                    width: 24,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error, color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is SearchHistoryError) {
                      return Center(child: Text('Ошибка: ${state.message}'));
                    }
                    return Center(child: Text('Нет данных'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

