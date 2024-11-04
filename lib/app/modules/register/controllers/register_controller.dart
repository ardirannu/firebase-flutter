import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_crud/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController emailC = TextEditingController(text: 'rannuardianto55@gmail.com');
  TextEditingController passwordC = TextEditingController(text: '123456');
  TextEditingController nameC = TextEditingController(text: 'Ardi');
  TextEditingController phoneC = TextEditingController(text: '0858376543999');

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  void register() async {
    if(nameC.text.isEmpty){
      Get.snackbar("Name empty", "Name cannot be empty");
    }
    if(phoneC.text.isEmpty){
      Get.snackbar("Phone number empty", "Phone number cannot be empty");
    }
    if(emailC.text.isNotEmpty && passwordC.text.isNotEmpty){
      try {
        isLoading.value = true;

        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailC.text,
          password: passwordC.text,
        );
        print(credential);

        //send email verification
        await credential.user!.sendEmailVerification();

        //save data fo firestore
        await firestore.collection("users").doc(credential.user!.uid).set({
          "name": nameC.text,
          "phone": phoneC.text,
          "email": emailC.text,
          "uid": credential.user!.uid,
        });

        isLoading.value = false;

        Get.defaultDialog(
          title: "Verify your email!",
          titleStyle: TextStyle(
            fontSize: 16
          ),
          middleText: "Verification link has been sent to your email.",
          middleTextStyle: TextStyle(
            fontSize: 14
          ),
          titlePadding: EdgeInsets.all(20),
          actions: [
            ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.LOGIN), 
              child: Text("Login Now")
            ),
          ]
        );
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;

        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }else{
      Get.snackbar("Email & Password empty", "Email & Password cannot be empty");
    }
    
  }
}
