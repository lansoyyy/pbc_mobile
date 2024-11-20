import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_plastic_mobile/screens/home_screen.dart';
import 'package:smart_plastic_mobile/utlis/colors.dart';
import 'package:smart_plastic_mobile/widgets/drawer_widget.dart';
import 'package:smart_plastic_mobile/widgets/text_widget.dart';

class NotifPage extends StatelessWidget {
  const NotifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: primary,
        centerTitle: true,
        title: TextWidget(
          text: 'Records',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Records')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where('status', isNotEqualTo: 'Done')
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

            final data = snapshot.requireData;
            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    if (data.docs[index]['status'] == 'Accepted') {
                      // await FirebaseFirestore.instance
                      //     .collection('Items')
                      //     .doc(data.docs[index]['itemId'])
                      //     .update({
                      //   'qty': FieldValue.increment(-1),
                      // });
                      // Navigator.of(context).pop();
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        'pts': FieldValue.increment(-data.docs[index]['pts'])
                      });

                      await FirebaseFirestore.instance
                          .collection('Records')
                          .doc(data.docs[index].id)
                          .update({
                        'status': 'Done',
                      });

                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Bold',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();

                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'QR Code',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontFamily: 'Bold',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 300,
                                                      width: 300,
                                                      child: QrImageView(
                                                        data: data.docs[index]
                                                            ['itemId'],
                                                        version:
                                                            QrVersions.auto,
                                                        size: 200.0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  MaterialButton(
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const HomeScreen()));
                                                    },
                                                    child: const Text(
                                                      'Continue',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'QRegular',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                    },
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                          fontFamily: 'QRegular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ));
                    }
                  },
                  leading: TextWidget(text: '${index + 1}.', fontSize: 18),
                  title: TextWidget(
                      text:
                          'You requested to redeem ${data.docs[index]['name']}',
                      fontSize: 18),
                  subtitle: TextWidget(
                      text: 'Status: ${data.docs[index]['status']}',
                      fontSize: 12),
                );
              },
            );
          }),
    );
  }
}
