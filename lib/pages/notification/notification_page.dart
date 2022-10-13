import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/controller/ad_controller/ads_controller.dart';
import 'package:prediction/util/constant.dart';
import 'package:get/get.dart';
import '../../common/connectivity_checker.dart';
import '../../common/language_controller.dart';
import '../../controller/notification/notification_controller.dart';
import '../../package/slider/carousel_slider.dart';
import '../../widget/empty_failure_no_internet_view.dart';
import 'notification_details.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _ShareCupPageState();
}

class _ShareCupPageState extends State<NotificationPage> {

  final controller=Get.put(NotiController());
  final notificationController=Get.put(LanguageController());
  final internetController=Get.put(ConnectivityCheckerController());
  final adsController=Get.put(AdsController());

  @override
  void initState(){
    super.initState();
    internetController.startMonitoring();
    controller.getData(true);
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back,color: primaryColor,),
          ),
          title: Obx(() => Text(notificationController.notification.value.toString(), style: toolbarTitleStyle,),),
           centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark
          ),
        ),
        body: Obx((){
          if(controller.loading.value==true){
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
                  controller.getData(true);
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
                  controller.getData(true);
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
                  controller.getData(true);
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
                  controller.getData(true);
                },
                status: 1,
              ),
            );
          }else  if(controller.timeoutError.value==true){
            return Center(
              child: EmptyFailureNoInternetView(
                image: 'assets/lottie/failure_lottie.json',
                title: 'Timeout',
                description: 'Please try again',
                buttonText: "Retry",
                onPressed: () {
                  controller.getData(true);
                },
                status: 1,
              ),
            );
          }
          else  if(controller.loading.value==false&&controller.list.isEmpty){
            return Center(
              child: EmptyFailureNoInternetView(
                image: 'assets/lottie/empty_lottie.json',
                title: 'No Data',
                description: 'No notification found',
                buttonText: "Retry",
                onPressed: () {
                  controller.getData(true);
                },
                status: 0,
              ),
            );
          }
          else{
            return RefreshIndicator(
              onRefresh: ()async{
                controller.getData(false);
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
                              // setState(() {
                              //   if(adsController.appearanceTime.isNotEmpty){
                              //     if(adsController.appearanceTime[index] == 0){
                              //       adsController.fileName.removeAt(index);
                              //     } else {
                              //       adsController.appearanceTime[index]--;
                              //     }
                              //   }
                              //   //log("check_index: ${appController.appearanceTime[index]}");
                              // });
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
                  ListView.separated(
                    shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                     return InkWell(
                       child: Container(
                         padding: const EdgeInsets.all(5),
                         margin: const EdgeInsets.symmetric(horizontal: 15),
                         child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.list[index].data!.title!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(controller.list[index].data!.body!),
                            SizedBox(height: 2,),
                            Image.network(controller.list[index].data!.image??"",fit: BoxFit.fill,)
                          ],
                        ),
                       ),
                       onTap: (){
                         Get.to(NotificationDetailsScreen(), arguments: controller.list[index].id.toString());
                       },
                     );
                  }, separatorBuilder: (context,index){
                    return Container(height: 1, color: Colors.grey);
                  }, itemCount: controller.list.length),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
