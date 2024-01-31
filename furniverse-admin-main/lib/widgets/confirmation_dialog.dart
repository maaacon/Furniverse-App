import 'package:flutter/material.dart';

class ConfirmationAlertDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final Function onTapNo;
  final Function onTapYes;
  final String tapNoString;
  final String tapYesString;
  final Widget? boldContent;

  const ConfirmationAlertDialog(
      {Key? key,
      required this.title,
      this.content,
      this.boldContent,
      required this.onTapNo,
      required this.onTapYes,
      required this.tapNoString,
      required this.tapYesString,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Stack(
            children: [
              Center(
                child: Stack(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(
                              color: const Color(0xffa7a6a5),
                            ),
                          ),
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const SizedBox(height: 48),
                              title.isNotEmpty
                                ? Text(title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                : const SizedBox.shrink(),

                                title.isNotEmpty
                                  ? const SizedBox(height: 20)
                                  : const SizedBox.shrink(),

                                content ?? const SizedBox(),
                                content != null
                                  ? const SizedBox(height: 24)
                                  : const SizedBox(),

                                boldContent ?? const SizedBox(),
                                boldContent != null
                                  ? const SizedBox(height: 24)
                                  : const SizedBox(),

                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:BorderRadius.circular(30.0),
                                            )
                                          ),
                                          backgroundColor:
                                            MaterialStateProperty.all(Colors.black),
                                        ),

                                        onPressed: () => onTapNo(),
                                        child: Text(tapNoString,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12
                                          ),
                                        )
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:BorderRadius.circular(30.0),
                                            )
                                          ),
                                          backgroundColor:
                                            MaterialStateProperty.all(Colors.black),
                                        ),

                                        onPressed: () => onTapYes(),
                                        child: Text(tapYesString,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12
                                          ),
                                        )
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),

                    Positioned(
                      right: 0.0,
                      left: 0.0,
                      top: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Align(
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            radius: 32.0,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.question_mark_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
