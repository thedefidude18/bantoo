import 'package:flexx_bet/constants/globals.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/components/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../ui/components/custom_appbar.dart';

Future<Position?> _handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 2),
        message: 'Location services are disabled. Please enable the services'));
    return null;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 2),
          messageText: Text(
            'Location permissions are denied',
            style: TextStyle(color: Colors.white),
          )));
      return null;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 2),
        messageText: Text(
          'Location permissions are permanently denied, we cannot request permissions.',
          style: TextStyle(color: Colors.white),
        )));
    return null;
  }
  return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

class MapsScreen extends StatelessWidget {
  MapsScreen({super.key});
  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          FutureBuilder(
              future: _handleLocationPermission(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      minZoom: 0,
                      maxZoom: 22,
                      zoom: 13,
                      center: LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                        additionalOptions: const {
                          'accessToken': Globals.mapBoxAccessToken,
                        },
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            height: 60,
                            width: 60,
                            point: LatLng(snapshot.data!.latitude,
                                snapshot.data!.longitude),
                            builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  // Get.dialog(const UserInfoCard());
                                },
                                child: Image.asset(
                                  ImageConstant.mapsFemaleIndicator,
                                ),
                              );
                            },
                          ),
                          Marker(
                            height: 60,
                            width: 60,
                            point: LatLng(snapshot.data!.latitude - .009,
                                snapshot.data!.longitude - .01),
                            builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  // Get.dialog(const UserInfoCard());
                                },
                                child: Image.asset(
                                  ImageConstant.mapsMaleIndicator,
                                ),
                              );
                            },
                          ),
                          Marker(
                            height: 60,
                            width: 60,
                            point: LatLng(snapshot.data!.latitude + .005,
                                snapshot.data!.longitude + .023),
                            builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  // Get.dialog(const UserInfoCard());
                                },
                                child: Image.asset(
                                  ImageConstant.mapsFemaleIndicator,
                                ),
                              );
                            },
                          ),
                          Marker(
                            height: 60,
                            width: 60,
                            point: LatLng(snapshot.data!.latitude + .032,
                                snapshot.data!.longitude + .008),
                            builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  Get.dialog(const UserInfoCard());
                                },
                                child: Image.asset(
                                  ImageConstant.mapsMaleIndicator,
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasData) {
                  return const Center(
                    child: Text(
                      "Unable to get your location, Please enable Location services and allow precise location",
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }
}
