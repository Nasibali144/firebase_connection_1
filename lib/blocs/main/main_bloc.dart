import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_connection_1/models/post_model.dart';
import 'package:firebase_connection_1/services/db_service.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainInitial([])) {
    on<GetAllDataEvent>(_fetchAllPost);
    on<SearchMainEvent>(_searchPost);
    on<AllPublicPostEvent>(_publicPost);
    on<MyPostEvent>(_myPost);
  }

  void _fetchAllPost(GetAllDataEvent event, Emitter emit) async {
    emit(MainLoading(state.items));
    try {
      final list = await DBService.readAllPost();
      emit(FetchDataSuccess(list, "Successfully fetched!"));
    } catch (e) {
     emit(MainFailure(state.items, "Something error, try again later"));
    }
  }

  void _searchPost(SearchMainEvent event, Emitter emit) async {
    final type = state is MyPostSuccess ? SearchType.me: SearchType.all;

    emit(MainLoading(state.items));
    try {
      final list = await DBService.searchPost(event.searchText, type);
      emit(SearchMainSuccess(list));
    } catch (e) {
      emit(MainFailure(state.items, "Something error, try again later"));
    }
  }

  void _publicPost(AllPublicPostEvent event, Emitter emit) async {
    emit(MainLoading(state.items));
    try {
      final list = await DBService.publicPost();
      emit(AllPublicPostSuccess(list));
    } catch (e) {
      emit(MainFailure(state.items, "Something error, try again later"));
    }
  }

  void _myPost(MyPostEvent event, Emitter emit) async {
    emit(MainLoading(state.items));
    try {
      final list = await DBService.myPost();
      emit(MyPostSuccess(list));
    } catch (e) {
      emit(MainFailure(state.items, "Something error, try again later"));
    }
  }
}
