import 'package:firebase_connection_1/services/strings.dart';
import 'package:firebase_connection_1/views/custom_text_field_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);


  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                /// #text: sing in
                Text(
                  I18N.signin,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),

                CustomTextField(controller: emailController, title: I18N.email),
                CustomTextField(controller: passwordController, title: I18N.password),



                /// #button: sign up
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(I18N.signin),
                ),
                const SizedBox(height: 30),

                /// #already have account
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: I18N.dontHaveAccount,
                      ),
                      TextSpan(
                        text: I18N.signup,
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




