import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class ApiClient {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getCollection(String collection) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(collection).get();

      List<Map<String, dynamic>> documents =
          querySnapshot.docs.map<Map<String, dynamic>>((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      return documents;
    } catch (e) {
      print('Error fetching documents: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getById(
      String collection, String documentId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(collection).doc(documentId).get();
    return snapshot.data() as Map<String, dynamic>?;
  }

  Future<void> update(String collection, String documentId,
      Map<String, dynamic> newData) async {
    await _firestore.collection(collection).doc(documentId).update(newData);
  }

  Future<void> delete(String collection, String documentId) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }

  Future<String> fieldExists(
      String collection, String field, dynamic value) async {
    String userId = '';
    QuerySnapshot snapshot = await _firestore
        .collection(collection)
        .where(field, isEqualTo: value)
        .get();
    if (snapshot.docs.isNotEmpty) {
      userId = snapshot.docs[0].id;
    }
    return userId;
  }
}
