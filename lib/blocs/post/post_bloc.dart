import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_connection_1/services/db_service.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<CreatePostEvent>(_createPost);
    on<PostIsPublicEvent>(_changePublic);
  }

  void _createPost(CreatePostEvent event, Emitter emit) async {
    emit(PostLoading());
    final result = await DBService.storePost(event.title, event.content, event.isPublic);
    if(result) {
      emit(CreatePostSuccess());
    } else {
      emit(const PostFailure("Something error, tyr again later!!!"));
    }
  }

  void _changePublic(PostIsPublicEvent event, Emitter emit) {
    emit(PostIsPublicState(event.isPublic));
  }
}
