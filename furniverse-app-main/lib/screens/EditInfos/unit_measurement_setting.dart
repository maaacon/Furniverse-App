import 'package:flutter/material.dart';
import 'package:furniverse/services/user_service.dart';

Map<int, String> units = {0: 'Inches (in)', 1: 'Meters (m)', 2: 'Feet (ft)'};

class UnitMeasurementSettingPage extends StatefulWidget {
  final String userId;
  final String unitMeasure;
  const UnitMeasurementSettingPage(
      {super.key, required this.userId, required this.unitMeasure});

  @override
  State<UnitMeasurementSettingPage> createState() =>
      _UnitMeasurementSettingPageState();
}

class _UnitMeasurementSettingPageState
    extends State<UnitMeasurementSettingPage> {
  bool isPushNotif = false;
  bool isEmailNotif = false;
  String selectedLength = 'Inches (in)';

  @override
  void initState() {
    super.initState();
    if (widget.unitMeasure != "")
      selectedLength = widget.unitMeasure == 'm'
          ? 'Meters (m)'
          : widget.unitMeasure == 'in'
              ? 'Inches (in)'
              : 'Feet (ft)';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'MEASUREMENT SETTINGS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF303030),
              fontSize: 16,
              fontFamily: 'Avenir Next LT Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  'Measure of Length:',
                  style: TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: DropdownButton<String>(
                  value: selectedLength,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLength = newValue!;
                      UserService().updateUnitMeasure(
                          userId: widget.userId,
                          unitMeasureIndex: selectedLength == 'Inches (in)'
                              ? 0
                              : selectedLength == 'Feet (ft)'
                                  ? 2
                                  : 1);
                    });
                  },
                  items: <String>['Inches (in)', 'Feet (ft)', 'Meters (m)']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // trailing: Switch(
                //     value: isPushNotif,
                //     onChanged: (value) {
                //       setState(() {
                //         isPushNotif = value;
                //       });
                //     }),
              ),
              // ListTile(
              //   title: const Text(
              //     'Enable Email Notifications',
              //     style: TextStyle(
              //       color: Color(0xFF222222),
              //       fontSize: 16,
              //       fontFamily: 'Nunito Sans',
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              //   trailing: Switch(
              //       value: isEmailNotif,
              //       onChanged: (value) {
              //         setState(() {
              //           isEmailNotif = value;
              //         });
              //       }),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
