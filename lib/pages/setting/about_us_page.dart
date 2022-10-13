import 'package:flutter_html/flutter_html.dart';
import 'package:prediction/controller/ad_controller/ads_controller.dart';

import '../../common/language_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/common/connectivity_checker.dart';
import 'package:prediction/controller/setting_controller.dart';
import 'package:prediction/util/constant.dart';

import '../../package/slider/carousel_slider.dart';
import '../../widget/empty_failure_no_internet_view.dart';

class AboutUsPage extends StatefulWidget {
  final String id;

  @override
  const AboutUsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPage();
}

class _AboutUsPage extends State<AboutUsPage> {
  final controller = Get.put(SettingsController());
  final internetController = Get.put(ConnectivityCheckerController());
  final adsController= Get.put(AdsController());

  @override
  void initState() {
    super.initState();
    internetController.startMonitoring();
    controller.getData(true, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: primaryColor,
                    ),
                  ),
                  Text("aboutus".tr,
                      style: TextStyle(
                          color: Color(0xFF1A1819),
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 20,
                    width: 70,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(child: Obx(() {
                if (controller.loading.value == true) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      Center(
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
                        controller.getData(true, widget.id);
                      },
                      status: 1,
                    ),
                  );
                } else if (controller.internetError.value == true) {
                  return Center(
                    child: EmptyFailureNoInternetView(
                      image: 'assets/lottie/no_internet_lottie.json',
                      title: 'Internet Error',
                      description: 'Internet not found',
                      buttonText: "Retry",
                      onPressed: () {
                        controller.getData(true, widget.id);
                      },
                      status: 1,
                    ),
                  );
                } else if (controller.serverError.value == true) {
                  return Center(
                    child: EmptyFailureNoInternetView(
                      image: 'assets/lottie/failure_lottie.json',
                      title: 'Server error'.tr,
                      description: 'Please try again later',
                      buttonText: "Retry",
                      onPressed: () {
                        controller.getData(true, widget.id);
                      },
                      status: 1,
                    ),
                  );
                } else if (controller.somethingWrong.value == true) {
                  return Center(
                    child: EmptyFailureNoInternetView(
                      image: 'assets/lottie/failure_lottie.json',
                      title: 'Something went wrong',
                      description: 'Please try again later',
                      buttonText: "Retry",
                      onPressed: () {
                        controller.getData(true, widget.id);
                      },
                      status: 1,
                    ),
                  );
                } else if (controller.timeoutError.value == true) {
                  return Center(
                    child: EmptyFailureNoInternetView(
                      image: 'assets/lottie/failure_lottie.json',
                      title: 'Timeout',
                      description: 'Please try again',
                      buttonText: "Retry",
                      onPressed: () {
                        controller.getData(true, widget.id);
                      },
                      status: 1,
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                      if(adsController.appearanceTime.isNotEmpty){
                                        if(adsController.appearanceTime[index] == 0){
                                          adsController.fileName.removeAt(index);
                                        } else {
                                          adsController.appearanceTime[index]--;
                                        }
                                      }
                                      //log("check_index: ${appController.appearanceTime[index]}");
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
                                        adsController.fileName.isEmpty ? adsController.cashImage : adsController.appearanceTime[index] >= 1 ?
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
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 27),
                          child: Html(data: "${controller.data.value.data!.content}"),
                        )
                      ],
                    ),
                  );
                }
              }))
            ],
          ),
        ),
        value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.white));
  }
}
