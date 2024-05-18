import 'package:flutter/material.dart';

import '../../../constants/constant_color.dart';
import '../../../constants/constant_text.dart';

class AlertModal extends StatefulWidget {
  String info;
  AlertModal({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  _AlertModalState createState() => _AlertModalState();
}

class _AlertModalState extends State<AlertModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.05,
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.height * 0.04,
            top: MediaQuery.of(context).size.height * 0.01,
            bottom: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Row(
            children: [
              Image.asset("assets/vector.png"),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Text(widget.info,
                  style: ConstantTextStyles.nunitoBold16.copyWith(
                    color: ConstantColor.green,
                  )),
            ],
          ),
        ));
  }
}
