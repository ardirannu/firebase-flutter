import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_note_controller.dart';

class AddNoteView extends GetView<AddNoteController> {
  const AddNoteView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddNoteView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: ListView(
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
                  controller.addNote();
                }
              },
              child: Text(controller.isLoading.isFalse ? "Add Note" : "Loading"),
            )
          ],
        ),  
      )
    );
  }
}
