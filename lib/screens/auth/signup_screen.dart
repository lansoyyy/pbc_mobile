import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_plastic_mobile/screens/auth/login_screen.dart';
import 'package:smart_plastic_mobile/screens/home_screen.dart';
import 'package:smart_plastic_mobile/services/add_user.dart';
import 'package:smart_plastic_mobile/utlis/colors.dart';
import 'package:smart_plastic_mobile/widgets/button_widget.dart';
import 'package:smart_plastic_mobile/widgets/text_widget.dart';
import 'package:smart_plastic_mobile/widgets/textfield_widget.dart';
import 'package:smart_plastic_mobile/widgets/toast_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final id = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final confirmpassword = TextEditingController();
  final address = TextEditingController();
  final number = TextEditingController();

  bool remembered = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/logs.png',
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                prefixIcon: Icons.person,
                width: 275,
                controller: name,
                label: 'Name',
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                prefixIcon: Icons.location_city,
                width: 275,
                controller: address,
                label: 'Address',
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                prefixIcon: Icons.phone,
                width: 275,
                inputType: TextInputType.number,
                controller: number,
                label: 'Contact Number',
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                prefixIcon: Icons.email,
                width: 275,
                controller: id,
                label: 'Email',
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  TextFieldWidget(
                    prefixIcon: Icons.lock,
                    width: 275,
                    isObscure: true,
                    showEye: true,
                    controller: password,
                    label: 'Password',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    prefixIcon: Icons.lock,
                    width: 275,
                    isObscure: true,
                    showEye: true,
                    controller: confirmpassword,
                    label: 'Confirm Password',
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ButtonWidget(
                width: 275,
                label: 'Signup',
                onPressed: () {
                  if (password.text == confirmpassword.text) {
                    register(context);
                  } else {
                    showToast('Password do not match!');
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  register(context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: id.text, password: password.text);

      addUser(name.text, id.text, password.text, address.text, number.text);

      showToast('Account created succesfully!');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        showToast('The email address is not valid.');
      } else {
        showToast(e.toString());
      }
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
