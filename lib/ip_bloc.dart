import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutprakkk/service.dart';
import 'package:get_it/get_it.dart';

import 'db.dart';
import 'dto.dart';

abstract class IpInfoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchIpInfoEvent extends IpInfoEvent {
  final String ipAddress;

  FetchIpInfoEvent(this.ipAddress);

  @override
  List<Object?> get props => [ipAddress];
}

abstract class IpInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IpInfoInitial extends IpInfoState {}

class IpInfoLoading extends IpInfoState {}

class IpInfoLoaded extends IpInfoState {
  final IpInfo ipInfo;

  IpInfoLoaded(this.ipInfo);

  @override
  List<Object?> get props => [ipInfo];
}

class IpInfoError extends IpInfoState {}

class IpInfoBloc extends Bloc<IpInfoEvent, IpInfoState> {
  IpInfoBloc() : super(IpInfoInitial()) {
    on<FetchIpInfoEvent>(_onFetchIpInfo);
  }

  Future<void> _onFetchIpInfo(
      FetchIpInfoEvent event, Emitter<IpInfoState> emit) async {
    emit(IpInfoLoading());
    try {
      final service = GetIt.I<IpFindService>();
      final ipInfo = await service.fetchIpInfoWithAsyncAwait(event.ipAddress);
      if (ipInfo != null) {
        await DatabaseHelper.instance.insertIpInfo(ipInfo);

        emit(IpInfoLoaded(ipInfo));
      } else {
        emit(IpInfoError());
      }
    } catch (e) {
      emit(IpInfoError());
    }
  }

}
