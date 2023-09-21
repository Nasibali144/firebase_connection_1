import 'package:firebase_connection_1/blocs/main/main_bloc.dart';
import 'package:firebase_connection_1/blocs/post/post_bloc.dart';
import 'package:firebase_connection_1/models/post_model.dart';
import 'package:firebase_connection_1/views/custom_text_field_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPage extends StatefulWidget {
  final Post? post;

  const DetailPage({this.post, Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late bool isPublic;

  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() {
    if (widget.post != null) {
      isPublic = widget.post!.isPublic;
      context.read<PostBloc>().add(PostIsPublicEvent(isPublic));
      titleController = TextEditingController(text: widget.post!.title);
      contentController = TextEditingController(text: widget.post!.content);
    } else {
      isPublic = false;
      titleController = TextEditingController();
      contentController = TextEditingController();
    }
  }

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

          if (state is CreatePostSuccess || state is UpdatePostSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Successfully completed!!!")));
            context.read<MainBloc>().add(const GetAllDataEvent());
            Navigator.of(context).pop();
          }

          if(state is PostIsPublicState) {
            isPublic = state.isPublic;
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
                      if(state is PostIsPublicState) return state.isPublic;

                      return isPublic;
                    },
                    builder: (context, value) {
                      return Checkbox(
                          value: value,
                          onChanged: (value) {
                            context
                                .read<PostBloc>()
                                .add(PostIsPublicEvent(value!));
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
          if (widget.post == null) {
            context.read<PostBloc>().add(CreatePostEvent(
                title: titleController.text,
                content: contentController.text,
                isPublic: isPublic));
          } else {
            context.read<PostBloc>().add(UpdatePostEvent(
                postId: widget.post!.id,
                title: titleController.text,
                content: contentController.text,
                isPublic: isPublic));
          }
        },
        child: const Icon(Icons.cloud_upload_rounded),
      ),
    );
  }
}
