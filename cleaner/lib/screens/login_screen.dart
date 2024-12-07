import 'package:flutter/material.dart';
import 'package:cleaner/screens/home_screen.dart';
import 'package:cleaner/widgets/input_text_feild.dart';
import 'package:cleaner/screens/signup_screen.dart';
import 'package:cleaner/Resources/auth_methods.dart';
import 'package:cleaner/widgets/password_feild.dart';
import '../widgets/background_shapes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect email or password.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Prevent resizing when keyboard appears
        body: Stack(
          children: [
            // Foreground content
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Center(
                        child: Text(
                          "Cleaner+",
                          style: TextStyle(
                            fontFamily: 'MontserratAlternates',
                            fontSize: screenWidth * 0.17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.1),
                      Text(
                        "Log in with your email",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.013),
                      InputTextFeild(
                        hintText: 'Email Address',
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      PasswordTextField(
                        hintText: 'Password',
                        textInputType: TextInputType.text,
                        textEditingController: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF599954),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.012,
                              horizontal: screenWidth * 0.07,
                            ),
                          ),
                          onPressed: _isLoading ? null : loginUser,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                            "Log In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          GestureDetector(
                            onTap: navigateToSignup,
                            child: const Text(
                              " Sign Up",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/pngs/background2.png',
                fit: BoxFit.fill,
                width: double.infinity, // Ensures it spans the entire width
                height: screenHeight * 0.2, // Adjust height as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
