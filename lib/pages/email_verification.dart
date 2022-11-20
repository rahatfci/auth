import 'dart:async';

import 'package:ecommerce/utils/auth.dart';
import 'package:ecommerce/utils/design.dart';
import 'package:ecommerce/utils/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({Key? key, this.user}) : super(key: key);
  final User? user;
  @override
  _EmailVerifyState createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    Future(() async {
      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        await widget.user!.reload();
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          topStyle(context),
          companyTitle(context),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin:
                const EdgeInsets.only(left: 12, right: 12, top: 140, bottom: 5),
            elevation: 10,
            shadowColor: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 20, top: 40),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Verify Email",
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const ShowError(),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Your account has been created. But you have to verify"
                      " it by clicking the verification link that has "
                      "been sent to your email. Then come back to the app.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, height: 1.2),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await signOut(context);
                      },
                      child: const Text("Get Back"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
