import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class addAddressPage extends StatelessWidget {
  const addAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                        'ADD SHIPPING ADDRESS',
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
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
                  suffixIcon: SvgPicture.asset('assets/icons/right_black.svg'),
                  border: InputBorder.none,
                  hintText: 'Enter your promo code',
                  hintStyle: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: () => print('add all to cart'),
          child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              width: double.infinity,
              decoration: ShapeDecoration(
                color: const Color(0xFF303030),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F303030),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  'SAVE ADDRESS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
