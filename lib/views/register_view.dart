import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tam_luy/controllers/register_controller.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final _controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign up Account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      Text("To continue"),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Name",
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                final name = nameController.text;
                                final email = emailController.text;
                                final password = passwordController.text;
                                _controller.register(
                                    email: email, password: password);
                              },
                              child: Text("Regiser"),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Login"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
