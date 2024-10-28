import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomm_dash/pages/home.dart';
import 'package:ecomm_dash/widgets/customButton.dart';
import 'package:ecomm_dash/widgets/customTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  bool _obscureText = true;
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
    if (isLoggedIn) {
      await prefs.setString('user_email', emailController.text);
    }
  }

  void login() async {
    if (formkey.currentState!.validate()) {
      // Static admin email and password
      const String adminEmail = "admin@gmail.com";
      const String adminPassword = "admin123";

      // Validate entered credentials
      if (emailController.text == adminEmail && passwordController.text == adminPassword) {
        setState(() {
          loading = true;
        });

        // Save login status and navigate to HomeScreen
        await saveLoginStatus(true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );

        setState(() {
          loading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid admin credentials.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
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
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login to your Admin Account',
                        style: TextStyle(fontFamily: 'Lexend', fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          CustomTextField(
                            labelText: 'Email',
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Your Email';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            labelText: 'Password',
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: _obscureText
                                  ? Icon(Icons.visibility_outlined)
                                  : Icon(Icons.visibility_off_outlined),
                            ),
                            controller: passwordController,
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Your Password';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    CustomButton(
                      customText: 'Log in',
                      loading: loading,
                      onTap: login,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
