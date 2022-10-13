import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prediction/controller/ad_controller/ads_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/introduction/introduction_controller.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../util/constant.dart';
import '../BottomNavigation/bottom_navigation.dart';
import '../gps/select_location.dart';
import '../introduction/intro_page.dart';

class LaunchScreenAd extends StatefulWidget {
  @override
  _LaunchScreenAd createState() => _LaunchScreenAd();
}


class _LaunchScreenAd extends State<LaunchScreenAd> {
  var appController= Get.put(IntroController());
  var adsController= Get.put(AdsController());
  String cashImage= "https://thumbs.dreamstime.com/z/prediction-icon-simple-element-data-organization-collection-filled-templates-infographics-more-172201654.jpg";

  String location = "";
  isSelectedGPSLocation() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    location = pref.getString("gpsLocation").toString();
    log("check_location: $location");
  }

  @override
  void initState() {
    super.initState();
    appController.getLaunchScreedAds();
    isSelectedGPSLocation();
    Timer(const Duration(seconds: 5), () async{
      String token = await getStringPrefs(TOKEN);
      log("token_: $token");
      if (location == "null") {
        Navigator.of(context).pushReplacement(PageTransition(child: SelectLocationPage(), type: PageTransitionType.fade));
      } else {
        if (token.isNotEmpty) {
          Navigator.of(context).pushReplacement(PageTransition(child: ContainerPage(id: '',), type: PageTransitionType.fade));
        } else {
          Navigator.of(context).pushReplacement(PageTransition(child: IntroductionPage(), type: PageTransitionType.fade));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Obx(() => Image.network(
          appController.lFileName.value.toString().isEmpty ? cashImage :
          "http://167.71.227.239${appController.lFileName.value.toString()}",
          fit: BoxFit.fill,
        ),),
      ),
    );
  }
}
