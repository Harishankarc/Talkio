import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkio/auth/login.dart';
import 'package:talkio/auth/signup.dart';
import 'package:talkio/components/myButton.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/utils/constant.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Optional: Set background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MyText(
                text: "Welcome to Talkio",
                fontSize: 30,
                textColor: apptextcolor,
                textAlign: true,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 40),
              Mybutton(
                border: 40,
                width: double.infinity,
                height: 80,
                fontSize: 20,
                text: "Log in",
                onTap: () {
                  Get.to(
                    () => const Login(),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 500),
                  );
                },
              ),
              const SizedBox(height: 20),
              Mybutton(
                border: 40,
                width: double.infinity,
                height: 80,
                fontSize: 20,
                text: "Sign Up",
                onTap: () {
                  Get.to(
                    () => const SignUp(),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 500),
                  );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              const MyText(
                text: "Continue with accounts",
                fontSize: 20,
                textColor: Colors.white,
                textAlign: true,
                fontWeight: FontWeight.normal,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Mybutton(
                    backgroundColor: errorButton,
                    border: 10,
                    width: 150, // Adjusted width to fit smaller screens
                    height: 60,
                    fontSize: 16,
                    text: "GOOGLE",
                    textColor: erroText,
                    onTap: () {},
                  ),
                  Mybutton(
                    backgroundColor: blueButton,
                    border: 10,
                    width: 150, // Adjusted width
                    height: 60,
                    fontSize: 16,
                    text: "TWITTER",
                    textColor: blueButtonText,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
