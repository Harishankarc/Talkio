import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:talkio/auth/authentication.dart';
import 'package:talkio/auth/signup.dart';
import 'package:talkio/components/myButton.dart';
import 'package:talkio/components/myInput.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/screens/mainNavigation.dart';
import 'package:talkio/utils/constant.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    Authentication auth = Authentication();
    Future<void> handleLogin() async {
      final status = await auth.loginUser(emailController.text, passwordController.text);
      if(status == 200){
        Get.to(()=>const MainNavigation(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
      }
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: appbackground,
        appBar: AppBar(
          backgroundColor: appbackground,
          automaticallyImplyLeading: false,
          title: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: backButton, borderRadius: BorderRadius.circular(10)),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: backButtonIcon,
                size: 20,
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const MyText(
                  text: "Login your",
                  fontSize: 50,
                  textColor: apptextcolor,
                  fontWeight: FontWeight.bold,
                ),
                const MyText(
                  text: "Account",
                  fontSize: 50,
                  textColor: apptextcolor,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 80,
                ),
                MyInput(
                    controller: emailController,
                    hintText: "Enter Email",
                    textColor: Colors.white),
                const SizedBox(
                  height: 20,
                ),

                MyInput(
                    controller: passwordController,
                    hintText: "Enter password",
                    obscureText: true,
                    textColor: Colors.white),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyText(
                      text: "Forgot password?",
                      underline: true,
                      fontSize: 15,
                      textColor: apptextcolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Mybutton(
                  border: 10,
                  width: double.infinity,
                  height: 50,
                  fontSize: 15,
                  text: "Login",
                  onTap: () {
                    handleLogin();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: "Create new account? Sign up",
                      onTap: () {
                        Get.to(() => const SignUp(),
                            transition: Transition.cupertino,
                            duration: const Duration(milliseconds: 500));
                      },
                      underline: true,
                      textAlign: true,
                      fontSize: 20,
                      textColor: apptextcolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.1,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: "Continue with accounts",
                      textAlign: true,
                      fontSize: 20,
                      textColor: apptextcolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Mybutton(
                      backgroundColor: errorButton,
                      textColor: erroText,
                      border: 10,
                      width: 200,
                      height: 60,
                      fontSize: 20,
                      text: "GOOGLE",
                      onTap: () async {
                        final status = await auth.SignInWithGoogle();
                        if(status == 200){
                          Get.to(()=>const MainNavigation(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
                        }else{
                          print("Error signing in with google");
                        }
                      },
                    ),
                    Mybutton(
                      backgroundColor: blueButton,
                      textColor: blueButtonText,
                      border: 10,
                      width: 200,
                      height: 60,
                      fontSize: 20,
                      text: "TWITTER",
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
