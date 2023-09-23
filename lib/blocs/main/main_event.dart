part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class GetAllDataEvent extends MainEvent {
  const GetAllDataEvent();

  @override
  List<Object?> get props => [];
}

class SearchMainEvent extends MainEvent {
  final String searchText;

  const SearchMainEvent(this.searchText);

  @override
  List<Object?> get props => [searchText];
}

class AllPublicPostEvent extends MainEvent {
  const AllPublicPostEvent();

  @override
  List<Object?> get props => [];
}

class MyPostEvent extends MainEvent {
  const MyPostEvent();

  @override
  List<Object?> get props => [];
}