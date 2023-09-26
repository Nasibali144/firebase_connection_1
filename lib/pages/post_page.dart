import 'package:firebase_connection_1/models/post_model.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Image(image: NetworkImage(post.imageUrl)),
          const SizedBox(height: 10,),
          Text(post.content, style: Theme.of(context).textTheme.titleMedium,),
          const SizedBox(height: 10,),

        ],
      ),
    );
  }
}
