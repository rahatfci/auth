import 'dart:async';

import 'package:ecommerce/utils/design.dart';
import 'package:ecommerce/utils/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EnterCode extends StatefulWidget {
  const EnterCode({Key? key, required this.verificationId, this.name})
      : super(key: key);
  final String verificationId;
  final String? name;
  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();
  Timer? timer;
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      Future(() async {
        timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
          if (FirebaseAuth.instance.currentUser != null) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
            timer.cancel();
          }
        });
      });
    } else {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
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
                const EdgeInsets.only(left: 15, right: 15, top: 140, bottom: 5),
            elevation: 10,
            shadowColor: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 20, top: 40),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Enter OTP",
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
                      height: 25,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OtpInput(_fieldOne, first: true, last: false),
                          OtpInput(_fieldTwo, first: false, last: false),
                          OtpInput(_fieldThree, first: false, last: false),
                          OtpInput(_fieldFour, first: false, last: false),
                          OtpInput(_fieldFive, first: false, last: false),
                          OtpInput(_fieldSix, first: false, last: true),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          String smsCode = _fieldOne.text.trim() +
                              _fieldTwo.text.trim() +
                              _fieldThree.text.trim() +
                              _fieldFour.text.trim() +
                              _fieldFive.text.trim() +
                              _fieldSix.text.trim();
                          if (smsCode.isNotEmpty) {
                            try {
                              PhoneAuthCredential _credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: widget.verificationId,
                                      smsCode: smsCode);
                              await FirebaseAuth.instance
                                  .signInWithCredential(_credential)
                                  .then((value) async {
                                await value.user!
                                    .updateDisplayName(widget.name);
                              });
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/'));
                            } on FirebaseAuthException catch (e) {
                              ShowError.msg.value = e.message!;
                            }
                          } else {
                            ShowError.msg.value = "Enter OTP";
                          }
                        },
                        child: const Text('Submit')),
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

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool last;
  final bool first;
  const OtpInput(this.controller,
      {required this.first, required this.last, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        height: 50,
        width: 40,
        child: TextField(
          autofocus: true,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: controller,
          maxLength: 1,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          cursorColor: Theme.of(context).primaryColor,
          decoration: const InputDecoration(
              enabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(width: 2)),
              border: UnderlineInputBorder(borderSide: BorderSide(width: 2)),
              counterText: ""),
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      ),
    );
  }
}
