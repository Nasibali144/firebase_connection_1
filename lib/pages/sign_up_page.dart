import 'package:firebase_connection_1/pages/sign_in_page.dart';
import 'package:firebase_connection_1/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUp() async {
    String email = emailController.text;
    String password = passwordController.text;

    if(email.isEmpty || password.isEmpty) {
      return;
    }

    final success = await AuthService.signUp(email, password);
    if(success && context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Sign Up", style: Theme.of(context).textTheme.headlineLarge,),
              SizedBox(height: 20,),
              TextField(controller: emailController, decoration: InputDecoration(hintText: "Email"),),
              SizedBox(height: 20,),
              TextField(controller: passwordController, decoration: InputDecoration(hintText: "Password"),),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
              SizedBox(height: 20,),
              TextButton(onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
              }, child: Text("Already have an account? SignIn")),
            ],
          ),
        ),
      ),
    );
  }

}
