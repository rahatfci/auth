import 'package:ecommerce/pages/email_verification.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/utils/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            User? user = FirebaseAuth.instance.currentUser;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.teal));
            } else if (snapshot.hasError) {
              ShowError.msg.value = "Something Went Wrong";
              if (user != null) {
                return const HomePage();
              } else {
                return const LoginPage();
              }
            } else if (snapshot.hasData) {
              if (ShowError.msg.value.isNotEmpty) {
                ShowError.msg.value = "";
              }
              if (user!.phoneNumber != null || user.emailVerified) {
                return const HomePage();
              }
              user.sendEmailVerification();
              return EmailVerify(user: user);
            } else {
              return const LoginPage();
            }
          }),
    ),
    theme: ThemeData(
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        primary: Colors.teal,
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      )),
      primarySwatch: Colors.teal,
    ),
  ));
}
