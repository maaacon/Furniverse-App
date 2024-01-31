
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse/screens/LoginAndRegistration/emailforgetpass.dart';
import 'package:furniverse/main.dart';
import 'package:furniverse/services/firebase_auth_service.dart';
import 'package:furniverse/services/messaging_service.dart';
import 'package:furniverse/services/user_service.dart';
import 'package:furniverse/shared/loading.dart';

class LogIn extends StatefulWidget {
  final Function toggleView;

  const LogIn({super.key, required this.toggleView});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  final _emailController = TextEditingController();
  final _passworController = TextEditingController();

  final AuthService _auth = AuthService();
  bool loading = false;
  String error = '';

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
                          validator: (value) =>
                              value != null && value.length < 8
                                  ? 'Enter valid password. (It must be more than 8 characters.)'
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
                              // onPressed: logIn,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // loading screen
                                  setState(() => loading = true);
                                  // signing in
                                  dynamic result = await _auth.signIn(
                                    _emailController.text.trim(),
                                    _passworController.text.trim(),
                                  );

                                  if (result == null) {
                                    // error =
                                    //     'could not sign in with entered credentials';
                                    Fluttertoast.showToast(
                                      msg: "Invalid Email or Password",
                                      backgroundColor: Colors.grey,
                                    );
                                    setState(() {
                                      loading = false;
                                    });
                                  } else {
                                    UserService().updateToken(
                                      newToken: await MessagingService().initNotification() ?? "",
                                      userId: result.uid);

                                       Fluttertoast.showToast(
                                        msg: "Log In Succesfully",
                                        backgroundColor: Colors.grey,
                                      );
                                    print(result.uid);
                                  }
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
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w400,
                                  ),
                            ),
                            TextButton(
                                onPressed: () {
                                  widget.toggleView();
                                  // Navigator.of(context).pushReplacement(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const Registration(),
                                  //   ),
                                  // );
                                },
                                child: const Text(
                                  "SIGN UP",
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

  // Future createUser({required String email}) async {
  //   final docUser = FirebaseFirestore.instance.collection('Users');
  //   final json = {
  //     'email': email,
  //     'age': 21,
  //   };

  //   await docUser.add(json);
  // }

  Future logIn() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

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
    }  catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.grey,
      );
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
