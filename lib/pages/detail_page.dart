import 'package:firebase_connection_1/blocs/main/main_bloc.dart';
import 'package:firebase_connection_1/blocs/post/post_bloc.dart';
import 'package:firebase_connection_1/views/custom_text_field_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPage extends StatelessWidget {
  DetailPage({Key? key}) : super(key: key);

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  bool isPublic = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DetailPage"),
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is CreatePostSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Successfully created!!!")));
            context.read<MainBloc>().add(const GetAllDataEvent());
            Navigator.of(context).pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomTextField(controller: titleController, title: "Title"),
              CustomTextField(controller: contentController, title: "Content"),
              Row(
                children: [
                  BlocSelector<PostBloc, PostState, bool>(
                    selector: (state) {
                      return state is PostIsPublicState && state.isPublic;
                    },
                    builder: (context, value) {
                      return Checkbox(
                          value: value,
                          onChanged: (value) {
                            context.read<PostBloc>().add(PostIsPublicEvent(value!));
                          });
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Do you want to make your post public?",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PostBloc>().add(CreatePostEvent(
              title: titleController.text,
              content: contentController.text,
              isPublic: isPublic));
        },
        child: const Icon(Icons.cloud_upload_rounded),
      ),
    );
  }
}
