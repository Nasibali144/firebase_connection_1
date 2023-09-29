import 'package:firebase_connection_1/blocs/auth/auth_bloc.dart';
import 'package:firebase_connection_1/blocs/main/main_bloc.dart';
import 'package:firebase_connection_1/blocs/post/post_bloc.dart';
import 'package:firebase_connection_1/pages/detail_page.dart';
import 'package:firebase_connection_1/pages/post_page.dart';
import 'package:firebase_connection_1/pages/sign_in_page.dart';
import 'package:firebase_connection_1/services/db_service.dart';
import 'package:firebase_connection_1/services/rc_service.dart';
import 'package:firebase_connection_1/services/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SearchType type = SearchType.all;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MainBloc>()
      ..add(const AllPublicPostEvent())
      ..add(const ActivateRCEvent());
  }

  void showWarningDialog(BuildContext ctx) {
    final controller = TextEditingController();
    showDialog(
      context: ctx,
      builder: (context) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is DeleteAccountSuccess) {
              Navigator.of(context).pop();
              if (ctx.mounted) {
                Navigator.of(ctx).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInPage()));
              }
            }

            if (state is AuthFailure) {
              Navigator.of(context).pop();
              Navigator.of(ctx).pop();
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                AlertDialog(
                  title: const Text(I18N.deleteAccount),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state is DeleteConfirmSuccess
                          ? I18N.requestPassword
                          : I18N.deleteAccountWarning),
                      const SizedBox(
                        height: 10,
                      ),
                      if (state is DeleteConfirmSuccess)
                        TextField(
                          controller: controller,
                          decoration:
                              const InputDecoration(hintText: I18N.password),
                        ),
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    /// #cancel
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(I18N.cancel),
                    ),

                    /// #confirm #delete
                    ElevatedButton(
                      onPressed: () {
                        if (state is DeleteConfirmSuccess) {
                          context
                              .read<AuthBloc>()
                              .add(DeleteAccountEvent(controller.text.trim()));
                        } else {
                          context
                              .read<AuthBloc>()
                              .add(const DeleteConfirmEvent());
                        }
                      },
                      child: Text(state is DeleteConfirmSuccess
                          ? I18N.delete
                          : I18N.confirm),
                    ),
                  ],
                ),
                if (state is AuthLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (value) {
        if (value) {
          context.read<AuthBloc>().add(const GetUserEvent());
        }
      },
      appBar: AppBar(
        title: BlocBuilder<MainBloc, MainState>(
          buildWhen: (previous, current) => current is ActivateRCSuccessState,
          builder: (context, state) {
            return Text(RCService.season);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(const SignOutEvent());
            },
            icon: const Icon(Icons.logout),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 80),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: "Search", border: OutlineInputBorder()),
              onChanged: (text) {
                final bloc = context.read<MainBloc>();
                debugPrint(text);
                if (text.isEmpty) {
                  if (type == SearchType.all) {
                    bloc.add(const AllPublicPostEvent());
                  } else {
                    bloc.add(const MyPostEvent());
                  }
                } else {
                  bloc.add(SearchMainEvent(text));
                }
              },
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final String name = state is GetUserSuccess
                    ? state.user.displayName!
                    : "accountName";
                final String email =
                    state is GetUserSuccess ? state.user.email! : "accountName";

                return UserAccountsDrawerHeader(
                  accountName: Text(name),
                  accountEmail: Text(email),
                );
              },
            ),
            ListTile(
              onTap: () => showWarningDialog(context),
              title: const Text(I18N.deleteAccount),
            )
          ],
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }

              if (state is DeleteAccountSuccess && context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }

              if (state is SignOutSuccess) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInPage()));
              }
            },
          ),
          BlocListener<PostBloc, PostState>(
            listener: (context, state) {
              if (state is DeletePostSuccess) {
                if (type == SearchType.all) {
                  context.read<MainBloc>().add(const AllPublicPostEvent());
                } else {
                  context.read<MainBloc>().add(const MyPostEvent());
                }
              }

              if (state is PostFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          )
        ],
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final post = state.items[index];
                    return GestureDetector(
                      onLongPress: () {
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(post: post)));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PostPage(post: post)));
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              color: Colors
                                  .primaries[index % Colors.primaries.length],
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).width - 30,
                              child: Image(
                                image: NetworkImage(post.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            ListTile(
                              title: Text(post.title),
                              subtitle: Text(post.content),
                              trailing: post.isMe
                                  ? IconButton(
                                      onPressed: () {
                                        context
                                            .read<PostBloc>()
                                            .add(DeletePostEvent(post.id));
                                      },
                                      icon: const Icon(Icons.delete),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (state is MainLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => DetailPage()));
        },
        child: const Icon(Icons.create_outlined),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            type = SearchType.all;
            context.read<MainBloc>().add(const AllPublicPostEvent());
          } else {
            type = SearchType.me;
            context.read<MainBloc>().add(const MyPostEvent());
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.public), label: "All"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Me"),
        ],
      ),
    );
  }
}
