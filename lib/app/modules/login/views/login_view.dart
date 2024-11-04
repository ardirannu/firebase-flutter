import 'package:firebase_auth_crud/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginView'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextField(
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
              Obx(
                () => ElevatedButton(
                  onPressed: () {
                    if(controller.isLoading.isFalse){
                      controller.login();
                    }
                  }, 
                  child: Text(controller.isLoading.isFalse ? "Login" : "Loading"))
                ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.offAllNamed(Routes.REGISTER), 
                  child: Text("Register")
                )
              ),
            ],
          ),
        )
    );
  }
}
