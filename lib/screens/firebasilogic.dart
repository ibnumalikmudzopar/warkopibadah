import 'package:flutter/material.dart';
import 'package:warkopibadah/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const COLLECTION_NAME = 'barang_items';

void fetchItemsByDate(String date) {
  FirebaseFirestore.instance
    .collection('belanja_items')
    .doc(date)
    .collection('items')
    .get()
    .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        print(doc.data());
      }
    });
}
