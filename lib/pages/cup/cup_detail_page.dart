
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:prediction/common/connectivity_checker.dart';
import 'package:prediction/common/language_controller.dart';
import 'package:prediction/controller/cup_detail_controller.dart';
import 'package:prediction/model/cup_detail.dart';

import '../../api_request/api_call.dart';
import '../../controller/ad_controller/ads_controller.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../package/slider/carousel_slider.dart';
import '../../util/constant.dart';
import '../../util/expandable_pageview.dart';
import '../../widget/empty_failure_no_internet_view.dart';
import '../UserProfile/user_profile_page.dart';
import '../chat/message_page.dart';

class CupDetailPage extends StatefulWidget {
  final String id;
  const CupDetailPage({Key? key,required this.id}) : super(key: key);
  @override
  State<CupDetailPage> createState() => _CupDetailPageState();
}

class _CupDetailPageState extends State<CupDetailPage> {
  var languageController= Get.put(LanguageController());
  final adsController=Get.put(AdsController());
  final controller=Get.put(CupDetailController());
  final internetController=Get.put(ConnectivityCheckerController());

  int index=0;
  var userId=0;

  getUserId()async{
    userId=await getIntPrefs(USER);

    setState((){});
  }
  @override
  void initState(){
    super.initState();
    getUserId();
    internetController.startMonitoring();
    controller.getData(true, widget.id);
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,statusBarColor: Colors.white
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.arrow_back,color: primaryColor,),),
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/create_cup.png",color: primaryColor,height: 18,width: 18,),
              const SizedBox(width: 10,),
              Obx(() => Text(languageController.cup_details.value.toString(),style: toolbarTitleStyle,),),
            ],
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,statusBarColor: Colors.white
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if(controller.loading.value==false){
                    Navigator.of(context).push(PageTransition(child: MessagePage(competetors: controller.detailData.value.competitorsCount.toString(), leagueTitle: controller.detailData.value.title!, leagueId: '${controller.detailData.value.id}',), type: PageTransitionType.rightToLeft));

                  }else{

                  }
                },
                icon:  Image.asset(
                  "assets/images/chatboxes.png",height: 20,width: 20,
                ))
          ],
        ),
        body: Obx((){
          if(controller.loading.value==true){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                Center(child: const CircularProgressIndicator()),
                Center(child: Obx(()=>Text(languageController.wait.value),))
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
                  controller.getData(true,widget.id);
                },
                status: 1,
              ),
            );
          }
          else if (controller.internetError.value == true) {
            return Center(
              child: EmptyFailureNoInternetView(
                image: 'assets/lottie/no_internet_lottie.json',
                title: 'Internet Error',
                description: 'Internet not found',
                buttonText: "Retry",
                onPressed: () {
                  controller.getData(true,widget.id);
                },
                status: 1,
              ),
            );
          }
          else if (controller.serverError.value == true) {
            return Center(
              child: EmptyFailureNoInternetView(
                image: 'assets/lottie/failure_lottie.json',
                title: 'Server error'.tr,
                description: 'Please try again later',
                buttonText: "Retry",
                onPressed: () {
                  controller.getData(true,widget.id);   },
                status: 1,
              ),
            );
          }
          else if (controller.somethingWrong.value == true) {
            return Center(
              child: EmptyFailureNoInternetView(
                image: 'assets/lottie/failure_lottie.json',
                title: 'Something went wrong',
                description: 'Please try again later',
                buttonText: "Retry",
                onPressed: () {
                  controller.getData(true,widget.id);  },
                status: 1,
              ),
            );
          }
          else  if(controller.timeoutError.value==true){
            return Center(
              child: EmptyFailureNoInternetView(
                image: 'assets/lottie/failure_lottie.json',
                title: 'Timeout',
                description: 'Please try again',
                buttonText: "Retry",
                onPressed: () {
                  controller.getData(true,widget.id);  },
                status: 1,
              ),
            );
          }
          else{
            return SingleChildScrollView(
              child: Column(
                children: [
                  //Image.asset("assets/images/banner.png",height: 85,width: double.infinity,fit: BoxFit.cover,),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Column(
                      children: [
                        SizedBox(height: 13,),
                        Text("${controller.detailData.value.title}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontSize: 18,fontWeight: FontWeight.w600)),),
                        SizedBox(height: 5,),
                        GestureDetector(
                          onTap: (){
                            if(userId!=controller.detailData.value.user!.id!){
                              showToast("Sorry only owner of the league can edit this");
                              return;
                            }
                            final controllerDes=TextEditingController();
                            showDialog(context: context, builder: (_){
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Update Description."),
                                      SizedBox(height: 10,),
                                      TextFormField(
                                        controller: controllerDes,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(

                                            filled: true,
                                            hintText: languageController.type.value.toString(),
                                            hintStyle: TextStyle(color: Color(0xFFAAAAAA),fontWeight: FontWeight.w500,fontSize: 15),
                                            fillColor: Color(0xFFFAFAFA),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(color: Color(0xFFE7E7E7),width: 1)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(color: Color(0xFFE7E7E7),width: 1)
                                            ),enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Color(0xFFE7E7E7),width: 1)
                                        )
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(

                                              onPressed: (){
                                                Navigator.of(context).pop();

                                              }, child: Text("Cancel"),style: ElevatedButton.styleFrom(
                                                surfaceTintColor: primaryColor,
                                                primary: primaryColor.withOpacity(0.5)
                                            ),),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: ElevatedButton(onPressed: ()async{
                                              Navigator.of(context).pop();
                                              LoadingProgress.start(context);
                                              var response=await sendUpdateDes(controllerDes.text, controller.detailData.value.id!.toString());
                                              LoadingProgress.stop(context);
                                              if(response.statusCode==200){
                                                showToast("Updated!");
                                                controller.detailData.value.description=controllerDes.text;
                                              }



                                            }, child: Text("Update"),style: ElevatedButton.styleFrom(
                                                surfaceTintColor: primaryColor,
                                                primary: primaryColor
                                            ),),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                            child: Text("${controller.detailData.value.description} (editable by clicking on it)",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600)),)),
                        SizedBox(height: 5,),
                        Text("Play for ${controller.detailData.value.playFor}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600)),),
                        SizedBox(height: 5,),
                        controller.detailData.value.playFor=="prize"?Text("Contact Number ${controller.detailData.value.contact}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600)),):SizedBox(),
                        SizedBox(height: 6,),
                        Image.network("${controller.detailData.value.league!.logo}",height: 32,width: 60,),
                        SizedBox(height: 6,),
                        Text("${controller.detailData.value.league!.name}",style: GoogleFonts.poppins(textStyle: TextStyle(color:Color(0xFF404040),fontWeight: FontWeight.w600,fontSize: 15 )),),
                        SizedBox(height: 6,),
                        Text(controller.detailData.value.type=="home-and-away"?"TYPE OF COMPETITION HOME & AWAY":"TYPE OF COMPETITION ONE MATCH",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFA9A9A9),fontSize: 12,fontWeight: FontWeight.w500)),),
                        SizedBox(height: 6,),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(21),topLeft: Radius.circular(21)),
                        color: Color(0xFFFAFAFA),
                        border: Border.all(color: Color(0xFFE7E7E7),width: 1)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 22,),
                        Text("Round ${controller.detailData.value.startingRound!.name} Started",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 14)),),
                        Text("${controller.detailData.value.startingRound!.startedAt!.substring(0,10)}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontSize: 20,fontWeight: FontWeight.w600)),),
                        SizedBox(height: 15,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(controller.detailData.value.rounds!.length, (i) => GestureDetector(
                              onTap: (){
                                setState((){
                                  index=i;
                                  controller.getEastWest(i);
                                });
                              },
                              child: index==i?Container(
                                margin: EdgeInsets.only(right: 3),
                                height: 74,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: primaryColor,
                                ),
                                child: Center(child: Text("${controller.detailData.value.rounds![i].name}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20)),)),
                              ):Container(
                                margin: EdgeInsets.only(right: 3),
                                height: 57,
                                width: 84,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xFFF4F4F4),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${controller.detailData.value.rounds![i].name}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF999999),fontWeight: FontWeight.w700,fontSize: 17)),),
                                  ],
                                ),
                              ),
                            )),
                          ),
                        ),

                        Container(
                            width: double.infinity,
                            height: 32,
                            padding: EdgeInsets.symmetric(horizontal: 26),
                            margin: EdgeInsets.only(top: 14 ),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(27)
                                    ))
                                ),
                                onPressed: (){

                                }, child: Text(languageController.east.value.toString(),style:TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15)))
                        ),
                        SizedBox(height: 18,),
                        Column(
                          children: List.generate(controller.eastList.length, (index) {
                            int i=0;
                            i = (index+1)+index;
                            return Container(
                              height: 59,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xFFF3F3F3),width: 1)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 59,
                                    width: 41,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),topRight: Radius.circular(15)),
                                        color: commonTextColor
                                    ),
                                    child: Center(child: Text("${i}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15)),),),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(PageTransition(child: UserProfilePage(userId: '${controller.eastList[index].users![0].id!}',), type: PageTransitionType.rightToLeft));

                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(controller.eastList[index].users![0].profilePicture!),
                                        ),
                                        SizedBox(width: 2,),
                                        Text("${controller.eastList[index].users![0].username}",style: GoogleFonts.poppins(textStyle: TextStyle(color: isWinner1(controller.eastList[index].users)?Colors.orange:Color(0xFF424242),fontSize: 12,fontWeight: FontWeight.w500)),)
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${controller.eastList[index].users![0].points}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w700,fontSize: 17)),),
                                      Obx(() => Text(languageController.pts.value.toString(),style:TextStyle(color: commonTextColor,fontWeight: FontWeight.w400,fontSize: 11))),
                                    ],
                                  ),
                                  Obx(() => Text(languageController.vs.value.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14)),),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${controller.eastList[index].users![1].points}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w700,fontSize: 17)),),
                                      Obx(() => Text(languageController.pts.value.toString(),style: TextStyle(color: commonTextColor,fontWeight: FontWeight.w400,fontSize: 11),),),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(PageTransition(child: UserProfilePage(userId: '${controller.eastList[index].users![1].id!}',), type: PageTransitionType.rightToLeft));

                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(controller.eastList[index].users![1].profilePicture!),
                                        ),
                                        SizedBox(width: 2,),
                                        Text("${controller.eastList[index].users![1].username}",style: GoogleFonts.poppins(textStyle: TextStyle(color: isWinner2(controller.eastList[index].users)?Colors.orange:Color(0xFF424242),fontSize: 12,fontWeight: FontWeight.w500)),)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 59,
                                    width: 41,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),topLeft: Radius.circular(15)),
                                        color: commonTextColor
                                    ),
                                    child: Center(child: Text("${(++i)}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15)),),),
                                  )
                                ],
                              ),
                            );
                          }),
                        ),




                        Container(
                            width: double.infinity,
                            height: 32,
                            padding: EdgeInsets.symmetric(horizontal: 26),
                            margin: EdgeInsets.only(top: 14 ),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(27)
                                    ))
                                ),
                                onPressed: (){

                                }, child: Text(languageController.west.value.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15)))
                        ),
                        SizedBox(height: 18,),
                        Column(
                          children: List.generate(controller.westList.length, (index) {
                            int i=0;
                            i = (index+1)+index;
                            return Container(
                              height: 59,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xFFF3F3F3),width: 1)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 59,
                                    width: 41,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),topRight: Radius.circular(15)),
                                        color: commonTextColor
                                    ),
                                    child: Center(child: Text("${i}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15)),),),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(PageTransition(child: UserProfilePage(userId: '${controller.westList[index].users![0].id!}',), type: PageTransitionType.rightToLeft));

                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(controller.westList[index].users![0].profilePicture!),
                                        ),
                                        SizedBox(width: 2,),
                                        Text("${controller.westList[index].users![0].username}",style: GoogleFonts.poppins(textStyle: TextStyle(color: isWinner1(controller.westList[index].users)?Colors.orange:Color(0xFF424242),fontSize: 12,fontWeight: FontWeight.w500)),)
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${controller.westList[index].users![0].points}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w700,fontSize: 17)),),
                                      Obx(() => Text(languageController.pts.value.toString(),style:TextStyle(color: commonTextColor,fontWeight: FontWeight.w400,fontSize: 11))),
                                    ],
                                  ),
                                  Obx(() => Text(languageController.vs.value.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14)),),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${controller.westList[index].users![1].points}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w700,fontSize: 17)),),
                                      Obx(() => Text(languageController.pts.value.toString(),style: TextStyle(color: commonTextColor,fontWeight: FontWeight.w400,fontSize: 11),),),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(PageTransition(child: UserProfilePage(userId: '${controller.westList[index].users![1].id!}',), type: PageTransitionType.rightToLeft));

                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(controller.westList[index].users![1].profilePicture!),
                                        ),
                                        SizedBox(width: 2,),
                                        Text("${controller.westList[index].users![1].username}",style: GoogleFonts.poppins(textStyle: TextStyle(color: isWinner2(controller.westList[index].users)?Colors.orange:Color(0xFF424242),fontSize: 12,fontWeight: FontWeight.w500)),)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 59,
                                    width: 41,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),topLeft: Radius.circular(15)),
                                        color: commonTextColor
                                    ),
                                    child: Center(child: Text("${(i++)+1}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15)),),),
                                  )
                                ],
                              ),
                            );
                          }),
                        ),


                        SizedBox(height: 20,)

                      ],
                    ),
                  ),



                ],
              ),
            );
          }
        })
      ),
    );
  }

 bool isWinner1(List<Users>? users) {
    int user1Point=users![0].points??0;
    int user2Point=users[1].points??0;
    if(user1Point>user2Point){
      return true;
    }
    else if(user1Point<user2Point){
      return false;
    }
    else if(user1Point==user2Point){
      DateTime user1Time = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(users[0].subscribed_at!).toLocal();
      DateTime user2Time = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(users[1].subscribed_at!).toLocal();
      if(user1Time.isBefore(user2Time)){
        return true;
      }
      else if(user1Time.isAfter(user2Time)){
        return false;
      }
      else if(user1Time.isAtSameMomentAs(user2Time)){
        return true;
      }
    }
    return false;

  }
  isWinner2(List<Users>? users) {
    int user1Point=users![0].points??0;
    int user2Point=users[1].points??0;
    if(user1Point>user2Point){
      return false;
    }
    else if(user1Point<user2Point){
      return true;
    }
    else if(user1Point==user2Point){
      DateTime user1Time = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(users[0].subscribed_at!).toLocal();
      DateTime user2Time = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(users[1].subscribed_at!).toLocal();
      if(user1Time.isBefore(user2Time)){
        return false;
      }
      else if(user1Time.isAfter(user2Time)){
        return true;
      }
      else if(user1Time.isAtSameMomentAs(user2Time)){
        return false;
      }
    }
    else{
      return false;
    }
  }
}
