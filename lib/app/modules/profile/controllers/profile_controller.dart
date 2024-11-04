import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_crud/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as f_storage;

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  TextEditingController emailC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  f_storage.FirebaseStorage storage = f_storage.FirebaseStorage.instance;
  
  XFile? image;

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery); //from gallery
    // image = await picker.pickImage(source: ImageSource.camera);
    // if(image != null){


    // }
    update(); //for get builder
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> docUser = await firestore.collection("users").doc(uid).get();
      return docUser.data();
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Terjadi kesalahan: $e");
      return null;
    }
  }

  void updateProfile() async {
    try {
      if(nameC.text.isEmpty){
      Get.snackbar("Name empty", "Name cannot be empty");
      }
      
      if(phoneC.text.isEmpty){
        Get.snackbar("Phone number empty", "Phone number cannot be empty");
      }

      if(nameC.text.isNotEmpty && phoneC.text.isNotEmpty){
        isLoading.value = true;
        String uid = auth.currentUser!.uid;

        await firestore.collection("users").doc(uid).update({
          "name": nameC.text,
          "phone": phoneC.text,
        });

        if(image != null){
          String ext = image!.name.split(".").last; //extension file
          await storage.ref("$uid").child("profile.$ext").putFile(File(image!.path));

          String profileUrl = await storage.ref("$uid").child("profile.$ext").getDownloadURL();
          //update profile
          await firestore.collection("users").doc(uid).update({
            "profile": profileUrl,
          });
        }

        if(passwordC.text.isNotEmpty){
          await auth.currentUser!.updatePassword(passwordC.text);
          await auth.signOut();

          Get.offAllNamed(Routes.LOGIN);
        }

        Get.snackbar("Update Success", "Successfully update data.");
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }
}
