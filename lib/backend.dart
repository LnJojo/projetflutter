import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Backend {
  Future<List<String>> getWishlist(String userId) async {
    List<String> games = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('wishlist')
              .get();

      querySnapshot.docs.forEach((doc) {
        games.add(doc.id);
      });
    } catch (e) {
      print("Error getting wishlist: $e");
    }

    return games;
  }
}
