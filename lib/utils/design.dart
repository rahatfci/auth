import 'package:flutter/material.dart';

InputDecoration inputFieldStyle(String label, IconData icon) {
  return InputDecoration(
    border: const UnderlineInputBorder(),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 4),
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
    hintText: label,
    prefixIcon: Icon(
      icon,
    ),
    hintStyle: const TextStyle(fontSize: 16),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.teal, width: 4),
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
}

Widget topStyle(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height / 4,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.teal,
            Colors.teal.shade800,
          ],
        ),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
  );
}

Widget companyTitle(BuildContext context) {
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 11,
      ),
      child: const Text("ECOMMERCE",
          style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              letterSpacing: 1,
              fontWeight: FontWeight.bold)),
    ),
  );
}

Widget orDivider(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Stack(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.black,
              height: 1.5,
              width: MediaQuery.of(context).size.width / 3.5,
            )),
        const Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Or",
            style: TextStyle(
                height: .5, fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ),
        Align(
            alignment: Alignment.topRight,
            child: Container(
              color: Colors.black,
              height: 1.5,
              width: MediaQuery.of(context).size.width / 3.5,
            ))
      ],
    ),
  );
}

Widget gLogin({required String text}) {
  return Container(
      height: 45,
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFF4285F4),
      ),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                "assets/g-logo.png",
                fit: BoxFit.fitHeight,
              )),
          Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ))
        ],
      ));
}

Widget fbLogin({required String text}) {
  return Container(
      height: 45,
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFF0072E7),
      ),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  "assets/f-logo.png",
                  fit: BoxFit.fitHeight,
                ),
              )),
          Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ))
        ],
      ));
}
