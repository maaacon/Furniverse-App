import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse_admin/screens/LoginandLogout/emailforgetpass.dart';
import 'package:furniverse_admin/services/auth_services.dart';
import 'package:furniverse_admin/shared/loading.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthService _auth = AuthService();
  bool loading = false;
  String error = '';

  bool _isObscure = true;
  final _emailController = TextEditingController();
  final _passworController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passworController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF0F0F0),
              body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 76),

                      Center(
                          child:
                              SvgPicture.asset('assets/icons/PrimaryIcon.svg')),

                      const SizedBox(height: 40),

                      const Text(
                        "Hello!",
                        style: TextStyle(
                          color: Color(0xFF909090),
                          fontSize: 30,
                          fontFamily: 'Avenir Next LT Pro',
                          fontWeight: FontWeight.w400,
                          height: 0.05,
                        ),
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "WELCOME BACK",
                        style: TextStyle(
                          color: Color(0xFF303030),
                          fontSize: 30,
                          fontFamily: 'Avenir Next LT Pro',
                          fontWeight: FontWeight.w700,
                          height: 0.04,
                          letterSpacing: 1.50,
                        ),
                      ),

                      const SizedBox(height: 76),

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
                        obscureText: _isObscure,
                        controller: _passworController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: 'Password',
                          suffixIcon: togglePassword(),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 8
                            ? 'Enter valid password'
                            : null,
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmailForgetPass(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Click here.",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                        ],
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() => loading = true);

                              dynamic result = await _auth.signIn(
                                _emailController.text.trim(),
                                _passworController.text.trim(),
                              );
                              if (result == null) {
                                Fluttertoast.showToast(
                                  msg: "Invalid Email or Password",
                                  backgroundColor: Colors.grey,
                                );
                                setState(() {
                                  loading = false;
                                });
                              } else {
                                // print(result.uid);
                                Fluttertoast.showToast(
                                  msg: "Log In Succesfully",
                                  backgroundColor: Colors.grey,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: const Text(
                              "LOG IN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        )
                      ),

                      const SizedBox(height: 10),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     const Text("Don't have an account?"),
                      //     TextButton(onPressed: () {Navigator.of(context).pushReplacement(
                      //           MaterialPageRoute(
                      //             builder: (context) => const Registration(),
                      //             ),
                      //           );
                      //         },
                      //       child: const Text("SIGN UP", style: TextStyle(
                      //         color:  Colors.black,
                      //         fontSize: 14,
                      //         fontFamily: 'Nunito Sans',
                      //         fontWeight: FontWeight.w700,
                      //         ),
                      //       )
                      //     ),
                      //   ],
                      // )
                    ],
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

  Future createUser({required String email}) async {
    final docUser = FirebaseFirestore.instance.collection('Users');
    final json = {
      'email': email,
      'age': 21,
    };

    await docUser.add(json);
  }

  Future LogIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      User? result = (await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passworController.text.trim()))
          .user;
      print(result?.uid);
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    //navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
