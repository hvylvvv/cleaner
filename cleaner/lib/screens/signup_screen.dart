import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cleaner/widgets/input_text_feild.dart';
import 'package:cleaner/screens/login_screen.dart';
import 'package:cleaner/screens/input_addr.dart';
import 'package:cleaner/Resources/auth_methods.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController =TextEditingController();
  final TextEditingController _nameController =TextEditingController();
  final TextEditingController _numController =TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    void registerUser() async {
      String resp = await AuthMethods().registerUser(
        name: _nameController.text,
        email: _emailController.text,
        phone: _numController.text,
        password: _passwordController.text,
      );

      if (resp == 'success') {
        // Set the display name after successful registration
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updateDisplayName(_nameController.text);
          await user.reload();
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SetupAddress(),
          ),
        );
      }
    }




    void navigateToLogin(){
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginScreen()
        )
      );
    }
    



    return Scaffold(
      // backgroundColor: const Color.fromRGBO(30, 43, 45, 100),
      body: SafeArea(
        child:  Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),

              const Text(
                "Add your Address",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Text(
                "Just a few quick things to get you started",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 15,),


              InputTextFeild(hintText: 'Name', textInputType: TextInputType.name, textEditingController: _nameController,),
              const SizedBox(
                height: 24,
              ),
              InputTextFeild(hintText: 'Email', textInputType: TextInputType.emailAddress, textEditingController: _emailController,),
              const SizedBox(
                height: 24,
              ),

              InputTextFeild(hintText: 'Phone Number', textInputType: TextInputType.phone, textEditingController: _numController,),
              const SizedBox(
                height: 24,
              ),
              
              InputTextFeild(hintText: 'Password', textInputType: TextInputType.text, isPass: true, textEditingController: _passwordController,),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(onPressed: (){
                registerUser();
              }, 
              child: const Text("Continue")),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Already have an account? ", style: TextStyle(color: Colors.black),) ,
                  ),

                  
                  GestureDetector(
                    onTap: navigateToLogin,
                    child : Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text("Log In", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),) ,
                  )
                  ),
                  

                ],
              ),

              Flexible(
                flex: 1,
                child: Container(),
              ),

            ],
          ),
        )
      ),
    );
  }
}