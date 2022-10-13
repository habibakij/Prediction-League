import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/common/connectivity_checker.dart';
import 'package:prediction/common/language_controller.dart';
import 'package:prediction/controller/home_controller.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/package/slider/carousel_slider.dart';
import 'package:prediction/pages/StartPrediction/start_prediction_page.dart';
import 'package:prediction/pages/notification/notification_page.dart';
import 'package:prediction/util/constant.dart';
import 'package:prediction/util/expandable_pageview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/ad_controller/ads_controller.dart';
import '../../controller/rank_controller.dart';
import '../../widget/empty_failure_no_internet_view.dart';
import '../login/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appController = Get.put(HomeController());
  final adsController = Get.put(AdsController());
  final internetController = Get.put(ConnectivityCheckerController());
  var languageController = Get.put(LanguageController());
  String isGuestMode = "";


  void detectGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    isGuestMode = prefs.getString("guestMode").toString();
    log("check_guest_mode: $isGuestMode");
  }

  @override
  void initState() {
    super.initState();
    detectGuestMode();
    internetController.startMonitoring();
    appController.getData(true);

  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.white),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                "apptitle".tr,
                style: toolbarTitleStyle,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                        PageTransition(
                            child: NotificationPage(),
                            type: PageTransitionType.fade));
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: primaryColor,
                  ),
                )
              ],
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarColor: Colors.white),
            ),
            body: Obx(() {
              if (appController.loading.value == true) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(child: CircularProgressIndicator()),
                    const Center(
                      child: Text("Please wait..."),
                    )
                  ],
                );
              } else if (internetController.isOnline.value == false) {
                return Center(
                  child: EmptyFailureNoInternetView(
                    image: 'assets/lottie/no_internet_lottie.json',
                    title: 'Internet Error',
                    description: 'Internet not found',
                    buttonText: "Retry",
                    onPressed: () {
                      appController.getData(true);
                    },
                    status: 1,
                  ),
                );
              } else if (appController.internetError.value == true) {
                return Center(
                  child: EmptyFailureNoInternetView(
                    image: 'assets/lottie/no_internet_lottie.json',
                    title: 'Internet Error',
                    description: 'Internet not found',
                    buttonText: "Retry",
                    onPressed: () {
                      appController.getData(true);
                    },
                    status: 1,
                  ),
                );
              } else if (appController.serverError.value == true) {
                return Center(
                  child: EmptyFailureNoInternetView(
                    image: 'assets/lottie/failure_lottie.json',
                    title: 'Server error'.tr,
                    description: 'Please try again later',
                    buttonText: "Retry",
                    onPressed: () {
                      appController.getData(true);
                    },
                    status: 1,
                  ),
                );
              } else if (appController.somethingWrong.value == true) {
                return Center(
                  child: EmptyFailureNoInternetView(
                    image: 'assets/lottie/failure_lottie.json',
                    title: 'Something went wrong',
                    description: 'Please try again later',
                    buttonText: "Retry",
                    onPressed: () {
                      appController.getData(true);
                    },
                    status: 1,
                  ),
                );
              } else if (appController.timeoutError.value == true) {
                return Center(
                  child: EmptyFailureNoInternetView(
                    image: 'assets/lottie/failure_lottie.json',
                    title: 'Timeout',
                    description: 'Please try again',
                    buttonText: "Retry",
                    onPressed: () {
                      appController.getData(true);
                    },
                    status: 1,
                  ),
                );
              } else {
                return ListView(
                  padding: EdgeInsets.zero,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            maxHeight: height(context, "")
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Obx(() => CarouselSlider.builder(
                              options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction:  1,
                                disableCenter: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    if(adsController.appearanceTime[index] >= 0){
                                      adsController.appearanceTime[index]--;
                                    }
                                  });
                                },
                              ),
                              itemCount: adsController.fileName.length,
                              itemBuilder: (context, index, _) {
                                return InkWell(
                                  onTap: () {
                                    showToast("click: $index");
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Obx(() => Image.network(
                                      adsController.fileName.isEmpty ? adsController.cashImage : adsController.appearanceTime[index] >= 0 ?
                                      "http://167.71.227.239${adsController.fileName[index].toString()}" : adsController.cashImage,
                                      //height: 80,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),),
                                  ),
                                );
                              },
                            ),),

                          ],
                        ),
                      ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      itemCount: appController.list.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFF000000)
                                        .withOpacity(0.08),
                                    offset: const Offset(0, 1),
                                    blurRadius: 8)
                              ]),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 22,
                              ),
                              Container(
                                height: 40,
                                width: 55,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl:
                                  "${appController.list[index].logo}",
                                  placeholder: (context, url) => Container(
                                      height: 32,
                                      width: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image,
                                      )),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          height: 32,
                                          width: 60,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image,
                                          )),
                                ),
                              ),

                              const SizedBox(
                                height: 14,
                              ),
                              Text(
                                "${appController.list[index].name}",
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Color(0xFF404040),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                              ),
                               const SizedBox(
                                width: 40,
                              ),

                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            primaryColor),
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                  ),
                                  onPressed: () async {

                                      Navigator.of(context, rootNavigator: true)
                                          .push(PageTransition(
                                              child: StartPredictionPage(
                                                leagueId: appController
                                                    .list[index].id
                                                    .toString(),
                                                seasonId: appController
                                                    .seasonId.value
                                                    .toString(), isSubscribed: appController
                                                  .list[index].isSubscribed??false,
                                              ),
                                              type: PageTransitionType.fade));

                                  },
                                  child: Obx(
                                    () => Text(
                                      languageController.startprediction.value
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 32,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 19, vertical: 8),
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        topLeft: Radius.circular(16)),
                                    color: Color(0xFFF4F4F4)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Season ${getSeason(appController.season.value)}",
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              color: Color(0xFF535353),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic)),
                                    ),
                                    Text(
                                      appController.list[index].currentRound !=
                                              null
                                          ? "Round ${appController.list[index].currentRound!.name}"
                                          : "",
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              color: Color(0xFF535353),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      })
                ]);
              }
            })));
  }


}

class ParallelogramClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0.0, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, 0.0)
      ..lineTo(0.0, size.height / 2)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
