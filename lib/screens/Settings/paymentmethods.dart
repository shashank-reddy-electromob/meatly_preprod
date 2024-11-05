import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/Widget/textfield.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/screens/Settings/widget/carddetails.dart';
import 'package:meatly/screens/Settings/widget/other_payment_card.dart';
import 'package:meatly/screens/order&tracking/trackingpage.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/constants.dart';
import 'package:meatly/utilities/textstyles.dart';
import 'package:meatly/utilities/validatorts.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  int selectedPaymentMethodIndex = 2;
  // bool card = false;
  List<Map<String, String>> cards = [];
  int? selectedCardIndex;
  @override
  void initState() {
    _fetchPaymentMethods();
    super.initState();
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final String userId = currentUserCredential;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.99),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleCard(
                  title: "Payment methods",
                  onBack: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Credit/Debit cards',
                  style: AppTextStyle.text,
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showBottomDrawer(context, false, null);
                      // startPayment();
                      // startSecurePayment();
                    },
                    icon: Icon(
                      Icons.add,
                      color: primaryColor,
                    ),
                    label: Text(
                      'Add new',
                      style: AppTextStyle.text.copyWith(
                        color: primaryColor,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        width: 2,
                        color: primaryColor.withOpacity(0.26),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : cards.isEmpty
                        ? Center(
                            child: Text('No payment methods found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cards.length,
                            itemBuilder: (context, index) {
                              return CardDetailsCard(
                                userId: userId,
                                id: cards[index]['id'] ?? "",
                                current: true,
                                suffixIcon: Icons.more_vert,
                                title: cards[index]['cardNumber']!,
                                expiredate:
                                    'Expire Date\n${cards[index]['expiryDate']}',
                                onEdit: () {
                                  print('on edit called--->');
                                  showBottomDrawer(context, true, {
                                    'cardNumber':
                                        '${cards[index]['cardNumber']}',
                                    'expiryDate': cards[index]['expiryDate'],
                                    "id": cards[index]['id'],
                                    'cvv': "${cards[index]['cvv']}",
                                    "cardholderName":
                                        "${cards[index]['cardholderName']}",
                                  });
                                },
                              );
                            },
                          ),
                SizedBox(height: 8),
                Text(
                  'Others',
                  style: AppTextStyle.text,
                ),
                OtherPaymentCard(
                  title: 'Apple Pay',
                  image: 'Apple_Pay_logo 1.png',
                ),
                OtherPaymentCard(
                  title: 'Paypal',
                  image: 'paypallogo.png',
                ),
                OtherPaymentCard(
                  title: 'Venmo',
                  image: 'Venmo-Logo 1.png',
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> _fetchPaymentMethods() async {
    print('fetch called------>');
    setState(() {
      isLoading = true;
    });
    try {
      final snapshot =
          await usersCollection.doc(userId).collection('Payment Methods').get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          isLoading = false;
        });
      } else {
        cards.clear();
        cards = snapshot.docs.map((doc) {
          print('doc is --->');
          print(doc['cvv']);
          print(doc['cardNumber']);
          print(doc['cardholderName']);
          String expiryDate = doc['expiryDate'];
          DateTime date = DateFormat('MM/yyyy').parse(expiryDate);
          String formattedDate = DateFormat('MM/yy').format(date);

          return {
            // 'cardNumber':
            //     '**** **** **** ${doc['cardNumber'].substring(doc['cardNumber'].length - 4)}',

            'cardNumber': '${doc['cardNumber']}',
            'expiryDate': formattedDate,
            "id": doc.id,
            'cvv': "${doc['cvv']}",
            "cardholderName": "${doc['cardholderName']}",
          };
        }).toList();
        setState(() {
          isLoading = false;
        });
      }
      print('cards length is------>');
      print(cards.length);
    } catch (e) {
      showErrorMessage(context, "Failed to fetch payment methods: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Widget _buildCardDetails() {
  //   return Column(
  //     children: cards.map((card) {
  //       int index = cards.indexOf(card);
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.5),
  //                 spreadRadius: 1,
  //                 blurRadius: 2,
  //               ),
  //             ],
  //           ),
  //           child: Padding(
  //             padding:
  //                 const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 RadioListTile(
  //                   contentPadding: EdgeInsets.zero,
  //                   splashRadius: 20,
  //                   activeColor: primaryColor,
  //                   value: index,
  //                   groupValue: selectedCardIndex,
  //                   onChanged: (int? value) {
  //                     setState(() {
  //                       selectedCardIndex = value;
  //                     });
  //                   },
  //                   title: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         card['cardNumber']!,
  //                         style: AppTextStyle.textSemibold20.copyWith(
  //                             color: primaryColor,
  //                             fontWeight: selectedCardIndex == index
  //                                 ? FontWeight.w700
  //                                 : FontWeight.w400),
  //                       ),
  //                       Icon(Icons.expand_more_outlined)
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 40.0, right: 20),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'Expire Date',
  //                             style: AppTextStyle.textGreyMedium12,
  //                           ),
  //                           Text(
  //                             '${card['expiryDate']}',
  //                             style: AppTextStyle.textGreyMedium12,
  //                           ),
  //                         ],
  //                       ),
  //                       SvgPicture.asset('lib/assets/icons/mastercard_logo.svg')
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildPaymentMethod(String name, String icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethodIndex = index;
        });
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selectedPaymentMethodIndex == index
                        ? primaryColor
                        : Colors.grey,
                    width: 2,
                  ),
                ),
                child: SvgPicture.asset(
                  icon,
                  height: 25,
                  width: 25,
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.check_circle_sharp,
                    color: selectedPaymentMethodIndex == index
                        ? primaryColor
                        : Colors.transparent,
                  ))
            ],
          ),
          SizedBox(height: 5),
          Text(name,
              style: AppTextStyle.textGreySemi12.copyWith(
                  color: selectedPaymentMethodIndex == index
                      ? primaryColor
                      : null)),
        ],
      ),
    );
  }

  Widget _buildNoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('lib/assets/images/mastercard.svg'),
          SizedBox(height: 10),
          Text(
            'No mastercard added',
            style: AppTextStyle.textSemibold20,
          ),
          SizedBox(height: 5),
          Text(
            'You can add a mastercard and save it for later',
            textAlign: TextAlign.center,
            style: AppTextStyle.hintText,
          ),
        ],
      ),
    );
  }

  void showBottomDrawer(
      BuildContext context, bool isEdit, Map<String, dynamic>? data) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    TextEditingController namecontroller = TextEditingController();
    TextEditingController cardnumbercontroller = TextEditingController();
    TextEditingController expiredateController = TextEditingController();
    TextEditingController cvvController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    expiredateController.text =
        DateFormat("MM/yy").format(DateTime.now().add(Duration(days: 30)));

    if (isEdit) {
      print(data);

      namecontroller.text = data!['cardholderName'];
      cardnumbercontroller.text = data['cardNumber'];
      expiredateController.text = data['expiryDate'];
      cvvController.text = data['cvv'];
    }

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: screenWidth * 0.19,
                      decoration: BoxDecoration(
                        color: Color(0xffC4C4C4),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: Text(
                      isEdit ? "Edit Card" : 'Add Card',
                      style: AppTextStyle.textSemibold20,
                    ),
                  ),
                  // SizedBox(height: 5),
                  SizedBox(height: screenHeight * 0.02),
                  Text("Card Holder Name", style: AppTextStyle.labelText),
                  SizedBox(height: 5),
                  TextFeildStyle(
                    hintText: 'Shubhangi Mishra',
                    textAlignVertical: TextAlignVertical.center,
                    controller: namecontroller,
                    height: 50,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter card holder name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                    border: InputBorder.none,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text("Card Number", style: AppTextStyle.labelText),
                  SizedBox(height: 5),
                  TextFeildStyle(
                    hintText: '2134   _ _ _ _   _ _ _ _   0969',
                    textAlignVertical: TextAlignVertical.center,
                    controller: cardnumbercontroller,
                    length: 16,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your card number';
                      } else if (!RegExp(r'^\d{16}$').hasMatch(value)) {
                        return 'Enter a valid 16-digit card number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    height: 50,
                    onChanged: (value) {
                      setState(() {});
                    },
                    border: InputBorder.none,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Expire Date", style: AppTextStyle.labelText),
                            SizedBox(height: 10),
                            TextFeildStyle(
                              ontap: () {
                                showMonthPicker(
                                  context: context,
                                  monthPickerDialogSettings:
                                      MonthPickerDialogSettings(
                                    dialogSettings: PickerDialogSettings(),
                                    headerSettings: PickerHeaderSettings(
                                      headerBackgroundColor: primaryColor,
                                    ),
                                    buttonsSettings: PickerButtonsSettings(
                                      selectedMonthTextColor: Colors.white,
                                      unselectedMonthsTextColor: blackColor,
                                      selectedMonthBackgroundColor:
                                          primaryColor,
                                      currentMonthTextColor: blackColor,
                                    ),
                                  ),
                                  firstDate:
                                      DateTime.now().add(Duration(days: 30)),
                                  lastDate: DateTime(2099, 1, 1),
                                  initialDate: DateFormat('MM/yy')
                                      .parse(expiredateController.text),
                                ).then((date) {
                                  if (date != null) {
                                    print(date);
                                    expiredateController.text =
                                        DateFormat("MM/yy").format(date);
                                  }
                                });
                              },
                              hintText: '09/28',
                              readOnly: true,
                              validation: FormValidators.validateExpiryDate,
                              textAlignVertical: TextAlignVertical.center,
                              controller: expiredateController,
                              height: 50,
                              onChanged: (value) {
                                setState(() {});
                              },
                              border: InputBorder.none,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("CVV", style: AppTextStyle.labelText),
                            SizedBox(height: 10),
                            TextFeildStyle(
                              hintText: '●●●',
                              length: 3,
                              keyboardType: TextInputType.number,
                              validation: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.toString().length < 3) {
                                  return 'Please enter cvv';
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              controller: cvvController,
                              height: 50,
                              onChanged: (value) {
                                setState(() {});
                              },
                              border: InputBorder.none,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  isLoading
                      ? CircularProgressIndicator(
                          color: primaryColor,
                        )
                      : CustomButton(
                          text: isEdit ? "Edit Card" : "Add Card",
                          textSize: 16,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                              try {
                                final snapshot = await usersCollection
                                    .doc(userId)
                                    .collection('Payment Methods')
                                    .get();

                                if (isEdit) {
                                  await usersCollection
                                      .doc(userId)
                                      .collection('Payment Methods')
                                      .doc(data!['id'])
                                      .update({
                                    'cardNumber': cardnumbercontroller.text,
                                    'expiryDate': expiredateController.text,
                                    'cvv': cvvController.text,
                                    'cardholderName': namecontroller.text,
                                  });
                                } else {
                                  if (snapshot.docs.isEmpty) {
                                    await usersCollection
                                        .doc(userId)
                                        .collection('Payment Methods')
                                        .add({
                                      'cardNumber': cardnumbercontroller.text,
                                      'expiryDate': expiredateController.text,
                                      'cvv': cvvController.text,
                                      'cardholderName': namecontroller.text,
                                    });
                                  } else {
                                    await usersCollection
                                        .doc(userId)
                                        .collection('Payment Methods')
                                        .add({
                                      'cardNumber': cardnumbercontroller.text,
                                      'expiryDate': expiredateController.text,
                                      'cvv': cvvController.text,
                                      'cardholderName': namecontroller.text,
                                    });
                                  }
                                }

                                Navigator.pop(context);
                                Navigator.pop(context);
                                _fetchPaymentMethods();

                                showSucessMessage(
                                    context,
                                    isEdit
                                        ? "Card edited successfully."
                                        : "Card added successfully.");
                              } catch (e) {
                                Navigator.pop(context);
                                showErrorMessage(
                                    context,
                                    isEdit
                                        ? "Failed to edit card: $e"
                                        : "Failed to add card: $e");
                              }
                            } else {}
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'lib/assets/images/success.png',
            height: screenHeight * 0.17,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text('Order placed', style: AppTextStyle.pageHeadingSemiBold),
          SizedBox(height: screenHeight * 0.01),
          Text('Your order has been placed, Please enjoy our service !',
              textAlign: TextAlign.center, style: AppTextStyle.hintText),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          ),
          height: MediaQuery.of(context).size.height / 13,
          width: MediaQuery.of(context).size.width * 0.97,
          child: CustomButton(
              text: 'Track your order',
              onPressed: () {
                nextPage(context, TrackingPage());
              })),
    );
  }
}

void startPayment() async {
  try {
    await InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _onCardNonceRequestSuccess,
      onCardEntryCancel: _onCardEntryCancel,
    );
  } catch (e) {
    print(e);
  }
}

void _onCardNonceRequestSuccess(CardDetails result) {
  // Process payment with nonce
  print(result.nonce);
  InAppPayments.completeCardEntry(
    onCardEntryComplete: () {
      // Handle payment completion
    },
  );
}

void _onCardEntryCancel() {
  print("Payment entry canceled");
}

void startSecurePayment() async {
  try {
    await InAppPayments.startSecureRemoteCommerce(
      amount: 100,
      onMaterCardNonceRequestSuccess: _onMasterCardNonceRequestSuccess,
      onMasterCardNonceRequestFailure: _onCardEntryFailure,
    );
  } catch (e) {
    print("Error initiating secure payment: $e");
  }
}

void _onMasterCardNonceRequestSuccess(CardDetails result) {
  // Use result.nonce for the transaction without saving the card
  print('payment done------->');
}

void _onCardEntryFailure(error) {
  print("Payment failed: ${error.message}");
}
