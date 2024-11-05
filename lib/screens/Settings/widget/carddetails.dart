import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meatly/Widget/confirmationtext.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/screens/Map%20screens/MapScreen.dart';
import 'package:meatly/screens/Settings/paymentmethods.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class CardDetailsCard extends StatefulWidget {
  final String title;
  final String expiredate;
  final IconData suffixIcon;
  final bool current;
  final String id;
  final String userId;
  final Function onEdit;

  CardDetailsCard({
    required this.title,
    required this.expiredate,
    this.suffixIcon = Icons.more_vert,
    this.current = false,
    required this.id,
    required this.userId,
    required this.onEdit,
  });

  @override
  _CardDetailsCardState createState() => _CardDetailsCardState();
}

class _CardDetailsCardState extends State<CardDetailsCard> {
  String location = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // _openMapsScreen(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '**** **** **** ${widget.title.substring(widget.title.length - 4)}',
                          style: AppTextStyle.textSemibold20.copyWith(
                            color: primaryColor,
                          ),
                        ),
                        Spacer(),
                        // Icon(
                        //   widget.suffixIcon,
                        //   size: 20,
                        //   color: greyColor,
                        // ),
                        PopupMenuButton(
                          padding: EdgeInsets.all(0),
                          menuPadding: EdgeInsets.all(0),
                          position: PopupMenuPosition.under,
                          surfaceTintColor: Colors.white,
                          color: Colors.white,
                          icon: const Icon(
                            Icons.more_vert,
                          ),
                          onSelected: (int value) {
                            if (value == 0) {
                              print('edit');
                              widget.onEdit();
                            } else {
                              print('delete');
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomConfirmationDialog(
                                    title: 'Confirm Delete',
                                    message:
                                        'Are you sure to delete this card?',
                                    cancelText: 'Cancel',
                                    confirmText: 'Confirm',
                                    onCancelPressed: () {
                                      Navigator.pop(context);
                                    },
                                    onConfirmPressed: () async {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                      await FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(widget.userId)
                                          .collection('Payment Methods')
                                          .doc(widget.id)
                                          .delete();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentMethods(),
                                          ));
                                      showSucessMessage(context,
                                          "Card deleted successfully.");
                                    },
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 0,
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        )
                        // Positioned(
                        //     right: 0,
                        //     child: Icon(
                        //       widget.prefixIcon,
                        //       size: 24,
                        //       color: Colors.black,
                        //     )),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Icon(
                        //     widget.prefixIcon,
                        //     size: 24,
                        //     color: Colors.black,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                    child: Row(
                      children: [
                        Text(
                          widget.expiredate,
                          overflow: TextOverflow.visible,
                          style: AppTextStyle.textGreyMedium12,
                        ),
                        Spacer(),
                        Image.asset('lib/assets/icons/paypallogo.png')
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
