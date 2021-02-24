/*
 * Copyright (c) 2021. Francesco D'anetra (@devdanetra | devdanetra@outlook.com)
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_test_for_apey/controllers/AuthController.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());

    return Scaffold(
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              child: Center(
                child: (authController.loading) ? CircularProgressIndicator() : Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 100),
                      Text(
                        "Autenticazione",
                        style: GoogleFonts.montserrat(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(height: 40),
                      AuthForm()
                    ],
                  ),
                ),
              ),
            )));
  }
}

class AuthForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    TextEditingController emailController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();
    FocusNode passwordFocus = new FocusNode();
    AuthController authController = Get.find();

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
              height: 50,
              width: 250,
              child: TextField(
                autofocus: true,
                textInputAction: TextInputAction.next,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(passwordFocus),
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              width: 250,
              child: TextField(
                focusNode: passwordFocus,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => passwordFocus.unfocus(),
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            SizedBox(height: 50),
            Obx(() => authController.loading
                ? CircularProgressIndicator()
                : MaterialButton(
                    onPressed: () async {
                      if (authController.authType == 0) {
                        authController.register(
                            emailController.text, passwordController.text);
                      } else {
                        authController.login(
                            emailController.text, passwordController.text);
                      }
                    },
                    child: Text(authController.authType == 0 ? "Sign up" : "Login",
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.white),
                    ),
                    color: Theme.of(context).accentColor,
                    minWidth: 200,
                  ),),
            SizedBox(height: 10),
            Obx(() => authController.loading
                ? Container()
                : GestureDetector(
                    onTap: () {
                      authController.authType == 0
                          ? authController.authType = 1
                          : authController.authType = 0;
                    },
                    child: Text(authController.authType == 0 ? "Già registrato?": "Nuovo utente?"),
                  ),),
            SizedBox(height: 50)
          ],
        ));
  }
}
