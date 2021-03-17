import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Future<void> saveUser(String name, int waterCounter) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'waterCount': waterCounter
    });
  }

  AppUserData _userFromSnapshot(DocumentSnapshot snapshot) {
    return AppUserData(
      uid: uid,
      name: snapshot.data()['name'],
      waterCounter: snapshot.data()['waterCount'],
    );
  }

  List<AppUserData> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AppUserData(
        uid: uid,
        name: doc.data()['name'],
        waterCounter: doc.data()['waterCount'],
      );
    }).toList();
  }

  Stream<List<AppUserData>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<AppUserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

}
