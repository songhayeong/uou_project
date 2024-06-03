import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detail_location_detector/data/data_source/auth_data_source.dart';
import 'package:detail_location_detector/data/data_source/location_data_source.dart';
import 'package:detail_location_detector/domain/auth/entity/group.dart';
import 'package:detail_location_detector/domain/auth/entity/user.dart';
import 'package:detail_location_detector/domain/location/entity/location.dart';
import 'package:detail_location_detector/pages/search/search_page.dart';
import 'package:detail_location_detector/service/firestore_service.dart';
import 'package:detail_location_detector/service/stream_location_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(35.53985, 129.2548), // 울산대학교 위경도
    zoom: 17,
  );

  LocationDataSource locationDataSource = LocationDataSource();

  //var currentLocation = await _locationDataSource.getCurrentLocation();

  late StreamSubscription<Position>? locationStreamSubscription;

  final Set<Marker> markers = {};

  Future<void> _dialogBuilder(BuildContext context) {
// 현재 화면 위에 보여줄 다이얼로그 생성
    return showDialog<void>(
      context: context,
      builder: (context) {
        // 빌더로 AlertDialog 위젯을 생성
        return AlertDialog(
          title: const Text('하영 : 울산 남구 대학로33번길 18-4'),
          content: const Text('위치 : 실내 / 2층'),
          actions: [
            // 다이얼로그 내의 취소 버튼 터치 시 다이얼로그 화면 제거
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _dialogBuilder1(BuildContext context) {
// 현재 화면 위에 보여줄 다이얼로그 생성
    return showDialog<void>(
      context: context,
      builder: (context) {
        // 빌더로 AlertDialog 위젯을 생성
        return AlertDialog(
          title: const Text('지훈 : 울산 남구 무거동 579-1'),
          content: const Text('위치 : 야외'),
          actions: [
            // 다이얼로그 내의 취소 버튼 터치 시 다이얼로그 화면 제거
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _dialogBuilder2(BuildContext context) {
// 현재 화면 위에 보여줄 다이얼로그 생성
    return showDialog<void>(
      context: context,
      builder: (context) {
        // 빌더로 AlertDialog 위젯을 생성
        return AlertDialog(
          title: const Text('민찬 : 울산 남구 대학로 93'),
          content: const Text('위치 : 실내 / 3층'),
          actions: [
            // 다이얼로그 내의 취소 버튼 터치 시 다이얼로그 화면 제거
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _dialogBuilder3(BuildContext context) {
// 현재 화면 위에 보여줄 다이얼로그 생성
    return showDialog<void>(
      context: context,
      builder: (context) {
        // 빌더로 AlertDialog 위젯을 생성
        return AlertDialog(
          title: const Text('주현 : 울산 남구 대학로 93'),
          content: const Text('위치 : 실내 / 6층'),
          actions: [
            // 다이얼로그 내의 취소 버튼 터치 시 다이얼로그 화면 제거
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationStreamSubscription =
        StreamLocationService.onLocatinoChanged?.listen(
      (position) async {
        await FirestoreService.updateUserLocation(
          '0whpRDBFE6p3mkEyhvXR',
          LatLng(position.latitude, position.longitude),
          // 하드코딩된 uid이지만, 인증 서비스를 사용할 때 연결된 사용자의 uid이다.
        );
      },
    );
    markers.add(
      Marker(
          markerId: MarkerId("1"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: LatLng(35.53985, 129.2548),
          onTap: () => {}),
    );

    markers.add(
      Marker(
          markerId: MarkerId("2"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: LatLng(35.54021, 129.2551),
          onTap: () => {}),
    );

    markers.add(
      Marker(
          markerId: MarkerId("3"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(35.54348, 129.2556),
          onTap: () => {}),
    );

    markers.add(
      Marker(
          markerId: MarkerId("4"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          position: LatLng(35.54417, 129.2556),
          onTap: () => {}),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locationStreamSubscription?.cancel();
  }

  Stream<dynamic> groupData() {
    print(
        "hihi ${_firestore.collection('groups').snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList())}");

    return _firestore
        .collection('groups')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LIFEGUARD',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
            child: const Icon(Icons.search),
          ),
        ],
      ),
      // body: StreamBuilder<List<Group>>(
      //   stream: FirestoreService.groupLocationCollectionStream(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     final Set<Marker> markers = {};
      //     for (var i = 0; i < snapshot.data!.length; i++) {
      //       final group = snapshot.data![i];
      //       markers.add(
      //         Marker(
      //           markerId: MarkerId('${group.groupId} position $i'),
      //           icon: group.membersData.first.name == 'hayeong'
      //               ? BitmapDescriptor.defaultMarkerWithHue(
      //             BitmapDescriptor.hueRed,
      //           )
      //               : BitmapDescriptor.defaultMarkerWithHue(
      //             BitmapDescriptor.hueYellow,
      //           ),
      //           position: LatLng(group.membersData.first.latitude,
      //               group.membersData.first.longitude),
      //           onTap: () => {},
      //         ),
      //       );
      //     }
      //     return GoogleMap(
      //       initialCameraPosition: _initialPosition,
      //       markers: markers,
      //       onMapCreated: (GoogleMapController controller) {
      //         _controller.complete(controller);
      //       },
      //     );
      //   },
      // ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: GestureDetector(
              onTap: () {
                  _dialogBuilder(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(100),
                ),
                width: 50,
                height: 50,
                child: const Center(
                  child: Text(
                    '하영',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Positioned(
            top: 10.0,
            left: 80,
            child: GestureDetector(
              onTap: () {
                _dialogBuilder1(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(100),
                ),
                width: 50,
                height: 50,
                child: const Center(
                  child: Text(
                    '지훈',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Positioned(
            top: 10.0,
            left: 150,
            child: GestureDetector(
              onTap: () {
                _dialogBuilder2(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(100),
                ),
                width: 50,
                height: 50,
                child: const Center(
                  child: Text(
                    '민찬',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Positioned(
            top: 10.0,
            left: 220,
            child: GestureDetector(
              onTap: () {
                _dialogBuilder3(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(100),
                ),
                width: 50,
                height: 50,
                child: const Center(
                  child: Text(
                    '주현',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
