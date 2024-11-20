import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> addRedeem(name, pts, myname, itemId) async {
  final docUser = FirebaseFirestore.instance.collection('Records').doc();

  final json = {
    'name': name,
    'myname': myname,
    'dateTime': DateTime.now(),
    'pts': pts,
    'uid': FirebaseAuth.instance.currentUser!.uid,
    'status': 'Pending',
    'itemId': itemId
  };

  await docUser.set(json);

  return docUser.id;
}
