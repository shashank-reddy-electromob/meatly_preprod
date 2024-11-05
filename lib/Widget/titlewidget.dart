import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget sizeWidget;
  final bool showBackButton;

  const TitleCard({
    Key? key,
    required this.title,
    this.onBack,
    this.showBackButton = true,
    this.sizeWidget = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showBackButton)
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    // width: 30,
                    // height: 30,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color.fromRGBO(237, 237, 237, 1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          // color: Colors.black26,
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 25,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  fontFamily: 'Inter',
                  fontSize: 20,
                ),
              ),
            ],
          ),
          sizeWidget
        ],
      ),
    );
  }
}
