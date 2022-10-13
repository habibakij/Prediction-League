
import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/pages/introduction/intro_page.dart';
import 'package:prediction/util/constant.dart';
import '../../package/map_picker.dart';
import '../../package/page_transition/page_transition.dart';

class SelectLocationPage extends StatefulWidget {
  @override
  State<SelectLocationPage> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocationPage> {
  String apiKey = "AIzaSyCYfHXR8HDeGXCN2IG9C6-ksHy5mWxakE4";

  final Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? googleMapController;
  CameraPosition cameraPosition = const CameraPosition(target: LatLng(29.3117619,46.4116382), zoom: 14);
  MapPickerController mapPickerController = MapPickerController();
  String address = "", countryCode= "";
  bool serviceEnabled=false;
  Position? currentPosition;
  void locatePosition() async{

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToast("Location service enabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showToast("Location permission denied permanently");
    }
    Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition=position;
    LatLng latLngPosition=LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition=new CameraPosition(target: latLngPosition,zoom: 14);
    googleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {

    });
  }
  Future<void> getAddressFromLatLong(double latitude, double longitude) async {
    List<Placemark> placemark = await placemarkFromCoordinates(latitude, longitude);
    log("place_marker:$placemark");
    Placemark placemark1 = placemark[0];
    setState(() {
      countryCode= placemark1.isoCountryCode.toString();
      address = "${placemark1.street.toString()}, ${placemark1.locality.toString()}, "
          "${placemark1.isoCountryCode.toString()}, ${placemark1.postalCode.toString()} ";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              MapPicker(
                iconWidget: Image.asset(
                  "assets/images/location.png",
                  height: 50,
                  width: 30,
                ),
                mapPickerController: mapPickerController,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: cameraPosition,
                  onMapCreated: (GoogleMapController controller) async {
                    mapController.complete(controller);
                    googleMapController=controller;
                    locatePosition();
                  },
                  onCameraMoveStarted: () {
                    mapPickerController.mapMoving!();
                  },
                  onCameraMove: (cameraPosition) {
                    this.cameraPosition = cameraPosition;
                    log("position: ${cameraPosition.target.toString()}");

                  },
                  onCameraIdle: () async {
                    mapPickerController.mapFinishedMoving!();
                    getAddressFromLatLong(cameraPosition.target.latitude, cameraPosition.target.longitude);
                  },
                ),

              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white.withOpacity(.9),
                ),
                child: Text(
                  "Location: $address",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          onPressed: () {
            if (address.isEmpty) {
              showToast("Please select your location");
            } else {
              saveGPSLocationNCountryCode(address, countryCode);
              Navigator.of(context).pushReplacement(PageTransition(child: IntroductionPage(), type: PageTransitionType.fade));
            }
          },
          child: const Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }
}
