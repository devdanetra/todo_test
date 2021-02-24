/*
 * Copyright (c) 2021. Francesco D'anetra (@devdanetra | devdanetra@outlook.com)
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User> _user = Rx<User>();
  RxInt _authType = 0.obs;
  RxBool _loading = false.obs;

  String get email => _user.value?.email;

  String get displayName => _user.value?.displayName;

  String get uid => _user.value?.uid;

  Stream get authStateStream => _auth.authStateChanges();


  int get authType => _authType.value;

  bool get loading => _loading.value;


  set authType (int value) {
    _authType.value = value;
    update();
  }

  @override
  void onInit() {
    _loading.value = true;
    _user.bindStream(authStateStream);
    authStateStream.listen((event) {
      print("AUTH EVENT | " + event.toString());
      if(event != null){
        Get.toNamed("/todo");
      }else{
        Get.offNamed("/auth");
      }
    });
    _loading.value = false;
    super.onInit();
  }

  Future<void> register(String email, String password) async {
    if(password.isEmpty || email.isEmpty)
      if(!Get.isSnackbarOpen)
        return Get.snackbar("Errore", "Password o email assenti");
      else if(!GetUtils.isEmail(email))
        if(!Get.isSnackbarOpen)
          return Get.snackbar("Errore", "Email non valida");
    _loading.value = true;
    try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
        _loading.value = false;
        if(!Get.isSnackbarOpen)
          Get.snackbar("Successo",'Utente creato.');

      } on FirebaseAuthException catch (e) { //auth errors handling
      _loading.value = false;
      if(Get.isSnackbarOpen)
        return;

        if (e.code == 'weak-password') {
          Get.snackbar("Errore registrazione",'Questa password è troppo debole.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Errore registrazione",'Questa email è già in uso.');
        }else  if (e.code == "invalid-email")
            Get.snackbar("Errore", "Email non valida");

    } catch (e) {//general errors handling
      _loading.value = false;
      if(!Get.isSnackbarOpen)
      Get.snackbar("Errore Interno", "Impossibile registrarsi");
    }
  }

  Future<void> login(String email, String password) async {

    if(email.isEmpty || password.isEmpty)
      if(!Get.isSnackbarOpen)
        return Get.snackbar("Errore", "Password o email assenti");

      else if(!GetUtils.isEmail(email))
        if(!Get.isSnackbarOpen)
          return Get.snackbar("Errore", "Email non valida");

    _loading.value = true;
    try {

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      _loading.value = false;
      if(!Get.isSnackbarOpen)
        Get.snackbar("Benvenuto",'Utente Loggato.');

    } on FirebaseAuthException catch (e) { //auth errors handling
      _loading.value = false;

      if(Get.isSnackbarOpen && !Get.isSnackbarOpen)
        if (e.code == "invalid-email"){
            Get.snackbar("Errore", "Email non valida");
        }else if (e.code == "wrong-password"){
            Get.snackbar("Errore", "Dati di accesso errati");
        }
    } catch (e) {//general errors handling
      _loading.value = false;
      if(!Get.isSnackbarOpen)
        Get.snackbar("Errore Interno", "Impossibile registrarsi");
    }
  }

  Future<void> signOut() async {
    _loading.value = true;
    try {
      await _auth.signOut();
      if(!Get.isSnackbarOpen)
        Get.snackbar("Arrivederci", "Logout eseguito");
      _loading.value = false;
    } catch (e) {
      _loading.value = false;
      if(!Get.isSnackbarOpen)
        Get.snackbar("Errore Interno", "Impossibile eseguire logout");
    }
  }
}