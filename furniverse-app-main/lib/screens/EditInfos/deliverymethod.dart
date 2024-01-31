import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DeliveryMethod extends StatefulWidget {
  Function onTap;
  DeliveryMethod({super.key, required this.onTap});

  @override
  State<DeliveryMethod> createState() => _DeliveryMethodState();
}

class _DeliveryMethodState extends State<DeliveryMethod> {
  final bool _isCheckedninja = false;
  final bool _isCheckedjandt = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xFFF0F0F0),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: const Text(
            'DELIVERY METHOD',
            style: TextStyle(
              color: Color(0xFF303030),
              fontSize: 16,
              fontFamily: 'Avenir Next LT Pro',
              fontWeight: FontWeight.w700,
            ),
          )),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.onTap(0);
                  });
                  Navigator.pop(context);
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const LogIn(),
                  //   ),
                  // );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/jandt.jpg'),
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "J&T Express (5 - 7 days)",
                            style: TextStyle(
                              color: Color(0xFF545454),
                              fontSize: 18,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(10),
              // CheckboxListTile(
              //   activeColor: Colors.black,
              //   title: const Text(
              //     'Use as default delivery method',
              //     style: TextStyle(
              //       color: Color(0xFF222222),
              //       fontSize: 14,
              //       fontFamily: 'Nunito Sans',
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              //   value: _isCheckedjandt,
              //   controlAffinity: ListTileControlAffinity.leading,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       _isCheckedjandt = value!;
              //     });
              //     if ((_isCheckedjandt == true && _isCheckedninja == false)) {
              //       print("j&t");
              //     }

              //     if ((_isCheckedjandt == false && _isCheckedninja == true)) {
              //       print("ninja");
              //     }
              //   },
              // ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.onTap(1);
                  });
                  Navigator.pop(context);
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const LogIn(),
                  //   ),
                  // );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/ninjavan.jpg'),
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "NinjaVan (10 days)",
                            style: TextStyle(
                              color: Color(0xFF545454),
                              fontSize: 18,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // CheckboxListTile(
              //   activeColor: Colors.black,
              //   title: const Text(
              //     'Use as default delivery method',
              //     style: TextStyle(
              //       color: Color(0xFF222222),
              //       fontSize: 14,
              //       fontFamily: 'Nunito Sans',
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              //   value: _isCheckedninja,
              //   controlAffinity: ListTileControlAffinity.leading,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       _isCheckedninja = value!;
              //     });
              //     if ((_isCheckedjandt == true && _isCheckedninja == false)) {
              //       print("j&t");
              //     }

              //     if ((_isCheckedjandt == false && _isCheckedninja == true)) {
              //       print("ninja");
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
