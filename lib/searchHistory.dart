import 'package:flutprakkk/searchHistoryBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';


class SearchHistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchHistoryBloc()..add(LoadSearchHistoryEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('История запросов'),
        ),
        body: BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
          builder: (context, state) {
            if (state is SearchHistoryLoaded) {
              final history = state.history;

              return ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final ipInfo = history[index];
                  return ListTile(
                    title: Text(ipInfo.ip),
                    subtitle: Text(ipInfo.city),
                    leading: CachedNetworkImage(
                      imageUrl: ipInfo.countryFlag,
                      height: 24,
                      width: 24,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
              );
            } else if (state is SearchHistoryInitial) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text('Ошибка загрузки истории'));
            }
          },
        ),
      ),
    );
  }
}
