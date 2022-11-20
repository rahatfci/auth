import 'package:ecommerce/pages/enter_code.dart';
import 'package:ecommerce/utils/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

signUpWithEmail(
    {required String email,
    required String password,
    required String name,
    required BuildContext context}) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      value.user!.updateDisplayName(name);
    });
    Navigator.popUntil(context, ModalRoute.withName('/'));
    if (ShowError.msg.value.isNotEmpty) ShowError.msg.value = "";
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context);
    ShowError.msg.value = e.message!;
  }
}

Future<void> signInWithEmail({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    FirebaseAuth.instance;
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Navigator.popUntil(context, ModalRoute.withName('/'));
    if (ShowError.msg.value.isNotEmpty) ShowError.msg.value = "";
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context);
    if (e.code == "user-not-found") {
      ShowError.msg.value = "There is no user found on this email";
    } else {
      ShowError.msg.value = e.message!;
    }
  }
}

signInWithGoogle(
    {bool link = false,
    AuthCredential? authCredential,
    required BuildContext context}) async {
  final GoogleSignInAccount? googleSignInAccount =
      await GoogleSignIn().signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    try {
      showDialog(
          context: context,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (link) {
        await userCredential.user!.linkWithCredential(authCredential!);
      }
      Navigator.popUntil(context, ModalRoute.withName('/'));
      if (ShowError.msg.value.isNotEmpty) ShowError.msg.value = "";
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ShowError.msg.value = e.message!;
    }
  } else {
    ShowError.msg.value = "No account selected";
  }
}

signInWithFacebook(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()));
  final LoginResult loginResult = await FacebookAuth.instance.login();

  final OAuthCredential credential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

  try {
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.popUntil(context, ModalRoute.withName('/'));
    if (ShowError.msg.value.isNotEmpty) ShowError.msg.value = "";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'account-exists-with-different-credential') {
      List<String> emailList =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(e.email!);
      if (emailList.first == "google.com") {
        await signInWithGoogle(
            link: true, authCredential: e.credential, context: context);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    } else {
      ShowError.msg.value = e.message!;
    }
  }
}

class SignInWithPhone {
  BuildContext context;
  String? name;
  String phone;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool simOnPhone = false;
  SignInWithPhone({required this.phone, required this.context, this.name}) {
    phoneSignIn();
  }

  phoneSignIn() async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          timeout: const Duration(seconds: 120));
      if (ShowError.msg.value.isNotEmpty) ShowError.msg.value = "";
    } on FirebaseAuthException catch (e) {
      ShowError.msg.value = e.message!;
    }
  }

  verificationCompleted(PhoneAuthCredential credential) async {
    try {
      await auth.signInWithCredential(credential).then((value) async {
        if (name != null) await value.user!.updateDisplayName(name);
      });
      if (ShowError.msg.value.isNotEmpty) ShowError.msg.value = "";
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ShowError.msg.value = e.message!;
    }
  }

  verificationFailed(FirebaseAuthException e) {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    if (e.code == 'invalid-phone-number') {
      ShowError.msg.value = 'This phone number is not valid.';
    } else if (e.code == 'invalid-format') {
      ShowError.msg.value = 'This phone number format is not valid.';
    } else {
      ShowError.msg.value = e.message!;
    }
  }

  codeSent(String verificationId, int? forceResendingToken) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EnterCode(
                  verificationId: verificationId,
                  name: name,
                )));
    if (ShowError.msg.value.isNotEmpty) {
      ShowError.msg.value = "";
    }
  }

  codeAutoRetrievalTimeout(String timeout) {}
}

signOut(BuildContext context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()));
  try {
    final _providerData = _auth.currentUser!.providerData;
    if (_providerData.isNotEmpty) {
      if (_providerData[0].providerId.toLowerCase().contains('google')) {
        await GoogleSignIn().signOut();
      } else if (_providerData[0]
          .providerId
          .toLowerCase()
          .contains('facebook')) {
        await FacebookAuth.instance.logOut();
      }
    }

    await _auth.signOut();
    if (ShowError.msg.value.isNotEmpty) {
      ShowError.msg.value = "";
    }
  } catch (e) {
    ShowError.msg.value = "Something went wrong";
  }

  Navigator.popUntil(context, ModalRoute.withName('/'));
}
