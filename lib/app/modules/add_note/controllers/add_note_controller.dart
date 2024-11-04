import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNoteController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addNote() async {
    if(titleC.text.isNotEmpty && descC.text.isNotEmpty){
      try {
        isLoading.value = true;
        
        String uid = auth.currentUser!.uid;
        await firestore.collection("users").doc(uid).collection("notes").add({
          "title": titleC.text,
          "desc": descC.text,
          "createdAt": DateTime.now().toIso8601String(),
        });

        isLoading.value = false;
        Get.back();
      } catch (e) {
        isLoading.value = false;
        print(e);
        Get.snackbar("Error", "Error: $e");
      }
    }else{
      Get.snackbar("Error", "Title & Desc cannot be null!");
    }
  }
}
