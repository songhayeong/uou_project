import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detail_location_detector/domain/auth/entity/group.dart';
import 'package:detail_location_detector/domain/auth/entity/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirestoreService{
  static final _firestore= FirebaseFirestore.instance;

  static Future<void> updateUserLocation(String userId, LatLng location) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'location' : {'lat' : location.latitude, 'lng' : location.longitude},
      });
    } on FirebaseException catch (e){
      print('파이어 베이스 에러 발생 $e');
    } catch (err) {
      print('에러 발생 $err');
    }
  }

  static Stream<List<User>> userCollectionStream() {
    return _firestore.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromMap(doc.data())).toList()
    );
  }

  static Stream<List<Group>> groupLocationCollectionStream() {
    print('hihi ${_firestore.collection('groups').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Group.fromMap(doc.data())).toList()).toString()}');

    return _firestore.collection('groups').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Group.fromMap(doc.data())).toList()
    );
  }

}



