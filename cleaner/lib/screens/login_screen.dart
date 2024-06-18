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
    
    final TextEditingController _emailController =TextEditingController();
    final TextEditingController _passwordController =TextEditingController();

    @override
    void dispose(){
      _emailController.dispose();
      _passwordController.dispose();
      super.dispose();
    }

    void loginUser() async {
      String res = await AuthMethods().loginUser(
        email: _emailController.text, 
        password: _passwordController.text
      );

      if (res == "success" ){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen())
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
      // return const Placeholder();
      return Scaffold(
        // backgroundColor: const Color.fromRGBO(30, 43, 45, 100),
        body: SafeArea(
          child: 
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 32
            ),

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



              InputTextFeild(hintText: 'Email', textInputType: TextInputType.emailAddress, textEditingController: _emailController,),
              const SizedBox(
                height: 24,
              ),
              PasswordTextField(hintText: 'Password', textInputType: TextInputType.text, isPass: true, textEditingController: _passwordController),
              // InputTextFeild(hintText: 'Password', textInputType: TextInputType.text, isPass: true, textEditingController: _passwordController,),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(

                  onPressed: (){
                    loginUser();

                    },
                  child: const Text("Log In"),

              ),

              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account? ", style: TextStyle(color: Colors.black),) ,
                  ),

                  
                  GestureDetector(
                    onTap: navigateToSignup ,
                    child : Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text("Sign Up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),) ,
                  )
                  ),
                  

                ],
              ),

              Flexible(
                flex: 2,
                child: Container(),
              ),
              

            ],
            ),
          )
        ),
      );
    }
  }



































  // @override
  // Widget build(BuildContext context) {
      //     // appBar: AppBar(title: const Text("Cleaner+", style: TextStyle(color: Colors.white, fontSize: 30)),
  //     // backgroundColor: const Color.fromARGB(30, 43, 45, 100),),


  //     backgroundColor: const Color.fromARGB(30, 43, 45, 100),
  //     body: Center(
  //       child: SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 20.0, right: 20.0),

  //           child: Column(
  //             children: [
  //               // Image(
  //               //   image: AssetImage("assets/logo.png"),
  //               // ),
  //               const SizedBox(
  //                 height: 180.0,
  //               ),

  //               const Row(
  //                 children: [
  //                   Text(
  //                     "Login",
  //                     style: TextStyle(color: Colors.white, fontSize: 30,  ),
  //                   ),
  //                 ],
  //               ),
  //               // const SizedBox(
  //               //   height: 0.5,
  //               // ),
  //               const Row(
  //                 children: [
  //                   Text(
  //                     "Sign in to Continue",
  //                     style: TextStyle(
  //                       color: Colors.white30, 
  //                       fontSize: 18
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               const SizedBox(height: 30.0),
  //               Container(
  //                 height: 50,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: Colors.white,
  //                 ),
  //                 child: const TextField(
  //                   decoration: InputDecoration(
  //                     border: OutlineInputBorder(borderSide: BorderSide.none),
  //                     hintText: 'Email', 
  //                     prefixIcon: Icon(Icons.email_outlined) ),
  //                 ),
  //               ),

  //               const SizedBox(height: 20.0),
  //               Container(
  //                 height: 50,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   // color: Color.fromARGB(153, 32, 25, 25),
  //                 ),
  //                 child: const TextField(
  //                   obscureText: true,
  //                   decoration: InputDecoration(
  //                     border: OutlineInputBorder(borderSide: BorderSide.none),
  //                     hintStyle: TextStyle(color: (Color.fromARGB(255, 255, 255, 255))),
  //                     hintText: 'Password', 
  //                     prefixIcon: Icon(Icons.lock) ),
  //                 ),
  //               ),

  //               const SizedBox(height: 10),

  //               Container(
                   
  //                 height: 50,
  //                 width: 120,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(18),
  //                   color: const Color.fromARGB(255, 2, 100, 95),
  //                   ),

  //                 child: const Center(
  //                   child: Text(
  //                     "LOGIN", 
  //                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), 
  //                   )
  //                 )
  //               ),

  //               const Spacer(),

                
              
  //               const Center( 
                  
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text("Don't have an account? ", style: TextStyle(color: Colors.white38),), 
  //                     SizedBox(
  //                       width: 8,
  //                     ),
  //                     Text(
  //                       "Sign Up", 
  //                       style: TextStyle(color: Color.fromARGB(255, 2, 100, 95), 
  //                       fontWeight: FontWeight.bold),
  //                     )
  //                   ],
  //                 ) 
  //               )
                
  //             ],
  //           )
  //         )
  //       )
  //    )
  //   
  // }
  
  
