import 'package:firebase_auth_crud/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController emailC = TextEditingController(text: 'rannuardianto55@gmail.com');
  TextEditingController passwordC = TextEditingController(text: '123456');

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if(emailC.text.isNotEmpty && passwordC.text.isNotEmpty){
      try {
        isLoading.value = true;

        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailC.text,
          password: passwordC.text,
        );
        print(credential);


        //check user email is verified
        if(credential.user!.emailVerified == true){
          isLoading.value = false;
          Get.offAllNamed(Routes.HOME);
        }else{
          isLoading.value = false;
          Get.defaultDialog(
            title: "Email not verified.",
            titleStyle: TextStyle(
              fontSize: 16
            ),
            middleText: "Email has not been verified.",
            middleTextStyle: TextStyle(
              fontSize: 14
            ),
            titlePadding: EdgeInsets.all(20),
            actions: [
              ElevatedButton(
                onPressed: () {
                  credential.user!.sendEmailVerification();
                  Get.back();
                }, 
                child: Text("Send Email Verification")
              ),
            ]
          );
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;

        Get.snackbar("Credential invalid", "Email & Password not valid.");

        if (e.code == 'user-not-found') {
          Get.defaultDialog(
            title: "No user found for that email.",
            titleStyle: TextStyle(
              fontSize: 14
            ),
            titlePadding: EdgeInsets.all(15)
          );
        } else if (e.code == 'wrong-password') {
          Get.defaultDialog(
            title: "NWrong password provided for that user.",
            titleStyle: TextStyle(
              fontSize: 14
            ),
            titlePadding: EdgeInsets.all(15)
          );
        }
      } catch (e) {
        print(e);
      }
    }else{
      Get.snackbar("Email & Password empty", "Email & Password cannot be empty");
    }
  }
}