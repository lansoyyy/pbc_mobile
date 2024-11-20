import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_plastic_mobile/utlis/colors.dart';
import 'package:smart_plastic_mobile/widgets/drawer_widget.dart';
import 'package:smart_plastic_mobile/widgets/text_widget.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

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
            return SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  border: TableBorder.all(),
                  columnSpacing: 50,
                  columns: [
                    DataColumn(
                      label: TextWidget(
                        text: 'ID Number',
                        fontSize: 18,
                        fontFamily: 'Bold',
                      ),
                    ),
                    DataColumn(
                      label: TextWidget(
                        text: 'Item Name',
                        fontSize: 18,
                        fontFamily: 'Bold',
                      ),
                    ),
                    DataColumn(
                      label: TextWidget(
                        text: 'Item Points',
                        fontSize: 18,
                        fontFamily: 'Bold',
                      ),
                    ),
                    DataColumn(
                      label: TextWidget(
                        text: 'Date and Time',
                        fontSize: 18,
                        fontFamily: 'Bold',
                      ),
                    ),
                  ],
                  rows: [
                    for (int i = 0; i < data.docs.length; i++)
                      DataRow(
                          color: MaterialStateColor.resolveWith(
                            (states) =>
                                i % 2 == 0 ? Colors.white : Colors.grey[200]!,
                          ),
                          cells: [
                            DataCell(
                              TextWidget(
                                text: '${i + 1}',
                                fontSize: 14,
                                fontFamily: 'Medium',
                                color: Colors.grey,
                              ),
                            ),
                            DataCell(
                              TextWidget(
                                text: data.docs[i]['name'],
                                fontSize: 14,
                                fontFamily: 'Medium',
                                color: Colors.grey,
                              ),
                            ),
                            DataCell(
                              TextWidget(
                                text: '${data.docs[i]['pts']} pts',
                                fontSize: 14,
                                fontFamily: 'Medium',
                                color: Colors.grey,
                              ),
                            ),
                            DataCell(
                              TextWidget(
                                text: DateFormat.yMMMd()
                                    .add_jm()
                                    .format(data.docs[i]['dateTime'].toDate()),
                                fontSize: 14,
                                fontFamily: 'Medium',
                                color: Colors.grey,
                              ),
                            ),
                          ])
                  ],
                ),
              ),
            );
          }),
    );
  }
}
