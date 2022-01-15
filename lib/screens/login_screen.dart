import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:weight_tracker/screens/register_screen.dart';
import 'package:weight_tracker/widgets/custom_text_field.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  UserCredential? user;

  bool isFormActive = true;

  signIn(BuildContext context) async {
    setState(() {
      isFormActive = false;
    });
    try {
      if (emailController.text.length == 0 || emailController.text.contains("@") == false) {
        showCustomSnackBar(context, "Email Not Valid");
        throw Exception();
      } else if (passwordController.text.length < 6) {
        showCustomSnackBar(context, "Password must be at least 6 characters");
        throw Exception();
      }
      user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } catch (e) {
    } finally {
      setState(() {
        isFormActive = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              CustomTextField(
                icon: LineIcons.envelope,
                hint: "Email",
                controller: emailController,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                icon: LineIcons.lock,
                hint: "Password",
                controller: passwordController,
                isTextVisible: true,
              ),
              const SizedBox(
                height: 20,
              ),
              isFormActive
                  ? ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith(
                          (states) => EdgeInsets.all(15),
                        ),
                      ),
                      onPressed: () {
                        signIn(context);
                      },
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                },
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Already have an accout? Sign Up",
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showCustomSnackBar(BuildContext context, meesage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(meesage)));
  }
}
