import 'package:ecommerce/pages/forgot_pass.dart';
import 'package:ecommerce/pages/signup.dart';
import 'package:ecommerce/utils/auth.dart';
import 'package:ecommerce/utils/design.dart';
import 'package:ecommerce/utils/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();

  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
                  borderRadius: BorderRadius.circular(20)),
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
                            "Log in to",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
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
                            validator: (value) => emailValidator(value)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Form(
                        key: _passKey,
                        child: TextFormField(
                            style: const TextStyle(fontSize: 18),
                            keyboardType: TextInputType.visiblePassword,
                            controller: password,
                            cursorColor: Colors.teal,
                            decoration: inputFieldStyle("Password", Icons.lock),
                            validator: (value) => passwordValidator(value)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ForgotPass()));
                          },
                          child: const Text(
                            "Forgot Password ?",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if ((phone.text.isNotEmpty ||
                                    email.text.isNotEmpty) &&
                                _passKey.currentState!.validate()) {
                              if (_phoneKey.currentState!.validate()) {
                                _emailKey.currentState!.reset();
                                showDialog(
                                    context: context,
                                    builder: (context) => const Center(
                                        child: CircularProgressIndicator()));
                                SignInWithPhone(
                                    phone: phone.text.trim(), context: context);
                              } else if (_emailKey.currentState!.validate()) {
                                _phoneKey.currentState!.reset();
                                showDialog(
                                    context: context,
                                    builder: (context) => const Center(
                                        child: CircularProgressIndicator()));
                                await signInWithEmail(
                                    email: email.text.trim(),
                                    password: password.text.trim(),
                                    context: context);
                              }
                            } else {
                              _passKey.currentState!.validate();
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
                          child: const Text("Log In")),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "New Here? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpPage()));
                              if (ShowError.msg.value.isNotEmpty) {
                                ShowError.msg.value = "";
                              }
                            },
                            child: const Text("Create a new Account",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal)),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      orDivider(context),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        child: gLogin(text: "Sign in with Google"),
                        onTap: () async {
                          await signInWithGoogle(context: context);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                          child: fbLogin(text: "Sign in with Facebook"),
                          onTap: () async {
                            await signInWithFacebook(context);
                          }),
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
