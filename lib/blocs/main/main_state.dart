part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  final List<Post> items;

  const MainState(this.items);
}

class MainInitial extends MainState {
  const MainInitial(super.items);

  @override
  List<Object> get props => [items];
}

class MainLoading extends MainState {
  const MainLoading(super.items);

  @override
  List<Object> get props => [items];
}

class MainFailure extends MainState {
  final String message;
  const MainFailure(List<Post> items, this.message) : super(items);

  @override
  List<Object> get props => [message, items];
}

class FetchDataSuccess extends MainState {
  final String message;

  const FetchDataSuccess(super.items, this.message);

  @override
  List<Object> get props => [message, items];
}