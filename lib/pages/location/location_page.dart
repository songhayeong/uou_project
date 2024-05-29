import 'dart:async';

import 'package:detail_location_detector/domain/auth/entity/user.dart';
import 'package:detail_location_detector/domain/location/entity/location.dart';
import 'package:detail_location_detector/pages/search/search_page.dart';
import 'package:detail_location_detector/service/firestore_service.dart';
import 'package:detail_location_detector/service/stream_location_service.dart';
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

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(129.3113596, 35.5383773),
    zoom: 14.4746,
  );

  late StreamSubscription<Position>? locationStreamSubscription;

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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locationStreamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('naver map'),
        leading: GestureDetector(
          onTap: () {
            MaterialPageRoute(builder: (context) => const SearchPage());
          },
          child: const Icon(Icons.search),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)
              =>
              const SearchPage()
              ));
            },
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: StreamBuilder<List<User>>(
        stream: FirestoreService.userCollectionStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print(snapshot.toString());
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final Set<Marker> markers = {};
          for (var i = 0; i < snapshot.data!.length; i++) {
            final user = snapshot.data![i];
            markers.add(
              Marker(
                markerId: MarkerId('${user.name} position $i'),
                icon: user.name == 'hayeong'
                    ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed)
                    : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueYellow),
                position: LatLng(user.location.lat, user.location.lng),
                onTap: () => {},
              ),
            );
          }
          return GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          );
        },
      ),
    );
  }
}
