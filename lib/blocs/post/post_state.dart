part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();
}

class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}

class PostLoading extends PostState {
  @override
  List<Object> get props => [];
}

class PostFailure extends PostState {
  final String message;

  const PostFailure(this.message);
  @override
  List<Object> get props => [message];
}

class CreatePostSuccess extends PostState {
  @override
  List<Object> get props => [];
}

class DeletePostSuccess extends PostState {
  @override
  List<Object> get props => [];
}

class UpdatePostSuccess extends PostState {
  @override
  List<Object> get props => [];
}

class PostIsPublicState extends PostState {
  final bool isPublic;

  const PostIsPublicState(this.isPublic);

  @override
  List<Object> get props => [isPublic];
}