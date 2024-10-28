import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm_dash/pages/login.dart';
import 'package:ecomm_dash/services/connection.dart';
import 'package:ecomm_dash/widgets/customButton.dart';
import 'package:ecomm_dash/widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool loading = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }

  // Signup logic
  Future<void> signup() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      try {
        // Create user in Firebase Authentication
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Store additional user info in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': emailController.text.trim(),
          'username': usernameController.text.trim(),
          // You can add more fields here if needed
        });

        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Registered Successfully!')),
        );

        // Redirect to LoginScreen after successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } catch (error) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          InternetConnection(),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Scissors Doctor',
                      style: TextStyle(
                        color: Color(0xffE83A3A),
                        fontSize: 25,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Register to your Account',
                        style: TextStyle(fontFamily: 'Lexend', fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          CustomTextField(
                            labelText: 'Username',
                            controller: usernameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Your Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            labelText: 'Email',
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Your Email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            labelText: 'Password',
                            controller: passwordController,
                            obscureText: _obscureText,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Your Password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    CustomButton(
                      customText: 'Sign Up',
                      loading: loading,
                      onTap: signup,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account ? "),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(color: Color(0xffE83A3A)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
