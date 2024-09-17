
import 'package:cleaner/screens/home_screen.dart';
import 'package:cleaner/widgets/input_text_feild.dart';
import 'package:flutter/material.dart';
import 'package:cleaner/screens/signup_screen.dart';
import 'package:cleaner/Resources/auth_methods.dart';

import 'package:cleaner/widgets/password_feild.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
  }

class _LoginScreenState extends State<LoginScreen>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Track loading state

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void loginUser() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    String res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text
    );

    setState(() {
      _isLoading = false; // Stop loading
    });

    if (res == "success") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const HomeScreen()
          )
      );
    } else {
      // Show Snackbar for incorrect password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect email or password.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }


  void navigateToSignup(){
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const SignUpScreen()
        )
    );
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
        onWillPop: () async {
          // Return false to disable the back button
          return false;
        },
    child: Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Flexible(
                flex: 2,
                child: Container(),
              ),

              const Text(
                "Log In to Continue",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w300,
                ),
              ),

              const SizedBox(
                height: 48,
              ),

              InputTextFeild(
                hintText: 'Email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),

              const SizedBox(
                height: 24,
              ),

              PasswordTextField(
                hintText: 'Password',
                textInputType: TextInputType.text,
                isPass: true,
                textEditingController: _passwordController,
              ),

              const SizedBox(
                height: 24,
              ),

              ElevatedButton(
                onPressed: _isLoading ? null : loginUser, // Disable button if loading
                child: _isLoading
                    ? CircularProgressIndicator() // Show loader
                    : const Text("Log In"),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),

              Flexible(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}




