import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dto.dart';

class SearchHistoryEvent {}

class LoadSearchHistoryEvent extends SearchHistoryEvent {}

class AddSearchHistoryEvent extends SearchHistoryEvent {
  final IpInfo ipInfo;
  AddSearchHistoryEvent(this.ipInfo);
}

class SearchHistoryState {}

class SearchHistoryInitial extends SearchHistoryState {}

class SearchHistoryLoaded extends SearchHistoryState {
  final List<IpInfo> history;
  SearchHistoryLoaded(this.history);
}

class SearchHistoryBloc extends Bloc<SearchHistoryEvent, SearchHistoryState> {
  static const String _storageKey = 'search_history';

  SearchHistoryBloc() : super(SearchHistoryInitial()) {
    on<LoadSearchHistoryEvent>(_onLoadSearchHistory);
    on<AddSearchHistoryEvent>(_onAddSearchHistory);
  }

  Future<void> _onLoadSearchHistory(
      LoadSearchHistoryEvent event, Emitter<SearchHistoryState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_storageKey) ?? [];
    final history = historyJson
        .map((json) => IpInfo.fromJson(jsonDecode(json)))
        .toList();
    emit(SearchHistoryLoaded(history));
  }

  Future<void> _onAddSearchHistory(
      AddSearchHistoryEvent event, Emitter<SearchHistoryState> emit) async {
    if (state is SearchHistoryLoaded) {
      final currentState = state as SearchHistoryLoaded;
      final newHistory = [event.ipInfo, ...currentState.history];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          _storageKey, newHistory.map((ip) => jsonEncode(ip.toJson())).toList());
      emit(SearchHistoryLoaded(newHistory));
    }
  }
}

