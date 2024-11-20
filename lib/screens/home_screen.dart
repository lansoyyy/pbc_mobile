import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_plastic_mobile/screens/tabs/redeem_page.dart';
import 'package:smart_plastic_mobile/utlis/colors.dart';
import 'package:smart_plastic_mobile/widgets/button_widget.dart';
import 'package:smart_plastic_mobile/widgets/drawer_widget.dart';
import 'package:smart_plastic_mobile/widgets/text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return Scaffold(
            drawer: const DrawerWidget(),
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: primary,
              centerTitle: true,
              title: TextWidget(
                text: 'Dashboard',
                fontSize: 18,
                fontFamily: 'Bold',
                color: Colors.white,
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      minRadius: 50,
                                      maxRadius: 50,
                                      child: Icon(
                                        Icons.person,
                                        size: 75,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        text: data.docs.first['name'],
                                        fontSize: 24,
                                        fontFamily: 'Bold',
                                      ),
                                      TextWidget(
                                        text: data.docs.first['email'],
                                        fontSize: 14,
                                        fontFamily: 'Medium',
                                        color: grey,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              TextWidget(
                                decoration: TextDecoration.underline,
                                text: '${data.docs.first['pts']} pts',
                                fontSize: 45,
                                fontFamily: 'Bold',
                                color: secondary,
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonWidget(
                  label: 'REDEEM',
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const RedeemPage()));
                  },
                ),
              ],
            ),
          );
        });
  }
}
