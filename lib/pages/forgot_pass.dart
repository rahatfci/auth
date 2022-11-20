import 'package:ecommerce/utils/design.dart';
import 'package:ecommerce/utils/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _phoneKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Stack(
          children: [
            topStyle(context),
            companyTitle(context),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.only(
                  left: 12, right: 12, top: 140, bottom: 8),
              elevation: 10,
              shadowColor: Colors.black54,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: 35),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Reset Password of",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            "assets/launcher_icon.png",
                            height: 40,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const ShowError(),
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _phoneKey,
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18),
                          keyboardType: TextInputType.phone,
                          controller: phone,
                          cursorColor: Colors.teal,
                          decoration: inputFieldStyle("Phone", Icons.phone),
                          validator: (value) => phoneValidator(value),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70.0),
                        child: Stack(
                          children: const [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Phone",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Or",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "Email",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Form(
                        key: _emailKey,
                        child: TextFormField(
                          style: const TextStyle(fontSize: 18),
                          keyboardType: TextInputType.emailAddress,
                          controller: email,
                          cursorColor: Colors.teal,
                          decoration: inputFieldStyle("Email", Icons.email),
                          validator: (value) => emailValidator(value),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (phone.text.isNotEmpty || email.text.isNotEmpty) {
                            if (_phoneKey.currentState!.validate()) {
                              _emailKey.currentState!.reset();
                            } else if (_emailKey.currentState!.validate()) {
                              _phoneKey.currentState!.reset();
                              showDialog(
                                  context: context,
                                  builder: (context) => const Center(
                                      child: CircularProgressIndicator()));
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: email.text.trim());
                                if (ShowError.msg.value.isNotEmpty) {
                                  ShowError.msg.value = "";
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Reset Link Sent. Open Email Please",
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor: Color(0xFFdc3545),
                                  ),
                                );
                                Navigator.popUntil(
                                    context, ModalRoute.withName('/'));
                              } on FirebaseAuthException catch (e) {
                                Navigator.pop(context);
                                if (e.code == "user-not-found") {
                                  ShowError.msg.value =
                                      "There is no user found on this email";
                                } else {
                                  ShowError.msg.value = e.message!;
                                }
                              }
                            }
                          } else {
                            if (phone.text.isNotEmpty) {
                              _phoneKey.currentState!.validate();
                              _emailKey.currentState!.reset();
                            } else if (email.text.isNotEmpty) {
                              _emailKey.currentState!.validate();
                              _phoneKey.currentState!.reset();
                            } else {
                              _phoneKey.currentState!.validate();
                              _emailKey.currentState!.validate();
                            }
                          }
                        },
                        child: const Text("Send Link"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Have an Account? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                              if (ShowError.msg.value.isNotEmpty) {
                                ShowError.msg.value = "";
                              }
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
