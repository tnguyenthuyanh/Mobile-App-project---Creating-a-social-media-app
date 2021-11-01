import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';

class FirestoreController {
  static Future<String> addPhotoMemo({
    required PhotoMemo photoMemo,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .add(photoMemo.toFirestoreDoc());
    return ref.id; // doc id
  }

  static Future<bool> isPhotoSaved({
    required PhotoMemo photoMemo,
    required User currentUser,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.FAVORITE_COLLECTION)
        .where('savedBy', isEqualTo: currentUser.uid)
        .get();
    for (int i = 0; i < querySnapshot.size; i++)
      if (querySnapshot.docs[i]['docId'] == photoMemo.docId) return true;
    return false;
  }

  static Future<String> saveFavoritePhoto({
    required PhotoMemo photoMemo,
    required User currentUser,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.FAVORITE_COLLECTION)
        .add({
      'savedBy': currentUser.uid,
      'createdByUID': photoMemo.uid,
      'createdByEmail': photoMemo.createdBy,
      'docId': photoMemo.docId,
    });
    return ref.id; // doc id
  }

  static Future<void> unsaveFavoritePhoto({
    required PhotoMemo photoMemo,
    required User currentUser,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.FAVORITE_COLLECTION)
        .where('savedBy', isEqualTo: currentUser.uid)
        .get();
    for (int i = 0; i < querySnapshot.size; i++)
      if (querySnapshot.docs[i]['docId'] == photoMemo.docId) {
        String docId = querySnapshot.docs[i].id;
        await FirebaseFirestore.instance
            .collection(Constant.FAVORITE_COLLECTION)
            .doc(docId)
            .delete();
      }
  }

  static Future<List<PhotoMemo>> getFavoriteList({
    required String uid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.FAVORITE_COLLECTION)
        .where('savedBy', isEqualTo: uid)
        .get();
    var result = <PhotoMemo>[];
    for (int i = 0; i < querySnapshot.size; i++) {
      var data = await FirebaseFirestore.instance
          .collection(Constant.PHOTOMEMO_COLLECTION)
          .doc(querySnapshot.docs[i]['docId'])
          .get();
      var document = data.data() as Map<String, dynamic>;
      var p = PhotoMemo.fromFirestoreDoc(
        doc: document,
        docId: data.id,
      );
      if (p != null) {
        // filter invalid photomemo doc in Firestore
        result.add(p);
      }
    }
    return result;
  }

  static Future<List<PhotoMemo>> getPhotoMemoList({
    required String uid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.UID, isEqualTo: uid)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();

    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(
          doc: document,
          docId: doc.id,
        );
        if (p != null) {
          // filter invalid photomemo doc in Firestore
          result.add(p);
        }
      }
    });
    return result;
  }

  static Future<void> updatePhotoMemo({
    required String docId,
    required Map<String, dynamic> updateInfo,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .doc(docId)
        .update(updateInfo);
  }

  static Future<List<PhotoMemo>> searchImages({
    required String createdBy,
    required List<String> searchLabels, // OR search
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: createdBy)
        .where(PhotoMemo.IMAGE_LABELS, arrayContainsAny: searchLabels)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();

    var results = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      var p = PhotoMemo.fromFirestoreDoc(
        doc: doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
      if (p != null) results.add(p);
    });
    return results;
  }

  static Future<void> deletePhotoMemo({
    required PhotoMemo photoMemo,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .doc(photoMemo.docId)
        .delete();
  }

  static Future<List<PhotoMemo>> getPhotoMemoListSharedWith({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.SHARED_WITH, arrayContains: email)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();
    var results = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      var p = PhotoMemo.fromFirestoreDoc(
        doc: doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
      if (p != null) results.add(p);
    });
    return results;
  }

  static Future<void> addUpdateBio({
    required User user,
    required String name,
    required String bio,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.BIO_COLLECTION)
        .where('uid', isEqualTo: user.uid)
        .get();

    await FirebaseFirestore.instance
        .collection(Constant.BIO_COLLECTION)
        .doc(querySnapshot.docs[0].id)
        .update({'name': name, 'bio': bio});
  }

  static Future<void> initBio({
    required User user,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.BIO_COLLECTION)
        .where('uid', isEqualTo: user.uid)
        .get();
    if (querySnapshot.size == 0)
      await FirebaseFirestore.instance.collection(Constant.BIO_COLLECTION).add({
        'name': "",
        'bio': "",
        'email': user.email,
        'uid': user.uid,
      });
  }

  static Future<Map> getBio({
    required String uid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.BIO_COLLECTION)
        .where('uid', isEqualTo: uid)
        .get();

    var i = querySnapshot.docs[0];
    return {
      'name': i['name'],
      'bio': i['bio'],
      'email': i['email'],
      "uid": i['uid']
    };
  }

  static Future<int> getNumberOfPhotos({
    required String uid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where('uid', isEqualTo: uid)
        .get();
    return querySnapshot.size;
  }
}
