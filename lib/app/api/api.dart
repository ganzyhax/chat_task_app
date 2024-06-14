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

  Future<void> updateDocumentField(String collectionName, String documentId,
      Map<String, dynamic> updatedFields) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection(collectionName).doc(documentId);

      await documentReference.update(updatedFields);

      print('Document field updated successfully!');
    } catch (e) {
      print('Error updating document: $e');
      throw e;
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

  Future<String?> login(String username, String password) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.size > 0) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data() as Map<String, dynamic>;

        if (userData['password'] == password) {
          return userDoc.id;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<List<DocumentSnapshot>> findChat(
      String userId, String clientId) async {
    try {
      // Query for documents where userId equals userId and clientId equals clientId
      QuerySnapshot querySnapshot1 = await _firestore
          .collection('chats')
          .where('userId', isEqualTo: userId)
          .where('clientId', isEqualTo: clientId)
          .get();

      // Query for documents where clientId equals userId and userId equals clientId
      QuerySnapshot querySnapshot2 = await _firestore
          .collection('chats')
          .where('clientId', isEqualTo: userId)
          .where('userId', isEqualTo: clientId)
          .get();

      // Combine results from both queries into a single list of DocumentSnapshot
      List<DocumentSnapshot> documents = [];
      documents.addAll(querySnapshot1.docs);
      documents.addAll(querySnapshot2.docs);

      return documents;
    } catch (e) {
      print('Error fetching documents: $e');
      return []; // Return an empty list if there's an error
    }
  }

  Future<Map<String, dynamic>?> create(
    String collectionName,
    Map<String, dynamic> data,
  ) async {
    try {
      // Add the new document to the specified collection
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection(collectionName).add(data);

      // Retrieve the generated document ID
      String docId = docRef.id;

      // Update the document with the generated ID
      await docRef.update({'id': docId});

      // Fetch the updated document to return its data
      DocumentSnapshot docSnapshot = await docRef.get();
      return docSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error adding document: $e');
      return null;
    }
  }
}
