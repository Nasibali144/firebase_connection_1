import 'package:firebase_connection_1/services/strings.dart';
import 'package:firebase_connection_1/views/custom_text_field_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final prePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// #text: sing up
                Text(
                  I18N.signup,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),

                CustomTextField(controller: nameController, title: I18N.username),
                CustomTextField(controller: emailController, title: I18N.email),
                CustomTextField(controller: passwordController, title: I18N.password),
                CustomTextField(controller: prePasswordController, title: I18N.prePassword),



                /// #button: sign up
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(I18N.signup),
                ),
                const SizedBox(height: 30),

                /// #already have account
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: I18N.alreadyHaveAccount,
                      ),
                      TextSpan(
                        text: I18N.signin,
                        style: const TextStyle(color: Colors.lightBlueAccent),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// #laoding...
          if (false)
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}




