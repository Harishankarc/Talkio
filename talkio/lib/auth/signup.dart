import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talkio/auth/authentication.dart';
import 'package:talkio/auth/login.dart';
import 'package:talkio/components/myButton.dart';
import 'package:talkio/components/myInput.dart';
import 'package:talkio/components/myText.dart';
import 'package:talkio/screens/mainNavigation.dart';
import 'package:talkio/utils/constant.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});



  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    Authentication auth = Authentication();
    Future<void> handleSignUp() async {
      if (nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        int status = await auth.signUpUser(emailController.text, passwordController.text, nameController.text);
        if(status == 200){
          Get.showSnackbar(
            const GetSnackBar(
              title: 'Email Verification',
              message:
                  'An email has been sent to this email address, please verify',
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
              snackPosition: SnackPosition.TOP,
            ),
          );
          Get.to(()=>const Login(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
        }
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
              color: backButton,
              borderRadius: BorderRadius.circular(10)
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,color: backButtonIcon,size: 20,)
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25,right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40,),
                const MyText(
                  text: "Create your",
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
                MyInput(controller: nameController, hintText: "Enter Name",textColor: Colors.white,),
                const SizedBox(height: 20,),
                MyInput(controller: emailController, hintText: "Enter Email",textColor: Colors.white),
                const SizedBox(height: 20,),
                MyInput(controller: passwordController, hintText: "Enter password",obscureText: true,textColor: Colors.white),
                const SizedBox(height: 20,),
                Mybutton(border: 10,width: double.infinity,height: 50,fontSize: 15,text: "Register",onTap: (){
                  handleSignUp();
                },),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      onTap: () {
                        Get.to(() => const Login(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
                      },
                      text: "Already have an account? Login",
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
                const SizedBox(height: 20,),
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
                          print("Failed to sign in with Google");
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