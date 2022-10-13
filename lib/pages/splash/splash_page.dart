
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prediction/pages/BottomNavigation/bottom_navigation.dart';
import 'package:prediction/pages/introduction/intro_page.dart';
import 'package:prediction/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/language_controller.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../LaunchScreenAd/launch_screen_ad.dart';
import '../gps/select_location.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async{
      Navigator.of(context).pushReplacement(PageTransition(child: LaunchScreenAd(), type: PageTransitionType.fade));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: Container(
          color: primaryColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            "assets/images/splash_logo.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
