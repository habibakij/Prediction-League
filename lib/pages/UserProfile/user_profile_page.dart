import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/common/language_controller.dart';
import 'package:prediction/controller/user_profile_controller.dart';
import 'package:prediction/util/country.dart';

import '../../common/connectivity_checker.dart';
import '../../controller/ad_controller/ads_controller.dart';
import '../../package/slider/carousel_slider.dart';
import '../../util/constant.dart';
import '../../util/expandable_pageview.dart';
import '../../widget/empty_failure_no_internet_view.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  const UserProfilePage({Key? key,required this.userId}) : super(key: key);
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final controller=Get.put(UserProfileController());
  final adsController=Get.put(AdsController());
  final internetController=Get.put(ConnectivityCheckerController());
  var languageController= Get.put(LanguageController());

  @override
  void initState(){
    super.initState();
    internetController.startMonitoring();
    controller.getData(true,widget.userId);
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
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Icon(Icons.arrow_back,color: primaryColor,),),
            title:  Text("apptitle".tr,style:TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w600)),
            centerTitle: true,
            actions: [
              // IconButton(
              //     onPressed: () {},
              //     icon: Icon(
              //       Icons.notifications,
              //       color: primaryColor,
              //     ))
            ],
          ),
          body: Obx((){
            if(controller.loading.value==true){
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
                    controller.getData(true,widget.userId);
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
                    controller.getData(true,widget.userId);
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
                    controller.getData(true,widget.userId);
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
                    controller.getData(true,widget.userId);
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
                    controller.getData(true,widget.userId);
                  },
                  status: 1,
                ),
              );
            }else{
              return SingleChildScrollView(
                child: Column(
                  children: [
                    //Image.asset("assets/images/banner.png"),

                   // ExpandablePageView(children:adsController.adsWidgetList),
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
                    Container(
                      height: 200,
                      child: Stack(children: <Widget>[ //stack overlaps widgets
                        Opacity( //semi red clippath with more height and with 0.5 opacity
                          opacity: 0.8,
                          child: ClipPath(
                            clipper:WaveClipper(), //set our custom wave clipper
                            child:Container(
                              color:Colors.green,
                              height:200,
                            ),
                          ),
                        ),

                        ClipPath(  //upper clippath with less height
                          clipper:WaveClipper(), //set our custom wave clipper.
                          child:Container(
                            padding: EdgeInsets.only(bottom: 50),
                            color:primaryColor,
                            height:190,
                            alignment: Alignment.center,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 58,
                            backgroundColor: Colors.transparent,
                            backgroundImage: CachedNetworkImageProvider("${controller.userProfile.value.profilePicture}"),

                          ),
                        )
                      ],),
                    ),
                    SizedBox(height: 20,),
                    Text("@${controller.userProfile.value.username}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 20)),),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(controller.countryFlag.value),
                          SizedBox(width: 10,),
                          Text("${controller.userProfile.value.country!.name}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontSize: 15,fontWeight: FontWeight.w600)),),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(child: Container(
                          height: 109,
                          color: Color(0xFFF4F4F4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${controller.userProfile.value.leaguesCount!}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 29)),),
                              SizedBox(height: 5,),
                              Obx(() => Text(languageController.league.value.toString(), style: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w500,fontSize: 14))),
                            ],
                          ),
                        )),
                        Expanded(child: Container(
                          height: 109,
                          color: Color(0xFF1A1819),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${controller.userProfile.value.privateLeaguesCount!}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 29)),),
                              SizedBox(height: 5,),
                              Obx(() => Text(languageController.private_league.value.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 14),textAlign: TextAlign.center,)),
                            ],
                          ),
                        )),
                        Expanded(child: Container(
                          height: 109,
                          color: Color(0xFFF4F4F4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${controller.userProfile.value.privateCupsCount!}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 29)),),
                              SizedBox(height: 5,),
                              Obx(() => Text(languageController.private_cup.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w500,fontSize: 14),textAlign: TextAlign.center,)),
                            ],
                          ),
                        )),
                        Expanded(child: GestureDetector(
                          onTap: (){
                            showCustomBottomSheet(context);

                          },
                          child: Container(
                            height: 109,
                            color: primaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/images/rank_icon.svg",color: Colors.white,),
                                SizedBox(height: 5,),
                                Obx(() => Text(languageController.rank.value.toString(),style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500)),)),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(height: 36,),
                    Obx(() => Text(languageController.joining_app.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 17,fontWeight: FontWeight.w600)),),
                    SizedBox(height: 5,),
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width*0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryColor
                      ),
                      child: Center(child: Text("${getDateOfJoin(controller.userProfile.value.created_at)}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15)),),),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Obx(() => Text(languageController.bio.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 18,fontWeight: FontWeight.w600)),),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Text("${controller.userProfile.value.bio}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(
                          0xFF9B9B9B),fontSize: 16,fontWeight: FontWeight.w600)),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(onPressed: ()async{
                             showLoaderDialog(context, "Please wait...");
                             var response=await sendLiking(widget.userId);
                             Navigator.of(context).pop();
                             if(response.statusCode==200){
                               controller.likes.value=controller.likes.value+1;
                               showToast("Liked");
                             }else{
                               showToast("Failed!");
                             }
                        }, icon: Image.asset("assets/images/hand.png")),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("${controller.likes.value} ",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 17)),),
                            Obx(() => Text(languageController.likes.value.toString(),style:TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 17)),),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          }),
        )
    );
  }
  showCustomBottomSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
        ),
        builder: (_){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    SizedBox(width: 20,),
                    Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey
                      ),
                    ),
                    IconButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.close))
                  ],
                ),
                SizedBox(height: 10,),
                Text("Ranks",style: TextStyle(color: Colors.red,fontSize: 18),),
                Divider(
                  thickness: 1,
                  color: Colors.red,
                ),
                SizedBox(height: 10,),
                ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  shrinkWrap: true,
                    itemBuilder: (con,index){
                      return Column(
                        children: [
                          Container(

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.5)
                            ),

                            child: Text("${controller.listData[index].league!.name}",style: TextStyle(fontSize: 17),),
                            padding: EdgeInsets.all(10),
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("WORLD"),
                              Text("${controller.listData[index].world!.position}/${controller.listData[index].world!.total}")
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("CONTINENT"),
                              Text("${controller.listData[index].continent!.position}/${controller.listData[index].continent!.total}")
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("COUNTRY"),
                              Text("${controller.listData[index].country!.position}/${controller.listData[index].country!.total}")
                            ],
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (con,index){
                      return SizedBox(height: index==controller.listData.length-1?40:10,);
                    },
                    itemCount: controller.listData.length
                ),

                
              ],
            ),
          );
        });
  }
  getDateOfJoin(String? startedAt) {
    DateTime parsedDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(startedAt!).toLocal();

    return "${parsedDateFormat.day}.${parsedDateFormat.month}.${parsedDateFormat.year}";
  }
}
class WaveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {

    var path = new Path();
    path.lineTo(0, size.height); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    //second point of quadratic bezier curve


    var secondStart = Offset(size.width - (size.width / 3.24), size.height - 105);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);
    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);



    path.lineTo(size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; //if new instance have different instance than old instance
    //then you must return true;
  }
}
