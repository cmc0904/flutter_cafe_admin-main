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

  Future<dynamic> getData(
      {required String collection,
      required String? id,
      required String? fieldName,
      required String? fieldValue}) async {
    try {
      if (id == null && fieldName == null) {
        return db.collection(collection).get();
      } else if (id != null) {
        return db.collection(collection).doc(id).get();
      } else if (fieldName != null) {
        return db
            .collection(collection)
            .where(fieldName, isEqualTo: fieldValue)
            .get();
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> deleteData(
      {required String collection, required String documentID}) async {
    try {
      var result = db.collection(collection).doc(documentID).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
