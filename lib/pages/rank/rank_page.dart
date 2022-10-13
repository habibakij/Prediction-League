import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/common/connectivity_checker.dart';
import 'package:prediction/controller/rank_controller.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/pages/rank/rank_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/language_controller.dart';
import '../../controller/ad_controller/ads_controller.dart';
import '../../package/slider/carousel_slider.dart';
import '../../util/constant.dart';
import '../../util/expandable_pageview.dart';
import '../../widget/empty_failure_no_internet_view.dart';
import '../login/login_page.dart';
import '../notification/notification_page.dart';

class RankPage extends StatefulWidget {
  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  final langController=Get.put(LanguageController());
  final controller=Get.put(RankController());
  final adsController=Get.put(AdsController());
  final internetController=Get.put(ConnectivityCheckerController());

  @override
  void initState(){
    super.initState();
    internetController.startMonitoring();
    langController.getLang();
    controller.getData(true);
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("apptitle".tr,style: toolbarTitleStyle,),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
              Navigator.of(context,rootNavigator: true).push(PageTransition(child: NotificationPage(), type: PageTransitionType.fade));
            }, icon: Icon(Icons.notifications,color: primaryColor,))
          ],
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white
          ),
        ),
        body: RefreshIndicator(
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
              Obx((){
                if(langController.isGuestMode.value == "1"){
                  return Center(
                    child: EmptyFailureNoInternetView(
                      image: 'assets/lottie/login.json',
                      title: 'Alert',
                      description: 'Please log in first',
                      buttonText: "Log In",
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pushReplacement(PageTransition(child: LoginPage(id: '',), type: PageTransitionType.rightToLeft));
                      },
                      status: 1,
                    ),
                  );
                }
                else if(controller.loading.value==true){
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
                      description: 'No data found',
                      buttonText: "Retry",
                      onPressed: () {
                        controller.getData(true); },
                      status: 0,
                    ),
                  );
                }else{
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 18,vertical: 16),
                      itemCount: controller.list.length,
                      itemBuilder: (context,index){
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          margin: EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF000000).withOpacity(0.08),
                                    offset: Offset(0,1),
                                    blurRadius: 8
                                )
                              ]
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 22,),
                              Row(
                                children: [
                                  Container(
                                    height: 32,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFFF1F7F7)
                                    ),
                                    child: Image.network("${controller.list[index].league!.logo}",fit: BoxFit.cover,),
                                  ),
                                  SizedBox(width: 17,),
                                  Text("${controller.list[index].league!.name}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF404040),fontWeight: FontWeight.w700,fontSize: 14)),)
                                ],
                              ),
                              SizedBox(height: 14,),
                              SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                          elevation: MaterialStateProperty.all(0),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12)
                                          ))
                                      ),
                                      onPressed: (){


                                      }, child: Text("season ${getSeason(controller.list[index].season!.year)}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15))))
                              ),
                              SizedBox(height: 19,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(flex:1,child: Text("WORLD",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontSize: 15,fontWeight: FontWeight.w600)),)),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text.rich(TextSpan(
                                          text: "${controller.list[index].world!.position}",
                                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF48C4B9),fontSize: 14,fontWeight: FontWeight.w600)),
                                          children: [
                                            TextSpan(
                                              text: "/${controller.list[index].world!.total}",
                                              style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF686868),fontSize: 14,fontWeight: FontWeight.w600)),
                                            )
                                          ]
                                      )),
                                    ),
                                  ),
                                  Expanded(flex:1,child: Align(alignment:langController.arabic.value?Alignment.centerLeft:Alignment.centerRight,child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Obx(()=>IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: (){
                                            Navigator.of(context,rootNavigator: true).push(PageTransition(child: RankDetailPage(points: controller.list[index].points??0, top: 'world', season: controller.list[index].season!, world: controller.list[index].world!, league: controller.list[index].league!,), type: PageTransitionType.rightToLeft));
                                          },
                                          icon: Transform.rotate(
                                              angle: langController.arabic.value?53.4:0,
                                              child: SvgPicture.asset("assets/images/right_arrow.svg",height: 15,))),)

                                  )))
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: Color(0xFF707070).withOpacity(0.10),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(flex:1,child: Text("CONTINENTS",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontSize: 15,fontWeight: FontWeight.w600)),)),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text.rich(TextSpan(
                                          text: "${controller.list[index].continent!.position}",
                                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF48C4B9),fontSize: 14,fontWeight: FontWeight.w600)),
                                          children: [
                                            TextSpan(
                                              text: "/${controller.list[index].continent!.total}",
                                              style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF686868),fontSize: 14,fontWeight: FontWeight.w600)),
                                            )
                                          ]
                                      )),
                                    ),
                                  ),
                                  Expanded(flex:1,child: Align(alignment:langController.arabic.value?Alignment.centerLeft:Alignment.centerRight,child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Obx(()=>IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: (){
                                            Navigator.of(context,rootNavigator: true).push(PageTransition(child: RankDetailPage(points: controller.list[index].points??0, top: 'continent', season: controller.list[index].season!, world: controller.list[index].continent!, league: controller.list[index].league!,), type: PageTransitionType.rightToLeft));

                                          },
                                          icon: Transform.rotate(
                                              angle: langController.arabic.value?53.4:0,
                                              child: SvgPicture.asset("assets/images/right_arrow.svg",height: 15,))),)

                                  )))
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: Color(0xFF707070).withOpacity(0.10),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(flex:1,child: Text("COUNTRY",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontSize: 15,fontWeight: FontWeight.w600)),)),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text.rich(TextSpan(
                                          text: "${controller.list[index].country!.position}",
                                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF48C4B9),fontSize: 14,fontWeight: FontWeight.w600)),
                                          children: [
                                            TextSpan(
                                              text: "/${controller.list[index].country!.total}",
                                              style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF686868),fontSize: 14,fontWeight: FontWeight.w600)),
                                            )
                                          ]
                                      )),
                                    ),
                                  ),
                                  Expanded(flex:1,child: Align(alignment:langController.arabic.value?Alignment.centerLeft:Alignment.centerRight,child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Obx(()=>IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: (){
                                            Navigator.of(context,rootNavigator: true).push(PageTransition(child: RankDetailPage(points: controller.list[index].points??0, top: 'country', season: controller.list[index].season!, world: controller.list[index].country!, league: controller.list[index].league!,), type: PageTransitionType.rightToLeft));


                                          },
                                          icon: Transform.rotate(
                                              angle: langController.arabic.value?53.4:0,
                                              child: SvgPicture.asset("assets/images/right_arrow.svg",height: 15,))),)

                                  )))
                                ],
                              ),
                              SizedBox(height: 17,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() => Text(langController.earned.value.toString(),style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontSize: 15,fontWeight: FontWeight.w700)),),),
                                  SizedBox(width:21 ,),
                                  Container(
                                    height: 30,
                                    width: 125,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color(0xFF1A1819)
                                    ),
                                    child: Center(child: Text.rich(TextSpan(
                                        text: "${controller.list[index].points??0} ",
                                        style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w500)),
                                        children: [
                                          TextSpan(
                                            text: langController.point.value.toString(),
                                            style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 9,fontWeight: FontWeight.w600)),
                                          )
                                        ]
                                    ))),
                                  )
                                ],
                              ),

                              SizedBox(height: 15,)

                            ],
                          ),
                        );
                      });





                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  guestDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Alert",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Please log in fast",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              backgroundColor: MaterialStateProperty.all(commonTextColor)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() =>Text(
                                langController.cancel.value.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              backgroundColor: MaterialStateProperty.all(primaryColor)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() =>Text(
                                langController.yes.value.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        });
  }

  getSeason(String? year) {
    var preYear=year!.replaceAll("20","");
    var postYear=int.parse(preYear)+1;
    return "$preYear/$postYear";
  }
}
