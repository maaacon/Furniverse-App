import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:furniverse_admin/shared/constants.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: const Center(
        child: SpinKitChasingDots(
          color: foregroundColor,
          size: 50.0,
        ),
      ),
    );
  }
}
