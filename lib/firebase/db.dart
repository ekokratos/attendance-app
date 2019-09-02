import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:attendance_app/model/letters.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  /// Get letter details
  Stream<LetterDetails> getLetters(String collection, String letterId) {
    return _db
        .collection(collection)
        .document(letterId)
        .snapshots()
        .map((snap) => LetterDetails.fromJson(snap.data));
  }

  /// Store letter details
  Future<void> storeLetters(String collection, String letterId) {
    return _db
        .collection(collection)
        .document(letterId)
        .setData({/* some data */});
  }
}
