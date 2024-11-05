import 'package:flutter/material.dart';
import 'package:meatly/utilities/colors.dart';

class OtherPaymentCard extends StatelessWidget {
  const OtherPaymentCard({super.key, required this.title, required this.image});
  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 2,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: greyColor,
              fontFamily: 'Inter',
            ),
          ),
          Image.asset(
            'lib/assets/icons/$image',
          ),
        ],
      ),
    );
  }
}
