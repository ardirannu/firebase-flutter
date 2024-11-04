import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> StreamNotes() async* {
    String uid = auth.currentUser!.uid;
    yield* await firestore.collection("users").doc(uid).collection("notes").orderBy("createdAt").snapshots();
  }
  
  Stream<DocumentSnapshot<Map<String, dynamic>>> StreamProfile() async* {
    String uid = auth.currentUser!.uid;
    yield* await firestore.collection("users").doc(uid).snapshots();
  }

  void deleteNote(docId) async {
    try {
      String uid = auth.currentUser!.uid;
      await firestore.collection("users").doc(uid).collection("notes").doc(docId).delete();
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Error: $e");
    }
  }
}
