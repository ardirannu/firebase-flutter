import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_note_controller.dart';

class EditNoteView extends GetView<EditNoteController> {
  const EditNoteView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditNoteView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: controller.getNoteById(Get.arguments.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              return Center(
                child: Text("Note not found"),
              );
            }else{
              controller.titleC.text = snapshot.data!["title"];
              controller.descC.text = snapshot.data!["desc"];

              return ListView(
                children: [
                  TextField(
                    autocorrect: false,
                    controller: controller.titleC,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autocorrect: false,
                    controller: controller.descC,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Desc",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(controller.isLoading.isFalse){
                        controller.editNote(Get.arguments.toString());
                      }
                    },
                    child: Text(controller.isLoading.isFalse ? "Update Note" : "Loading"),
                  )
                ],
              );
            }
          }
        ),  
      )
    );
  }
}
