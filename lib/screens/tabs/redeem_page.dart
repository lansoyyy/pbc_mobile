import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_plastic_mobile/screens/home_screen.dart';
import 'package:smart_plastic_mobile/services/add_redeem.dart';
import 'package:smart_plastic_mobile/utlis/colors.dart';
import 'package:smart_plastic_mobile/widgets/button_widget.dart';
import 'package:smart_plastic_mobile/widgets/drawer_widget.dart';
import 'package:smart_plastic_mobile/widgets/text_widget.dart';
import 'package:smart_plastic_mobile/widgets/toast_widget.dart';

class RedeemPage extends StatelessWidget {
  const RedeemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: primary,
        centerTitle: true,
        title: TextWidget(
          text: 'Redeem',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )),
              );
            }

            final mydata = snapshot.requireData;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextWidget(
                      text: 'Total Points: ${mydata.docs.first['pts']} pts',
                      fontSize: 18,
                      color: secondary,
                      fontFamily: 'Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Items')
                          // .where('qty', isGreaterThan: 0)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print('error');
                          return const Center(child: Text('Error'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.black,
                            )),
                          );
                        }

                        final data = snapshot.requireData;
                        return Expanded(
                          child: GridView.builder(
                            itemCount: data.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 3,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      text: 'Item Name',
                                      fontSize: 11,
                                      color: grey,
                                    ),
                                    TextWidget(
                                      text: data.docs[index]['name'],
                                      fontSize: 32,
                                      color: secondary,
                                      fontFamily: 'Bold',
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextWidget(
                                      text: 'Equivalent points',
                                      fontSize: 10,
                                      color: grey,
                                    ),
                                    TextWidget(
                                      text: '${data.docs[index]['points']} pts',
                                      fontSize: 18,
                                      color: secondary,
                                      fontFamily: 'Bold',
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ButtonWidget(
                                      radius: 100,
                                      height: 35,
                                      width: 125,
                                      fontSize: 12,
                                      label: 'REDEEM',
                                      onPressed: () {
                                        if (mydata.docs.first['pts'] >=
                                            data.docs[index]['points']) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const Text(
                                                      'Redeem Confirmation',
                                                      style: TextStyle(
                                                          fontFamily: 'QBold',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    content: const Text(
                                                      'Are you sure you want to redeem this item?',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'QRegular'),
                                                    ),
                                                    actions: <Widget>[
                                                      MaterialButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true),
                                                        child: const Text(
                                                          'Close',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'QRegular',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      MaterialButton(
                                                        onPressed: () async {
                                                          await addRedeem(
                                                              data.docs[index]
                                                                  ['name'],
                                                              data.docs[index]
                                                                  ['points'],
                                                              mydata.docs.first[
                                                                  'name'],
                                                              data.docs[index]
                                                                  .id);

                                                          Navigator.of(context)
                                                              .pop();

                                                          showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        title:
                                                                            const Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.check_circle_outline,
                                                                              color: Colors.green,
                                                                              size: 150,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Text(
                                                                              "You have succesfully sent a request! Wait for admin's approval for the redeemed item.",
                                                                              style: TextStyle(fontSize: 18, fontFamily: 'Bold', fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        actions: <Widget>[
                                                                          MaterialButton(
                                                                            onPressed:
                                                                                () async {
                                                                              Navigator.of(context).pop();

                                                                              // showDialog(
                                                                              //     barrierDismissible: false,
                                                                              //     context: context,
                                                                              //     builder: (context) => AlertDialog(
                                                                              //           title: Column(
                                                                              //             mainAxisSize: MainAxisSize.min,
                                                                              //             mainAxisAlignment: MainAxisAlignment.center,
                                                                              //             crossAxisAlignment: CrossAxisAlignment.center,
                                                                              //             children: [
                                                                              //               const Text(
                                                                              //                 'QR Code',
                                                                              //                 style: TextStyle(fontSize: 18, fontFamily: 'Bold', fontWeight: FontWeight.bold),
                                                                              //               ),
                                                                              //               SizedBox(
                                                                              //                 height: 300,
                                                                              //                 width: 300,
                                                                              //                 child: QrImageView(
                                                                              //                   data: user,
                                                                              //                   version: QrVersions.auto,
                                                                              //                   size: 200.0,
                                                                              //                 ),
                                                                              //               )
                                                                              //             ],
                                                                              //           ),
                                                                              //           actions: <Widget>[
                                                                              //             MaterialButton(
                                                                              //               onPressed: () async {
                                                                              //                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
                                                                              //               },
                                                                              //               child: const Text(
                                                                              //                 'Continue',
                                                                              //                 style: TextStyle(fontFamily: 'QRegular', fontWeight: FontWeight.bold),
                                                                              //               ),
                                                                              //             ),
                                                                              //           ],
                                                                              //         ));
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              'Continue',
                                                                              style: TextStyle(fontFamily: 'QRegular', fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ));
                                                        },
                                                        child: const Text(
                                                          'Continue',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'QRegular',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ));
                                        } else {
                                          showToast(
                                              'Cannot redeem! Points not enough');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      })
                ],
              ),
            );
          }),
    );
  }
}
