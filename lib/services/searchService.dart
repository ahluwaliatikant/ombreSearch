import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String name) {
    return FirebaseFirestore.instance
        .collection('concerts')
        .where('searchKey', isEqualTo: name.substring(0, 1).toUpperCase())
        .get();
  }
}
