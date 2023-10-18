import 'package:cloud_firestore/cloud_firestore.dart';

class MyCafe {
  var db = FirebaseFirestore.instance;

  Future<bool> insertData(
      {required String collection, required Map<String, dynamic> data}) async {
    try {
      var result = await db.collection(collection).add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<QuerySnapshot?> getData({required String collection}) async {
    try {
      return db.collection(collection).get();
    } catch (e) {
      return null;
    }
  }
}
