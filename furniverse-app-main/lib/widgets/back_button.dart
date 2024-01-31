import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 50,
        width: 50,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: SvgPicture.asset(
          'assets/icons/chevron_left.svg',
        ),
      ),
    );
  }
}
