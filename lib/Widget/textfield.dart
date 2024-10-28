import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class TextFeildStyle extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final Color? fillColor;
  final InputBorder? border;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final int? maxLines;
  final InputBorder? enabledBorder;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? icon;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final TextAlignVertical? textAlignVertical;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final bool? filled;
  final bool? enabled;
  final InputBorder? focusedBorder;
  final Color? focusColor;
  final TextDirection? hintTextDirection;
  final TextDirection? textDirection;
  final Function(String?)? onSaved;
  final double? height;
  final double? width;
  final String? initialValue;
  final String? suffixText;
  final int? maxLength;
  final inputFormatters;
  // final String? Function(dynamic value)? validation;
  final validation;
  final String? validationText;

  final int? length;
  final Function(String)? onChanged;
  final Decoration? decoration;
  final bool obscureText;
  final GestureTapCallback? ontap;
  final bool? readOnly;

  const TextFeildStyle({
    super.key,
    this.icon,
    this.focusColor,
    this.focusedBorder,
    this.enabled = true,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.hintText,
    this.labelText,
    this.border,
    this.labelStyle,
    this.fillColor,
    this.length,
    this.hintStyle,
    this.style,
    this.maxLines,
    this.hintTextDirection,
    this.enabledBorder,
    this.controller,
    this.keyboardType,
    this.validation,
    this.filled,
    this.textDirection,
    this.onSaved,
    this.height,
    this.width,
    this.initialValue,
    this.suffixText,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.decoration,
    this.textAlignVertical,
    this.obscureText = false,
    this.ontap,
    this.validationText,
    this.readOnly = false,
  });

  @override
  _TextFeildStyleState createState() => _TextFeildStyleState();
}

class _TextFeildStyleState extends State<TextFeildStyle> {
  bool isFocused = false;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
    isFocused = _focusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // width: double.infinity,
          // padding: EdgeInsets.symmetric(vertical: 10),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            // shadows: [
            //   if (isFocused)
            //     BoxShadow(
            //       color: Color(0xffDCECF1),
            //       blurRadius: 0,
            //       offset: Offset(0, 0),
            //       spreadRadius: 3,
            //     ),
            // ],
          ),
          child: TextFormField(
            // validator: (value) {
            //   // Add your validation logic here
            //   if (widget.validation != null) {
            //     return '${widget.validation}';
            //   }
            //   return null;
            // },
            focusNode: _focusNode,
            obscuringCharacter: '●',

            onChanged: widget.onChanged,
            maxLength: widget.maxLength,
            initialValue: widget.initialValue,
            keyboardType: widget.keyboardType,
            style: AppTextStyle.labelText.copyWith(color: blackColor),
            onTap: widget.ontap,
            readOnly: false,
            // minLines: widget.maxLines??1,
            validator: widget.validation,
            maxLines: widget.maxLines ?? 1,
            enabled: widget.enabled,
            controller: widget.controller,
            textDirection: widget.textDirection,
            onSaved: widget.onSaved,
            obscureText: widget.obscureText,
            textAlignVertical: widget.textAlignVertical,
            inputFormatters: widget.length != null
                ? [
                    LengthLimitingTextInputFormatter(widget.length),
                  ]
                : (widget.inputFormatters ?? []),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: 12, right: 10, top: 10, bottom: 10),
              focusColor: widget.focusColor,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: errorColor),
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: widget.prefixIcon,
              prefixIconColor: widget.prefixIconColor,
              suffixIcon: widget.suffixIcon,
              suffixIconColor: widget.suffixIconColor,
              icon: widget.icon,
              fillColor: widget.fillColor,
              filled: widget.filled,

              // enabledBorder: widget.enabledBorder,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: lightGreyColor), // Customize the border color
                borderRadius:
                    BorderRadius.circular(12), // Set the border radius
              ),
              hintText: widget.hintText,
              hintTextDirection: widget.hintTextDirection,
              hintStyle: AppTextStyle.hintText,
              labelText: widget.labelText,
              labelStyle: AppTextStyle.labelText,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: lightGreyColor),
                  borderRadius: BorderRadius.circular(12)),
              suffixText: widget.suffixText,
            ),
          ),
        ),
        // (widget.validation != null)
        //     ? Padding(
        //         padding: const EdgeInsets.only(left: 14.0),
        //         child: Text(
        //           widget.validation!(widget.controller
        //               ?.text)!, // Display the validation error message
        //           style: TextStyle(color: Colors.red, fontSize: 12),
        //         ),
        //       )
        //     : SizedBox(),
      ],
    );
  }
}