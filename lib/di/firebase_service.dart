import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detail_location_detector/firebase_options.dart';
import 'package:detail_location_detector/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static Future<FirebaseService> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
    return FirebaseService();
  }


  // 생성 시점을 이때로 하는것이 맞아 보이긴 함.
  FirebaseAuth get auth => FirebaseAuth.instance;

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}