part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
}

class CreatePostEvent extends PostEvent {
  final String title;
  final String content;
  final bool isPublic;

  const CreatePostEvent({
    required this.title,
    required this.content,
    required this.isPublic,
  });

  @override
  List<Object?> get props => [title, content, isPublic];
}

class PostIsPublicEvent extends PostEvent {
  final bool isPublic;
  const PostIsPublicEvent(this.isPublic);

  @override
  List<Object?> get props => [isPublic];
}

class DeletePostEvent extends PostEvent {
  final String postId;
  const DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}


