import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/common/connectivity_checker.dart';
import 'package:prediction/common/language_controller.dart';
import 'package:prediction/controller/profile_controller.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/pages/login/login_page.dart';
import 'package:prediction/pages/profile/change_password_page.dart';
import 'package:prediction/pages/profile/edit_profile_page.dart';
import 'package:prediction/util/constant.dart';
import '../../controller/ad_controller/ads_controller.dart';
import '../../package/slider/carousel_slider.dart';
import '../../util/expandable_pageview.dart';
import '../../widget/empty_failure_no_internet_view.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final lanController=Get.put(LanguageController());
  final controller=Get.put(ProfileController());
  final internetController=Get.put(ConnectivityCheckerController());
  final adsController=Get.put(AdsController());
  @override
  void initState(){
    super.initState();
    internetController.startMonitoring();
    lanController.getLang();
    controller.getData(true);
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AppBar(
          title: Text(lanController.apptitle.value,style: toolbarTitleStyle,),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        // ExpandablePageView(hmm: '',
        // children:adsController.adsWidgetList),
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
        Obx(() {
          if(lanController.isGuestMode.value == "1"){
            return Center(
              child: EmptyFailureNoInternetView(
                image: 'assets/lottie/no_internet_lottie.json',
                title: 'Alert',
                description: 'Please log in fast',
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
                Center(child: Text("Please wait loading profile data..."),)
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
          }else{
            return ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 240,
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/profile_bg.png"),
                                fit: BoxFit.fill
                            )
                        ),
                        child: Column(
                          children: [

                            Text("@${controller.profile.value.username}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontSize: 20,fontWeight: FontWeight.w600)),),
                            Text("${controller.profile.value.country!.name}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontSize: 14,fontWeight: FontWeight.w700)),),
                            SizedBox(height: 50,),

                          ],
                        ),
                      ),
                      Positioned(bottom:0,left:0,right:0,child: controller.profileImage.isNotEmpty? CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                            radius: 60,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                                imageUrl: "${controller.profileImage.value}",
                                placeholder: (context, url) => Container(
                                    height: 120,
                                    width: 120,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image,)),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundImage: AssetImage("assets/images/profile_image.png"),),
                              ),)),
                      )
                          :CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage("assets/images/profile_image.png"),


                      ))
                    ],
                  ),
                ),

                Text("${controller.fullNameController.text}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w700)),),
                Text("${controller.emailController.text}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontSize: 12,fontWeight: FontWeight.w500)),),

                SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: primaryColor
                  ),
                  child: Center(child: Row(
                    children: [
                      Obx(() => Text(lanController.joining_app.value.toString(),style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w500)),),
                      Text(": ${controller.joiningDate.value}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w500)),),
                    ],
                  )),
                ),
                SizedBox(height: 16,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:48 ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text("${controller.leagueCount.value}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontSize: 16,fontWeight: FontWeight.w700)),),
                          SizedBox(height: 2,),
                          Obx(() => Text(lanController.league.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 12,fontWeight: FontWeight.w600)),),
                        ],
                      ),
                      SizedBox(height: 27,child: VerticalDivider(
                        thickness: 1,
                        color: Color(0xFFEBEBEB),
                      ),),
                      Column(
                        children: [
                          Text("${controller.privateLeagueCount.value}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontSize: 16,fontWeight: FontWeight.w700)),),
                          SizedBox(height: 2,),
                          Obx(() => Text(lanController.private_league.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 12,fontWeight: FontWeight.w600),textAlign: TextAlign.center,)),
                        ],
                      ),
                      SizedBox(height: 27,child: VerticalDivider(
                        thickness: 1,
                        color: Color(0xFFEBEBEB),
                      ),),
                      Column(
                        children: [
                          Text("${controller.privateCupCount.value}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontSize: 16,fontWeight: FontWeight.w700)),),
                          SizedBox(height: 2,),
                          Obx(() => Text(lanController.private_cup.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 12,fontWeight: FontWeight.w600),textAlign: TextAlign.center,)),
                        ],
                      ),
                      SizedBox(height: 27,child: VerticalDivider(
                        thickness: 1,
                        color: Color(0xFFEBEBEB),
                      ),),
                      Column(
                        children: [
                          Text("${controller.profile.value.likes}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontSize: 16,fontWeight: FontWeight.w700)),),
                          SizedBox(height: 2,),
                          Obx(() => Text(lanController.likes.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 12,fontWeight: FontWeight.w600)),),
                        ],
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 22,),
                Container(alignment:lanController.arabic.value?Alignment.centerRight:Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() => Text(lanController.bio.value.toString(),style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontSize: 15,fontWeight: FontWeight.w600)),textAlign: TextAlign.start,)),),
                SizedBox(height: 9,),
                Container(alignment:Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("${controller.bioController.text}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFAAAAAA),fontSize: 13,fontWeight: FontWeight.w500)),textAlign: TextAlign.start,)),
                SizedBox(height: 16,),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(PageTransition(child: EditProfilePage(), type: PageTransitionType.rightToLeft));
                  },
                  child: Container(alignment:Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 27,vertical:19 ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Color(0xFFF7F7F7),
                          border: Border.all(color: Color(0xFFECECEC),width: 1)
                      ),
                      child: Row(
                        children: [
                          IconButton(

                            icon: Image.asset("assets/images/edit.png"),
                            onPressed: (){
                              Navigator.of(context).push(PageTransition(child: EditProfilePage(), type: PageTransitionType.rightToLeft));
                            },),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(lanController.edit.value.toString(),style: TextStyle(color: primaryColor,fontSize: 14,fontWeight: FontWeight.w600),textAlign: TextAlign.start,),),
                              Obx(() => Text(lanController.profile_details.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 13,fontWeight: FontWeight.w500),)),
                            ],
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 16,),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(PageTransition(child: ChangePasswordPage(), type: PageTransitionType.rightToLeft));
                  },
                  child: Container(alignment:Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 27,vertical:19 ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Color(0xFFF7F7F7),
                          border: Border.all(color: Color(0xFFECECEC),width: 1)
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Image.asset("assets/images/lock.png",height: 20,width: 20,),
                            onPressed: (){
                              Navigator.of(context).push(PageTransition(child: ChangePasswordPage(), type: PageTransitionType.rightToLeft));
                            },),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(lanController.change_password.value.toString(),style: TextStyle(color: primaryColor,fontSize: 14,fontWeight: FontWeight.w600),textAlign: TextAlign.start,),),
                              Obx(() => Text(lanController.profile_details.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 13,fontWeight: FontWeight.w500),)),
                            ],
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 40,)
              ],
            );
          }
        }),
      ],
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
                  Obx(() => Text(
                    lanController.alart.value,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),),
                  const SizedBox(
                    height: 20,
                  ),
                   Obx(() => Text(
                     lanController.login_first.value,
                     style: TextStyle(
                       fontSize: 18,
                       color: Colors.black,
                     ),
                   ),),
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
                                lanController.cancel.value.toString(),
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
                                lanController.yes.value.toString(),
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

}
