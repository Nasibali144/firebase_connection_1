import 'package:firebase_connection_1/blocs/auth/auth_bloc.dart';
import 'package:firebase_connection_1/pages/sign_in_page.dart';
import 'package:firebase_connection_1/services/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void showWarningDialog(BuildContext ctx) {
    final controller = TextEditingController();
    showDialog(
      context: ctx,
      builder: (context) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is DeleteAccountSuccess) {
              Navigator.of(context).pop();
              if(ctx.mounted) {
                Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
              }
            }

            if(state is AuthFailure) {
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
                          decoration: const InputDecoration(
                              hintText: I18N.password),
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
                      child: const Text(I18N.cancel),),

                    /// #confirm #delete
                    ElevatedButton(
                      onPressed: () {
                        if(state is DeleteConfirmSuccess) {
                          context.read<AuthBloc>().add(DeleteAccountEvent(controller.text.trim()));
                        } else {
                          context.read<AuthBloc>().add(const DeleteConfirmEvent());
                        }
                      },
                      child: Text(state is DeleteConfirmSuccess
                          ? I18N.delete
                          : I18N.confirm),
                    ),
                  ],
                ),

                if(state is AuthLoading) const Center(
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
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(const SignOutEvent());
            },
            icon: const Icon(Icons.logout),
          )
        ],
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
      body: BlocListener<AuthBloc, AuthState>(
        child: const SizedBox.shrink(),
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }

          if(state is DeleteAccountSuccess && context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is SignOutSuccess) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInPage()));
          }
        },
      ),
    );
  }
}
