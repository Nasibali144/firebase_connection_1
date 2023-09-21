part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class GetAllDataEvent extends MainEvent {
  const GetAllDataEvent();

  @override
  List<Object?> get props => [];
}