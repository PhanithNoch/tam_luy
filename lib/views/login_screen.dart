import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tam_luy/controllers/login_controller.dart';
import 'package:tam_luy/views/register_view.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController(text: "user@gmail.com");
  final passwordController = TextEditingController(text: "user@gmail.com");
  final _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 120,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tam Luy',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      Text("Tracking Your Income & Expense"),
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
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Obx(() {
                        return Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: _controller.isLoading.value
                                    ? null
                                    : () {
                                        final email = emailController.text;
                                        final pass = passwordController.text;
                                        _controller.signIn(
                                            email: email, password: pass);
                                      },
                                child: _controller.isLoading.value
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text("Login"),
                              ),
                            )
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont' have an account?"),
                  TextButton(
                      onPressed: () {
                        Get.to(() => RegisterView(),
                            transition: Transition.leftToRight);
                      },
                      child: Text("Register")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
