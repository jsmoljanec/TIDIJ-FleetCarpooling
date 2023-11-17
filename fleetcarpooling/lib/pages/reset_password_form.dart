import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/ui_elements/buttons.dart';
import 'package:fleetcarpooling/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/ui_elements/text_field.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});
  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        elevation: 0,
      ),
      body: Container(
          color: AppColors.backgroundColor, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "Enter your email to reset your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 10.0),
              MyTextField(controller: emailController),
              const SizedBox(height: 10.0),
              MyElevatedButton(
                onPressed: () {
                  passwordReset();
                },
                label: "Reset Password",
              ),
            ],
          )
        ),
    );
  }
}
