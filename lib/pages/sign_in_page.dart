import 'package:firebase_connection_1/pages/home_page.dart';
import 'package:firebase_connection_1/pages/sign_up_page.dart';
import 'package:firebase_connection_1/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    if(email.isEmpty || password.isEmpty) {
      return;
    }

    final user = await AuthService.signIn(email, password);
    print("USER: $user");
    if(user != null && context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
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
              Text("Sign In", style: Theme.of(context).textTheme.headlineLarge,),
              SizedBox(height: 20,),
              TextField(controller: emailController, decoration: InputDecoration(hintText: "Email"),),
              SizedBox(height: 20,),
              TextField(controller: passwordController, decoration: InputDecoration(hintText: "Password"),),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: signIn, child: Text("Sign In")),
              SizedBox(height: 20,),
              TextButton(onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpPage()));
              }, child: Text("Don't have an account? SignUp")),
            ],
          ),
        ),
      ),
    );
  }
}
