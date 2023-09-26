import 'dart:convert';

import 'package:firebase_connection_1/blocs/post/post_bloc.dart';
import 'package:firebase_connection_1/models/post_model.dart';
import 'package:firebase_connection_1/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatelessWidget {
  final Post post;

  const PostPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Image(image: NetworkImage(post.imageUrl)),
          const SizedBox(
            height: 10,
          ),
          Text(
            post.content,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: DBService.db.ref(Folder.post).child(post.id).onValue,
            builder: (context, snapshot) {
              Post current = snapshot.hasData
                  ? Post.fromJson(
                      jsonDecode(jsonEncode(snapshot.data!.snapshot.value))
                          as Map<String, Object?>)
                  : post;

              post.comments = current.comments;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: current.comments.length,
                itemBuilder: (context, index) {
                  final msg = current.comments[index];
                  return ListTile(
                    title: Text(msg.message),
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar:  BottomAppBar(
        child: TextField(
          decoration: const InputDecoration(
            hintText: "Write a comment..."
          ),
          onSubmitted: (text) {
            context.read<PostBloc>().add(WriteCommentPostEvent(post.id, text, post.comments));
          },
        ),
      ),
    );
  }
}
