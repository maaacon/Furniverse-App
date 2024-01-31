import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse_admin/screens/admin_home/pages/changeemailnotice.dart';

class UpdateEmail extends StatefulWidget {
  const UpdateEmail({super.key});

  @override
  State<UpdateEmail> createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: const Color(0xFFF0F0F0),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 76),
                  Center(child: SvgPicture.asset('assets/icons/PrimaryIcon.svg')),
                  const SizedBox(height: 40),
                  const Text(
                    "CHANGE",
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
                  const Text(
                    "EMAIL",
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
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      labelText: 'Email',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                        ? 'Enter valid email'
                        : null,
                  ),
                  const SizedBox(height: 40),
                  Center(
                      child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        resetEmail(_emailController.text);
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (context) =>const ForgetPassNotice(),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text(
                        "SUBMIT",
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
                  const SizedBox(height: 50),

                  const Text(
                    "Note: You must re-login first to change your email.",
                    style: TextStyle(
                      color: Color(0xFF303030),
                      fontSize: 14,
                      fontFamily: 'Avenir Next LT Pro',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future resetEmail(String? newEmail) async {
    final isValid =_formKey.currentState!.validate();
      if (!isValid) return;
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.verifyBeforeUpdateEmail(newEmail!);
      FirebaseAuth.instance.signOut();
     Navigator.of(context).push(
      MaterialPageRoute( builder: (context) =>const ChangeEmailNotice()),
     );

    } on FirebaseAuthException catch (e) {
      print(e);
    }
   
    print(newEmail);
  } 
}
