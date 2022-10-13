import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:prediction/controller/ad_controller/ads_controller.dart';
import '../../common/connectivity_checker.dart';
import '../../controller/notification/notification_details_controller.dart';
import '../../package/slider/carousel_slider.dart';
import '../../util/constant.dart';
import '../../widget/empty_failure_no_internet_view.dart';

class NotificationDetailsScreen extends StatefulWidget {
  @override
  _NotificationDetailsScreen createState() => _NotificationDetailsScreen();
}

class _NotificationDetailsScreen extends State<NotificationDetailsScreen> {

  final notificationController=Get.put(NotificationDetailsController());
  final internetController=Get.put(ConnectivityCheckerController());
  var notificationID;
  final adsController=Get.put(AdsController());

  @override
  void initState(){
    super.initState();
    notificationID= Get.arguments;
    log("check_details_argument: $notificationID");
    internetController.startMonitoring();
    notificationController.notificationDetailsData(notificationID.toString(), true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back,color: primaryColor,),
        ),
        title: Text("Notification Details",style: toolbarTitleStyle,),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark
        ),
      ),
      body: Obx((){
        if(notificationController.loading.value == true){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator()),
              Center(child: Text("Please wait..."),)
            ],
          );
        }
        else if (internetController.isOnline.value == false) {
          return Center(
            child: EmptyFailureNoInternetView(
              image: 'assets/lottie/no_internet_lottie.json',
              title: 'Internet Error',
              description: 'Internet not found',
              buttonText: "Retry",
              onPressed: () {
                //notificationController.getData(true);
              },
              status: 1,
            ),
          );
        }
        else  if(notificationController.loading.value == false && notificationController.detailsData.isEmpty){
          return Center(
            child: EmptyFailureNoInternetView(
              image: 'assets/lottie/empty_lottie.json',
              title: 'No Data',
              description: 'No notification found',
              buttonText: "Retry",
              onPressed: () {
                //notificationController.getData(true);
              },
              status: 0,
            ),
          );
        }
        else{
          return RefreshIndicator(
            onRefresh: ()async{
              notificationController.loading.value=false;
            },
            child: ListView(
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
                SizedBox(height: 10,),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificationController.detailsTitle.value.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        notificationController.detailsText.value.toString(),
                      ),
                      Text(
                          getTimeAgo(notificationController.detailsCreate.value.toString())
                      )
                    ],
                  ),
                ),
              ],
            )
          );
        }
      }),
    );
  }
}
