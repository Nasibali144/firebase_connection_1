import 'package:firebase_connection_1/blocs/auth/auth_bloc.dart';
import 'package:firebase_connection_1/pages/sign_in_page.dart';
import 'package:firebase_connection_1/services/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void showWarningDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(I18N.deleteAccount),
          content: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            return Column(
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
                    decoration: const InputDecoration(hintText: I18N.password),
                  ),
              ],
            );
          }),
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

              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Text(state is DeleteConfirmSuccess
                      ? I18N.delete
                      : I18N.confirm);
                },
              ),
            ),
          ],
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

          if (state is SignOutSuccess) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInPage()));
          }
        },
      ),
    );
  }
}
