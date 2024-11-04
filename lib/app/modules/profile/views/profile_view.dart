import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ProfileView'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => controller.logout(), icon: Icon(Icons.logout))
          ],
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
            future: controller.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == null) {
                return Center(
                  child: Text("Users not found"),
                );
              } else {
                controller.emailC.text = snapshot.data!["email"];
                controller.nameC.text = snapshot.data!["name"];
                controller.phoneC.text = snapshot.data!["phone"];
                return ListView(
                  padding: EdgeInsets.all(15),
                  children: [
                    TextField(
                      readOnly: true,
                      autocorrect: false,
                      controller: controller.emailC,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      autocorrect: false,
                      controller: controller.nameC,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      autocorrect: false,
                      controller: controller.phoneC,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() => TextField(
                          obscureText: controller.isHidden.value,
                          autocorrect: false,
                          controller: controller.passwordC,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () => controller.isHidden.toggle(),
                                icon: controller.isHidden.isTrue
                                    ? Icon(Icons.remove_red_eye)
                                    : Icon(Icons.remove_red_eye_outlined)),
                            labelText: "Password",
                            border: OutlineInputBorder(),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    GetBuilder<ProfileController>(
                      builder: (c) {
                        return Column(
                          children: [
                            snapshot.data?['profile'] != null
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7),
                                        color: const Color.fromARGB(255, 214, 214, 214),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data!['profile']),
                                          fit: BoxFit.cover,
                                        )),
                                  )
                                : c.image != null ? 
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7),
                                        color: const Color.fromARGB(255, 214, 214, 214),
                                        image: DecorationImage(
                                          image: FileImage(File(c.image!.path)),
                                          fit: BoxFit.cover,
                                        )),
                                  ) : 
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: const Color.fromARGB(255, 214, 214, 214),
                                    ),
                                    child: Text('No Choosen Image'),
                                  ),
                            TextButton(
                                onPressed: () => c.pickImage(),
                                child: Text('Choose Image'))
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() => ElevatedButton(
                        onPressed: () {
                          if (controller.isLoading.isFalse) {
                            controller.updateProfile();
                          }
                        },
                        child: Text(controller.isLoading.isFalse
                            ? "Update"
                            : "Loading"))),
                  ],
                );
              }
            }));
  }
}
