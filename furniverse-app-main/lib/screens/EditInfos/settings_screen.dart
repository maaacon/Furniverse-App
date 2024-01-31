import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniverse/main.dart';
import 'package:furniverse/screens/EditInfos/changepass.dart';
import 'package:furniverse/screens/EditInfos/updateemail.dart';
import 'package:furniverse/screens/LoginAndRegistration/emailforgetpass.dart';
import 'package:furniverse/services/firebase_auth_service.dart';
import 'package:furniverse/widgets/confirmation_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  
  final AuthService _auth = AuthService();

 @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.currentUser!.reload();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset('assets/icons/chevron_left.svg'),
                  ),
                  const Column(
                    children: [
                      Text(
                        'SETTINGS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF303030),
                          fontSize: 16,
                          fontFamily: 'Avenir Next LT Pro',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 24,
                  )
                ],
              ),
              const SizedBox(height: 28),
              const SizedBox(height: 28),
              SettingNavigation(
                  title: 'Change Email',
                  subtitle: 'sample@gmail.com',
                  onTap: () {Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdateEmail(),
                      ),
                    );}),
              const SizedBox(height: 15),
              SettingNavigation(
                  title: 'Change Password',
                  subtitle: '*************',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) =>const ChangePass()),
                    );
                  }),
              const SizedBox(height: 15),
              // SettingNavigation(
              //     title: 'Notification Settings',
              //     subtitle: 'Manage your notification preferences',
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const NotificationSettings(),
              //         ),
              //       );
              //     }),
              const SizedBox(height: 15),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFD38080),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0x338A959E),
                      blurRadius: 40,
                      offset: Offset(0, 7),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationAlertDialog(
                        title: "Are you sure you want to delete this account?\n\n\nNote: You must relog-in before deleting the account.",
                        onTapNo: () { Navigator.pop(context); },
                        onTapYes: () {  
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmationAlertDialog(
                              title: "Remember: This is irreversible. Do you want to proceed?",
                              onTapNo: () { Navigator.pop(context); },
                              onTapYes: () async { 
                                await _auth.deleteaccount();
                                _auth.signOut();
                                navigatorKey.currentState!.popUntil((route) => route.isFirst);
                                Fluttertoast.showToast(
                                  msg: "Deleted Successfully.",
                                  backgroundColor: Colors.grey,
                                );
                              },
                              tapNoString: "No",
                              tapYesString: "Yes"
                            ),
                          );
                        },
                        tapNoString: "No",
                        tapYesString: "Yes"
                      ),
                    );
                  },
                  title: const Text(
                    'Account Deletion',
                    style: TextStyle(
                      color: Color(0xFF303030),
                      fontSize: 18,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text(
                    'Delete your existing account',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color(0xff303030),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ConfirmationAlertDialog(
                  title: "Are you sure you want to log out?",
                  onTapNo: () { Navigator.pop(context); },
                  onTapYes: () async {     
                    await _auth.signOut();
                    navigatorKey.currentState!.popUntil((route) => route.isFirst);
                    Fluttertoast.showToast(
                      msg: "Logged Out Successfully.",
                      backgroundColor: Colors.grey,
                    );
                  },
                  tapNoString: "No",
                  tapYesString: "Yes"
                ),
              );
            },
            child: const Center(
              child: Text(
                'LOGOUT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingNavigation extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function() onTap;

  const SettingNavigation({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x338A959E),
            blurRadius: 40,
            offset: Offset(0, 7),
            spreadRadius: 0,
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF303030),
            fontSize: 18,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            color: Color(0xFF808080),
            fontSize: 12,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          size: 24,
        ),
      ),
    );
  }
}
