import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse/models/notif.dart';
import 'package:furniverse/screens/LoginAndRegistration/emailverification.dart';
import 'package:furniverse/main.dart';
import 'package:furniverse/services/firebase_auth_service.dart';
import 'package:furniverse/services/notification_service.dart';
import 'package:furniverse/shared/loading.dart';

class Registration extends StatefulWidget {
  final Function toggleView;
  const Registration({super.key, required this.toggleView});

  @override
  State<Registration> createState() => _Registration();
}

class _Registration extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscure1 = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final AuthService _auth = AuthService();
  String error = '';

  bool loading = false;

  String token = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value!;
      });
    });
    return loading
        ? const Loading()
        : SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF0F0F0),
              body: SingleChildScrollView(
                // physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 76),
                        Center(
                            child: SvgPicture.asset(
                                'assets/icons/PrimaryIcon.svg')),
                        const SizedBox(height: 40),
                        const Text(
                          "WELCOME TO",
                          style: TextStyle(
                            color: Color(0xFF303030),
                            fontSize: 30,
                            fontFamily: 'Avenir Next LT Pro',
                            fontWeight: FontWeight.w700,
                            height: 0.04,
                            letterSpacing: 1.50,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "FURNI",
                              style: TextStyle(
                                color: Color(0xFFF6BE2C),
                                fontSize: 30,
                                fontFamily: 'Avenir Next LT Pro',
                                fontWeight: FontWeight.w700,
                                height: 0.04,
                                letterSpacing: 1.50,
                              ),
                            ),
                            Text(
                              "VERSE",
                              style: TextStyle(
                                color: Color(0xFF303030),
                                fontSize: 30,
                                fontFamily: 'Avenir Next LT Pro',
                                fontWeight: FontWeight.w700,
                                height: 0.04,
                                letterSpacing: 1.50,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Name',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value!.isEmpty ? 'Please input a name.' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Email',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Enter valid email'
                                  : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Password',
                            suffixIcon: togglePassword(),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 8
                                  ? 'Enter valid password. (It must be more than 8 characters.)'
                                  : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmpasswordController,
                          obscureText: _isObscure1,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            labelText: 'Confirm Password',
                            suffixIcon: toggleConfirmPassword(),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 8
                                  ? 'Enter valid password. (It must be more than 8 characters.)'
                                  : null,
                        ),
                        const SizedBox(height: 20),
                        Center(
                            child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_passwordController.text ==
                                      _confirmpasswordController.text &&
                                  _formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });

                                Map<String, dynamic> shippingAddress = {
                                  'street': "",
                                  'baranggay': "",
                                  'city': "",
                                  'province': "",
                                  'zipCode': "",
                                };

                                User? result = await _auth.signUp(
                                    email: _emailController.text.trim(),
                                    name: _nameController.text,
                                    password: _passwordController.text.trim(),
                                    token: token,
                                    shippingAddress: shippingAddress);

                                if (result == null) {
                                  setState(() {
                                    error = 'please supply a valid email';
                                    loading = false;
                                  });
                                } else {
                                  NotificationService().addNotification(
                                  NotificationModel(
                                    userId: result!.uid,
                                    notifTitle: "Welcome to Furniverse!",
                                    notifSubtitle:
                                          "Unlock the Door to Your Dream Space 🛋️✨",
                                    isViewed: false),
                                  );
                                }
                              } else if (_passwordController.text !=
                                  _confirmpasswordController.text) {
                                Fluttertoast.showToast(
                                    msg: "Password doesn't match.",
                                    backgroundColor: Colors.grey);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        )),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                                onPressed: () {
                                  widget.toggleView();
                                  // Navigator.of(context).pushReplacement(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const LogIn(),
                                  //   ),
                                  // );
                                },
                                child: const Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w700,
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isObscure = !_isObscure;
        });
      },
      icon: _isObscure
          ? const Icon(Icons.visibility_off)
          : const Icon(Icons.visibility),
      color: Colors.grey,
    );
  }

  Widget toggleConfirmPassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isObscure1 = !_isObscure1;
        });
      },
      icon: _isObscure1
          ? const Icon(Icons.visibility_off)
          : const Icon(Icons.visibility),
      color: Colors.grey,
    );
  }

  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      User? result = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim()))
          .user;

      FirebaseFirestore.instance.collection('users').doc(result?.uid).set({
        'name': _nameController.text,
        'uid': result?.uid,
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: error.message.toString(), backgroundColor: Colors.grey);
      });

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: ((context) => const EmailVerification())),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, backgroundColor: Colors.grey);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
