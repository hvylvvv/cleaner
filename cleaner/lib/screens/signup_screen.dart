//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cleaner/screens/login_screen.dart';
// import 'package:cleaner/screens/input_addr.dart';
// import 'package:cleaner/Resources/auth_methods.dart';
//
// class PhoneNumberFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
//
//     if (digits.length > 10) {
//       digits = digits.substring(0, 10);
//     }
//
//     String formattedText = _formatPhoneNumber(digits);
//
//     return TextEditingValue(
//       text: formattedText,
//       selection: TextSelection.collapsed(offset: formattedText.length),
//     );
//   }
//
//   String _formatPhoneNumber(String digits) {
//     if (digits.length <= 3) {
//       return '($digits';
//     } else if (digits.length <= 6) {
//       return '(${digits.substring(0, 3)}) ${digits.substring(3)}';
//     } else {
//       return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
//     }
//   }
// }
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _numController = TextEditingController();
//   final _formKey = GlobalKey<FormState>(); // Form key for validation
//
//   bool _isLoading = false;
//   bool _obscureText = true;
//
//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _numController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void registerUser() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       String resp = await AuthMethods().registerUser(
//         name: "${_firstNameController.text} ${_lastNameController.text}",
//         email: _emailController.text,
//         phone: _numController.text,
//         password: _passwordController.text,
//       );
//
//       if (resp == 'success') {
//         User? user = FirebaseAuth.instance.currentUser;
//         if (user != null) {
//           await user.updateDisplayName(
//               "${_firstNameController.text} ${_lastNameController.text}");
//           await user.reload();
//         }
//
//
//
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => const SetupAddress(),
//           ),
//         );
//       } else {
//         // Handle error scenario
//       }
//       }
//
//       setState(() {
//         _isLoading = false;
//       });
//   }
//
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email is required';
//     }
//     final emailPattern = r'\w+@\w+\.\w+';
//     if (!RegExp(emailPattern).hasMatch(value)) {
//       return 'Enter a valid email';
//     }
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password is required';
//     }
//     if (value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//     return null;
//   }
//
//   String? _validateName(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Name is required';
//     }
//     if (value.length == 1) {
//       return 'Invalid Name';
//     }
//     final namePattern = r"^[a-zA-Z\-]+$";
//     if (!RegExp(namePattern).hasMatch(value)) {
//       return 'Invalid Name';
//     }
//     return null;
//   }
//
//   String? _validatePhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Phone number is required';
//     }
//     final phonePattern = r'^\(\d{3}\) \d{3}-\d{4}$';
//     if (!RegExp(phonePattern).hasMatch(value)) {
//       return 'Enter a valid phone number';
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           // Return false to disable the back button
//           return false;
//         },
//       child: Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             width: double.infinity,
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 100), // Space at the top
//                   const Text(
//                     "Sign Up",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 35,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//               const Text(
//                 "Just a few quick things to get you started",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//                   const SizedBox(height: 24), // Space between title and content
//                   // First Name and Last Name fields side by side
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: _firstNameController,
//                           decoration: const InputDecoration(
//                             hintText: 'First Name',
//                             border: OutlineInputBorder(),
//                             contentPadding: EdgeInsets.all(16),
//                           ),
//                           keyboardType: TextInputType.name,
//                           validator: _validateName,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: TextFormField(
//                           controller: _lastNameController,
//                           decoration: const InputDecoration(
//                             hintText: 'Last Name',
//                             border: OutlineInputBorder(),
//                             contentPadding: EdgeInsets.all(16),
//                           ),
//                           keyboardType: TextInputType.name,
//                           validator: _validateName,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: const InputDecoration(
//                       hintText: 'Email',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.all(16),
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     validator: _validateEmail,
//                   ),
//                   const SizedBox(height: 24),
//                   TextFormField(
//                     controller: _numController,
//                     decoration: const InputDecoration(
//                       hintText: 'Phone Number',
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.all(16),
//                     ),
//                     keyboardType: TextInputType.phone,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       PhoneNumberFormatter(),
//                     ],
//                     validator: _validatePhoneNumber,
//                   ),
//                   const SizedBox(height: 24),
//
//
//                   TextFormField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       hintText: 'Create a Password',
//                       border: const OutlineInputBorder(),
//                       contentPadding: const EdgeInsets.all(16),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscureText
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscureText = !_obscureText;
//                           });
//                         },
//                       ),
//                     ),
//                     obscureText: _obscureText,
//                     validator: _validatePassword,
//                   ),
//
//                   const SizedBox(height: 32), // Increase space before the button
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : registerUser,
//                     child: _isLoading
//                         ? const CircularProgressIndicator(
//                       color: Colors.white,
//                     )
//                         : const Text("Add your Address"),
//                   ),
//                   const SizedBox(height: 24),
//                   GestureDetector(
//                     onTap: () => Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => const LoginScreen(),
//                       ),
//                     ),
//                     child: const Text(
//                       "Already have an account? Log In",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:cleaner/screens/login_screen.dart';
import 'package:cleaner/screens/input_addr.dart';
import 'package:cleaner/Resources/auth_methods.dart';
import 'package:flutter/services.dart';
import 'package:cleaner/widgets/input_text_feild.dart';
import 'package:cleaner/widgets/password_feild.dart';
import '../widgets/background_shapes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _numController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String resp = await AuthMethods().registerUser(
        name: "${_firstNameController.text} ${_lastNameController.text}",
        email: _emailController.text,
        phone: _numController.text,
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (resp == 'success') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SetupAddress(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resp),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
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
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Center(
                          child: Text(
                            "Cleaner+",
                            style: TextStyle(
                              fontFamily: 'MontserratAlternates',
                              fontSize: screenWidth * 0.16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          "Create your account",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: InputTextFeild(
                                hintText: 'First Name',
                                textInputType: TextInputType.name,
                                textEditingController: _firstNameController,
                                validator: (value) => value == null || value.isEmpty
                                    ? 'First Name required'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InputTextFeild(
                                hintText: 'Last Name',
                                textInputType: TextInputType.name,
                                textEditingController: _lastNameController,
                                validator: (value) => value == null || value.isEmpty
                                    ? 'Last Name required'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        InputTextFeild(
                          hintText: 'Email Address',
                          textInputType: TextInputType.emailAddress,
                          textEditingController: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        InputTextFeild(
                          hintText: 'Phone Number',
                          textInputType: TextInputType.phone,
                          textEditingController: _numController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        PasswordTextField(
                          hintText: 'Password',
                          textEditingController: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          }, textInputType: TextInputType.visiblePassword,
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
                            onPressed: _isLoading ? null : registerUser,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : Text(
                              "Add My Address",
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
                            const Text("Already have an account?"),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              ),
                              child: const Text(
                                " Log In",
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
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/pngs/background2.png',
                fit: BoxFit.fill,
                width: double.infinity,
                height: screenHeight * 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

