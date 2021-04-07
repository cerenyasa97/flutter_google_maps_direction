import 'package:piton_taxi_app/core/extensions/project_context_extension.dart';
import 'package:piton_taxi_app/core/components/project_text_form_field.dart';
import 'file:///C:/Users/Ceren/Desktop/piton_taxi_app/lib/core/init/otp_dialog_focus_nodes.dart';
import 'package:piton_taxi_app/core/constants/app/constants.dart';
import 'package:piton_taxi_app/core/init/project_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpDialogContent extends StatefulWidget {

  final Function(List<int>) onChanged;

  const OtpDialogContent({Key key, this.onChanged}) : super(key: key);

  @override
  _OtpDialogContentState createState() => _OtpDialogContentState();
}

class _OtpDialogContentState extends State<OtpDialogContent> {
  List<int> otpCode;

  @override
  void initState() {
    super.initState();
    otpCode = List.generate(ProjectConstants.OTP_CODE_LENGTH, (index) => 0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _codeField(context, autoFocus: true, nextFNode: OTPDialogConstants.field2FNode),
        _codeField(context, currentFNode: OTPDialogConstants.field2FNode, nextFNode: OTPDialogConstants.field3FNode),
        _codeField(context, currentFNode: OTPDialogConstants.field3FNode, nextFNode: OTPDialogConstants.field4FNode),
        _codeField(context, currentFNode: OTPDialogConstants.field4FNode, nextFNode: OTPDialogConstants.field5FNode),
        _codeField(context, currentFNode: OTPDialogConstants.field5FNode, nextFNode: OTPDialogConstants.field6FNode),
        _codeField(context, currentFNode: OTPDialogConstants.field6FNode),
      ],
    );
  }

  SizedBox _codeField(BuildContext context,
      {bool autoFocus = false, FocusNode currentFNode, FocusNode nextFNode}) {
    return SizedBox(
        width: context.dynamicWidth(35/412),
        child: ProjectTextFormField(
          autofocus: autoFocus ?? false,
          focusNode: currentFNode ?? FocusNode(),
          keyboardType: TextInputType.number,
          enabledBorder: ProjectConstants.otpVerificationEnabledBorder,
          focusedBorder: ProjectConstants.otpVerificationFocusedBorder,
          hintText: "0",
          alignment: TextAlign.center,
          textFormatter: [LengthLimitingTextInputFormatter(1)],
          cursorColor: Provider.of<ProjectThemeData>(context).getThemeData.textSelectionTheme.cursorColor,
          onChanged: (text) {
            if(text.isNotEmpty && otpCode.length <= 6) otpCode[OTPDialogConstants.getIndex(currentFNode)] = int.parse(text);
            if(currentFNode != OTPDialogConstants.field6FNode) nextField(text, nextFNode);
            widget.onChanged(otpCode);
          },
        ),
      );
  }

  void nextField(String text, FocusNode focusNode) {
    if(text.length == 1) context.nextFocusNode(focusNode);
  }


}