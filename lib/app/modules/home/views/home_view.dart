import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_crud/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.StreamProfile(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return CircleAvatar(
                    backgroundColor: Colors.white,
                  );
                }
                Map<String, dynamic>? data = snapshot.data!.data();
                return GestureDetector(
                  onTap: () => Get.toNamed(Routes.PROFILE),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      data?['profile'] != null && data?['profile'].isNotEmpty
                        ? data!['profile']
                        : "https://ui-avatars.com/api/?name=${data!['name'] ?? 'Unknown'}",
                    ),

                  ),
                );
              }
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.StreamNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.length == 0) {
            return Center(
              child: Text("Notes not found"),
            );
          }else{
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var docNote = snapshot.data!.docs[index];
                Map<String, dynamic> note = docNote.data();
                return ListTile(
                  onTap: () => Get.toNamed(
                    Routes.EDIT_NOTE,
                    arguments: docNote.id,
                  ),
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                  title: Text("${note['title']}"),
                  subtitle: Text("${note['desc']}"),
                  trailing: IconButton(
                    onPressed: () {
                      controller.deleteNote(docNote.id);
                    }, 
                    icon: Icon(Icons.delete)
                  ),
                );
              },
            );
          }
          
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_NOTE),
        child: Icon(Icons.add),
      ),
    );
  }
}
