import 'package:flutter/material.dart';


class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});
  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        elevation: 0,
      ),
    );
  }
}
