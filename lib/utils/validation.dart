import 'package:flutter/material.dart';

String? nameValidator(String? name) {
  if (name!.isEmpty) {
    return "Name can't be Empty";
  } else if (name.length >= 60) {
    return "Name is too long";
  }
}

String? phoneValidator(String? phone) {
  if (phone!.isEmpty) {
    return "Please enter a phone number";
  } else if (!RegExp(
          r"^\+((?:9[679]|8[035789]|6[789]|5[90]|42|3[578]|2[1-689])|9[0-58]|8[1246]|6[0-6]|5[1-8]|4[013-9]|3[0-469]|2[70]|7|1)(?:\W*\d){0,13}\d$")
      .hasMatch(phone)) {
    return "Please enter the country code (e.g. +880)";
  } else if (phone.substring(0, 4) == "+880" && phone.length < 14) {
    return "Please enter a valid number";
  }
}

String? emailValidator(String? email) {
  if (email!.isEmpty) {
    return "Please enter an email";
  } else if (email.length >= 30) {
    return "Email is too long";
  } else if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email)) {
    return "Enter a valid email";
  }
}

String? passwordValidator(String? password) {
  if (password!.isEmpty) {
    return "Password can't be empty";
  } else if (password.length < 6) {
    return "Password must be greater than 6 character";
  }
}

class ShowError extends StatefulWidget {
  const ShowError({Key? key}) : super(key: key);
  static ValueNotifier<String> msg = ValueNotifier("");
  @override
  _ShowErrorState createState() => _ShowErrorState();
}

class _ShowErrorState extends State<ShowError> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ShowError.msg,
        builder: (context, msg, child) {
          return ShowError.msg.value.isNotEmpty
              ? Center(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xFFdc3545),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              ShowError.msg.value,
                              softWrap: true,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                )
              : const SizedBox.shrink();
        });
  }
}
