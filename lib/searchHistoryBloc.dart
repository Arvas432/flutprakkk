import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class SearchHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSearchHistory extends SearchHistoryEvent {}

class AddSearchHistory extends SearchHistoryEvent {
  final String ip;
  final String flagUrl;

  AddSearchHistory({required this.ip, required this.flagUrl});

  @override
  List<Object?> get props => [ip, flagUrl];
}

class DeleteSearchHistory extends SearchHistoryEvent {
  final int id;

  DeleteSearchHistory({required this.id});

  @override
  List<Object?> get props => [id];
}

abstract class SearchHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchHistoryInitial extends SearchHistoryState {}

class SearchHistoryLoading extends SearchHistoryState {}

class SearchHistoryLoaded extends SearchHistoryState {
  final List<Map<String, dynamic>> history;

  SearchHistoryLoaded({required this.history});

  @override
  List<Object?> get props => [history];
}

class SearchHistoryError extends SearchHistoryState {
  final String message;

  SearchHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SearchHistoryBloc extends Bloc<SearchHistoryEvent, SearchHistoryState> {
  Database? _database;

  SearchHistoryBloc() : super(SearchHistoryInitial()) {
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<AddSearchHistory>(_onAddSearchHistory);
    on<DeleteSearchHistory>(_onDeleteSearchHistory);
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ip_history.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ip TEXT NOT NULL,
            countryFlag TEXT
          )
        ''');
      },
    );
  }

  Future<void> _onLoadSearchHistory(
      LoadSearchHistory event, Emitter<SearchHistoryState> emit) async {
    try {
      emit(SearchHistoryLoading());
      if (_database == null) return;
      final history = await _database!.query('history', orderBy: 'id DESC');
      emit(SearchHistoryLoaded(history: history));
    } catch (e) {
      emit(SearchHistoryError(message: e.toString()));
    }
  }

  Future<void> _onAddSearchHistory(
      AddSearchHistory event, Emitter<SearchHistoryState> emit) async {
    try {
      if (_database == null) return;
      await _database!.insert('history', {
        'ip': event.ip,
        'countryFlag': event.flagUrl,
      });
      add(LoadSearchHistory());
    } catch (e) {
      emit(SearchHistoryError(message: e.toString()));
    }
  }

  Future<void> _onDeleteSearchHistory(
      DeleteSearchHistory event, Emitter<SearchHistoryState> emit) async {
    try {
      if (_database == null) return;
      await _database!.delete('history', where: 'id = ?', whereArgs: [event.id]);
      add(LoadSearchHistory());
    } catch (e) {
      emit(SearchHistoryError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _database?.close();
    return super.close();
  }
}
