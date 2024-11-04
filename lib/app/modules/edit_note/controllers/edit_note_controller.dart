import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditNoteController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getNoteById(String docId) async {
    try {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> doc = await firestore.collection("users").doc(uid)
      .collection("notes").doc(docId).get();
      return doc.data();
    } catch (e) {
      print(e);
      return null;
    }
  }

  void editNote(String docId) async {
    if(titleC.text.isNotEmpty && descC.text.isNotEmpty){
      try {
        isLoading.value = true;
        
        String uid = auth.currentUser!.uid;
        await firestore.collection("users").doc(uid).collection("notes").doc(docId).update({
          "title": titleC.text,
          "desc": descC.text,
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
