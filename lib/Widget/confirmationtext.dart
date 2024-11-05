import 'package:flutter/material.dart';
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/constants.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onCancelPressed;
  final VoidCallback onConfirmPressed;

  const CustomConfirmationDialog(
      {Key? key,
      required this.title,
      required this.message,
      required this.onCancelPressed,
      required this.onConfirmPressed,
      required this.confirmText,
      required this.cancelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: Stack(children: [
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                border: Border.all(
                  color: Color.fromRGBO(237, 237, 237, 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    offset: Offset(2, 4),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.close,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 0, left: 10, right: 10, top: 20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: greyColor,
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancelPressed,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: primaryColor.withOpacity(0.26),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                        child: Text(
                          cancelText,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onConfirmPressed,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: primaryColor,
                          surfaceTintColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          confirmText,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
