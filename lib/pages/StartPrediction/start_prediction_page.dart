
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/common/connectivity_checker.dart';
import 'package:prediction/common/language_controller.dart';
import 'package:prediction/controller/home_controller.dart';
import 'package:prediction/controller/start_prediction_controller.dart';
import 'package:prediction/model/prediction_post_model.dart';
import 'package:prediction/model/start_prediction.dart';
import 'package:prediction/package/smart_refresher/smart_refresher.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/ad_controller/ads_controller.dart';
import '../../controller/rank_controller.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../package/slider/carousel_slider.dart';
import '../../util/constant.dart';
import '../../util/expandable_pageview.dart';
import '../../widget/empty_failure_no_internet_view.dart';
import '../login/login_page.dart';

class StartPredictionPage extends StatefulWidget {
  final String leagueId;
  final String seasonId;
  final bool isSubscribed;
  const StartPredictionPage({Key? key,required this.leagueId,required this.seasonId,required this.isSubscribed}) : super(key: key);

  @override
  State<StartPredictionPage> createState() => _StartPredictionPageState();
}

class _StartPredictionPageState extends State<StartPredictionPage> {
  final langController=Get.put(LanguageController());
  final adsController=Get.put(AdsController());
  final controller=Get.put(StartPredictionController());
  final internetController=Get.put(ConnectivityCheckerController());
  var homeController= Get.put(HomeController());
  final rankController = Get.put(RankController());
  String isGuestMode= "";
  bool subscribe=false;
  void detectGuestMode() async{
    final prefs = await SharedPreferences.getInstance();
    isGuestMode= prefs.getString("guestMode").toString();
    setState(() {
      subscribe=widget.isSubscribed;
    });
  }
  @override
  void initState(){
    super.initState();
    detectGuestMode();
    controller.list.clear();
    controller.roundList.clear();
    controller.mainList.clear();
    controller.mainFocusList.clear();
    controller.page.value=1;
    controller.pageCount.value=1;
    langController.getLang();
    internetController.startMonitoring();
    controller.loadRound(widget.leagueId, widget.seasonId);

  }
  @override
  void dispose(){
    super.dispose();
    Get.delete<StartPredictionController>();
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(onPressed: (){Navigator.of(context).pop();},
            icon: const Icon(Icons.arrow_back,color: primaryColor),
          ),
          title: Text("apptitle".tr,
            style: toolbarTitleStyle,),
          centerTitle: true,
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.notifications,
            //     color: primaryColor,
            //   ),
            // ),
          ],
        ),
        body: Column(
          children: [

            Expanded(
              child: Obx((){
                if(controller.loading1.value==true){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
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
                        controller.getData(true,widget.leagueId,widget.seasonId,controller.initRoundId.value.toString(),controller.page.value.toString(),true);
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
                        controller.getData(true,widget.leagueId,widget.seasonId,controller.initRoundId.value.toString(),controller.page.value.toString(),true);
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
                        controller.getData(true,widget.leagueId,widget.seasonId,controller.initRoundId.value.toString(),controller.page.value.toString(),true);
                      },
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
                        controller.getData(true,widget.leagueId,widget.seasonId,controller.initRoundId.value.toString(),controller.page.value.toString(),true);
                      },
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
                        controller.getData(true,widget.leagueId,widget.seasonId,controller.initRoundId.value.toString(),controller.page.value.toString(),true);
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
                            controller.getData(true,widget.leagueId,widget.seasonId,controller.initRoundId.value.toString(),controller.page.value.toString(),true);
                          },
                          status: 0,
                        ),
                      );
                    }
                else{
                  return SmartRefresher(
                    controller: controller.refreshController,
                    enablePullUp: true,
                    enablePullDown: true,
                    onLoading: (){
                      controller.getData(false,widget.leagueId,widget.seasonId,controller.initRoundId.value.toString(),controller.page.value.toString(),false);
                    },
                    onRefresh: (){
                      // controller.page.value=1;
                      // controller.pageCount.value=1;
                      // controller.refreshController.resetNoData();
                      controller.refreshController.refreshToIdle();
                      // controller.getData(false,widget.leagueId,"1","1","1",true);
                    },
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Obx(() => Visibility(
                          visible: controller.showAlart.value==false?true:false ,
                          child: Column(
                            children: [
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
                              SizedBox(
                                height:100,
                                child: ScrollablePositionedList.builder(
                                    itemCount: controller.roundList.length,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.only(top: 7),
                                    itemScrollController:controller.itemScrollController,
                                    itemBuilder: (con,i){

                                      return Obx(() => GestureDetector(
                                        onTap: () {
                                          if(controller.roundList[i].enabled==true){
                                            controller.list.clear();
                                            controller.showAlart.value=false;
                                            controller.index.value= i;
                                            controller.pageCount.value=1;
                                            controller.page.value=1;
                                            controller.refreshController.resetNoData();
                                            controller.initRoundId.value=controller.roundList[i].id!;
                                            controller.timeLineStatus.value=controller.calculateTimeDifferenceBetween(startDate1: controller.roundList[i].startedAt!, DbEndDate1: controller.roundList[i].endedAt!);
                                            controller.getData(true,widget.leagueId,widget.seasonId,controller.initRoundId.value.toString(),controller.page.value.toString(),true);

                                          }else{

                                            controller.index.value= i;
                                            controller.initRoundId.value=controller.roundList[i].id!;
                                            controller.showAlart.value=true;
                                          }

                                        },
                                        child: controller.index.value == i ? Container(
                                          margin: const EdgeInsets.only(right: 3),
                                          height: 74,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                            color: primaryColor,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Round",
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                controller.roundList[i].name!,
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                controller.roundList[i].startedAt!=null?"${getDateOfRounnd(controller.roundList[i].startedAt,controller.roundList[i].endedAt)}":"Time Empty",
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ) :

                                        Container(
                                          margin: const EdgeInsets.only(right: 3),
                                          height: 57,
                                          width: 84,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                            color: Color(0xFFF4F4F4),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                controller.roundList[i].name!,
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Color(0xFF999999),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 5,),
                                              Text(
                                                controller.roundList[i].startedAt!=null?"${getDateOfRounnd(controller.roundList[i].startedAt,controller.roundList[i].endedAt)}":"Start Time Empty",
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Color(0xFF999999),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 8,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),


                                      ));
                                    }
                                ),
                              ),
                              const SizedBox(height: 5),

                              Center(child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("YOU EARNED",style: const TextStyle(color: Color(0xFF000000),fontSize: 14,fontWeight: FontWeight.w600)),
                                  SizedBox(width: 10,),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: primaryColor
                                      ),
                                      child: Row(
                                        children: [
                                          Text(controller.list.isNotEmpty&&controller.list[0].round!.points!=null?controller.list[0].round!.points.toString():0.toString(),style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600)),
                                          Text(" Points",style: const TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w600)),
                                        ],
                                      )),
                                ],
                              ),),
                              SizedBox(height: 5,),
                              Center(child: Obx(() => Text(controller.timeLineStatusTitle.value,style: const TextStyle(color: Color(0xFF000000),fontSize: 14,fontWeight: FontWeight.w600)),),),
                              Center(child: Text(controller.timeLineStatus.value,style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontSize: 18,fontWeight: FontWeight.w600)),)),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                itemCount: controller.list.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var uniqueIdentity1="${controller.list[index].id}${controller.list[index].teams![0].id}";
                                  var uniqueIdentity2="${controller.list[index].id}${controller.list[index].teams![1].id}";
                                  DateTime parsedDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(controller.list[index].timestamp!).toLocal();
                                  var difference=parsedDateFormat.difference(DateTime.now()).inHours;
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom: 18),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF000000).withOpacity(0.08),
                                          offset: const Offset(0, 1),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${controller.list[index].longStatus}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 13)),),
                                            controller.list[index].shortStatus=="FT"?Text(getPointCalculation(controller.list[index].prediction),style: TextStyle(fontSize: 16),):SizedBox(
                                              width: 120,
                                              height: 30,
                                              child: RadioListTile(
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                                value: controller.mainRadioList[controller.list[index].id.toString()].toString(),
                                                groupValue: controller.radioValue.value, onChanged: difference>=1?(val){
                                                  for(var item in controller.list){
                                                    if(item.prediction!=null&&item.prediction!.multiplyByTwo==1){
                                                      showToast("You have already enabled it for this round.");
                                                      return;
                                                    }
                                                  }
                                                  setState((){
                                                    controller.radioValue.value=val as String;
                                                  });

                                              }:null,title: Text("X2 Pts",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFBEBEBE),fontWeight: FontWeight.w400,fontSize: 13)),),),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                        Row(
                                          children: [

                                            Expanded(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("${controller.list[index].teams![0].code!}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF424242),fontWeight: FontWeight.w500,fontSize: 12)),),
                                                      //Text("Team 2"),
                                                      Text("2ND",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF424242),fontWeight: FontWeight.w500,fontSize: 12)),)
                                                    ],
                                                  ),
                                                  const SizedBox(width: 9,),
                                                  Image.network('${controller.list[index].teams![0].logo}',height: 18,width: 18,)
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            controller.list[index].teams![0].goals!=null&&controller.list[index].prediction==null?Text("NA",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),):SizedBox(
                                              width: 40,
                                              child: TextFormField(
                                                enabled: difference>=1?true:false,
                                                focusNode: controller.mainFocusList[uniqueIdentity1],
                                                controller: controller.mainList[uniqueIdentity1],
                                                keyboardType: TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.digitsOnly,
                                                  LengthLimitingTextInputFormatter(1),
                                                ],
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: difference>=1?Color(0xFFF4F4F4):Colors.red,
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 2)
                                                ),


                                                onChanged: (val){
                                                  var val2=controller.mainList[uniqueIdentity2].text;
                                                  if(val2.toString().isEmpty){
                                                    if(controller.changeable.value){
                                                      controller.startTeamName.value=controller.list[index].teams![0].name!;
                                                      controller.changeable.value=false;
                                                    }
                                                    controller.mainFocusList[uniqueIdentity2].requestFocus();
                                                  }else{
                                                    if(controller.changeable.value){
                                                      controller.startTeamName.value=controller.list[index].teams![0].name!;
                                                      controller.changeable.value=false;
                                                    }


                                                    for(var i=0;i<controller.list.length;i++){
                                                      for(var j=0;j<controller.list[i].teams!.length;j++){
                                                        var uniqueIdentity11="${controller.list[i].id}${controller.list[i].teams![0].id}";
                                                        var uniqueIdentity22="${controller.list[i].id}${controller.list[i].teams![1].id}";
                                                        var val1=controller.mainList[uniqueIdentity11].text;
                                                        var val2=controller.mainList[uniqueIdentity22].text;

                                                        var name1=controller.list[i].teams![0].name;
                                                        var name2=controller.list[i].teams![1].name;

                                                        if(controller.startTeamName.value==name1&&val1.toString().isEmpty){
                                                          controller.mainFocusList[uniqueIdentity11].requestFocus();
                                                          return;
                                                        }
                                                        if(controller.startTeamName.value==name2&&val2.toString().isEmpty){
                                                          controller.mainFocusList[uniqueIdentity22].requestFocus();
                                                          return;
                                                        }

                                                      }
                                                    }

                                                    controller.startTeamName.value="";
                                                    controller.changeable.value=true;
                                                    FocusScope.of(context).requestFocus(FocusNode());
                                                  }

                                                },
                                                onTap: (){
                                                  if(isGuestMode == "1"){
                                                    guestDialog();
                                                  }
                                                },

                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Obx(() => Text(langController.vs.value.toString(),style: const TextStyle(color: Color(0xFF000000),fontWeight: FontWeight.w500,fontSize: 14)),),
                                            const SizedBox(width: 12),
                                            controller.list[index].teams![1].goals!=null&&controller.list[index].prediction==null?Text("NA",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),):SizedBox(
                                              width: 40,
                                              child: TextFormField(
                                                enabled: difference>=1?true:false,
                                                focusNode: controller.mainFocusList[uniqueIdentity2],
                                                controller: controller.mainList[uniqueIdentity2],
                                                keyboardType: TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.digitsOnly,
                                                  LengthLimitingTextInputFormatter(1),
                                                ],
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: difference>=1?Color(0xFFF4F4F4):Colors.red,
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),

                                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 3)
                                                ),
                                                onChanged: (val){

                                                  var val1=controller.mainList[uniqueIdentity1].text;
                                                  if(val1.toString().isEmpty){
                                                    if(controller.changeable.value){
                                                      controller.startTeamName.value=controller.list[index].teams![1].name!;
                                                      controller.changeable.value=false;
                                                    }
                                                    controller.mainFocusList[uniqueIdentity1].requestFocus();
                                                  }else{
                                                    if(controller.changeable.value){
                                                      controller.startTeamName.value=controller.list[index].teams![1].name!;
                                                      controller.changeable.value=false;
                                                    }

                                                    for(var i=0;i<controller.list.length;i++){
                                                      for(var j=0;j<controller.list[i].teams!.length;j++){
                                                        var uniqueIdentity11="${controller.list[i].id}${controller.list[i].teams![0].id}";
                                                        var uniqueIdentity22="${controller.list[i].id}${controller.list[i].teams![1].id}";
                                                        var val1=controller.mainList[uniqueIdentity11].text;
                                                        var val2=controller.mainList[uniqueIdentity22].text;
                                                        var name1=controller.list[i].teams![0].name;
                                                        var name2=controller.list[i].teams![1].name;

                                                        if(controller.startTeamName.value==name1&&val1.toString().isEmpty){
                                                          controller.mainFocusList[uniqueIdentity11].requestFocus();
                                                          return;
                                                        }
                                                        if(controller.startTeamName.value==name2&&val2.toString().isEmpty){
                                                          controller.mainFocusList[uniqueIdentity22].requestFocus();
                                                          return;
                                                        }

                                                      }
                                                    }

                                                    controller.startTeamName.value="";
                                                    controller.changeable.value=true;
                                                     FocusScope.of(context).requestFocus(FocusNode());
                                                  }





                                                },
                                                onTap: (){
                                                  if(isGuestMode == "1"){
                                                    guestDialog();
                                                  }
                                                },
                                              ),

                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Row(

                                                children: [
                                                  Image.network('${controller.list[index].teams![1].logo}',height: 18,width: 18,),
                                                  const SizedBox(width: 9),
                                                  Column(
                                                    children: [
                                                     Text("${controller.list[index].teams![1].code!}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF424242),fontWeight: FontWeight.w500,fontSize: 12)),),
                                                     // const Text("Team 1"),
                                                      Text("1 ST",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF424242),fontWeight: FontWeight.w500,fontSize: 12)),)

                                                    ],
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                  ),
                                                ],
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        controller.list[index].teams![0].goals!=null?Row(
                                          children: [

                                            Expanded(
                                              child: Row(
                                                children: [],
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            SizedBox(
                                              width: 40,
                                              child: Text("${controller.list[index].teams![0].goals}",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
                                            ),
                                            const SizedBox(width: 12),
                                            Text("VS",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 14)),
                                            const SizedBox(width: 12),
                                            SizedBox(
                                              width: 40,
                                              child: Text("${controller.list[index].teams![1].goals}",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Row(
                                                children: [

                                                ],
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                              ),
                                            ),
                                          ],
                                        ):SizedBox(),
                                        controller.list[index].comparison==null?SizedBox():SizedBox(height: 10,),

                                        controller.list[index].comparison==null?SizedBox():Center(child: Text("${getPeopleComment(controller.list[index].comparison,controller.list[index].teams)}",style: const TextStyle(color: Color(0xFF828282),fontSize: 16,fontWeight: FontWeight.w500))),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                          Expanded(
                                            child: Container(
                                                height:41,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(langController.arabic.value?0:20),
                                                    topRight: Radius.circular(langController.arabic.value?20:0),
                                                    bottomLeft: Radius.circular(langController.arabic.value?0:20),
                                                    bottomRight: Radius.circular(langController.arabic.value?20:0,),
                                                  ),
                                                  color: primaryColor,
                                                ),
                                                child: Center(child: Text(controller.list[index].comparison==null?"0%":"${controller.list[index].comparison!.win!.home!.round()}%",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFFFFFFF),fontSize: 13,fontWeight: FontWeight.w600)),)),
                                              ),
                                          ),
                                            Expanded(
                                              child: Container(
                                                height:41,
                                                color: const Color(0xFFC3D6DA),
                                                child: Center(child: Text("${calculateWidthForTie(controller.list[index].comparison)}%",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFFFFFFF),fontSize: 13,fontWeight: FontWeight.w600)),)),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height:41,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(langController.arabic.value?20:0),
                                                    topRight: Radius.circular(langController.arabic.value?0:20),
                                                    bottomLeft: Radius.circular(langController.arabic.value?20:0),
                                                    bottomRight: Radius.circular(langController.arabic.value?0:20,),
                                                  ),
                                                  color: const Color(0xFF1A1819),
                                                ),
                                                child: Center(child: Text(controller.list[index].comparison==null?"0%":"${controller.list[index].comparison!.win!.away!.round()}%",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFFFFFFF),fontSize: 13,fontWeight: FontWeight.w600)),)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 14),
                                        Container(
                                          height: 32,
                                          width: MediaQuery.of(context).size.width*0.90,
                                          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(16),
                                              topLeft: Radius.circular(16),
                                            ),
                                            color: Color(0xFFF4F4F4),
                                          ),
                                          child: difference<=30?Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                " Session ${getSeason(controller.list[index].season!.year!)}",
                                                //" Session",
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Color(0xFF535353),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Round ${controller.list[index].round!.name}",
                                                //"Round ",
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Color(0xFF535353),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ):Text(
                                            "${getMatchDate(controller.list[index].timestamp!)}",
                                            //"Round ",
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Color(0xFF535353),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                              ),

                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),

                            ],
                          ),
                        ),),

                        Obx(() => Visibility(
                          visible: controller.showAlart.value==true?true:false,
                          child: Container(
                            height: 200,
                            margin: const EdgeInsets.only(top: 50, left: 50, right: 50),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Image.asset(
                                  "assets/images/alart.png",
                                  height: 50,
                                  width: 50,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Data still not available",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Please check back later",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),),

                      ],
                    ),
                  );
                }
              }),
            ),
            /// submit button
            Visibility(
              visible: controller.showAlart.isFalse,
              child: InkWell(
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: primaryColor,
                  ),
                  alignment: Alignment.center,
                  child: Obx(() => Text(
                    langController.submit_prediction.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),),
                ),
                onTap: (){
                  if(controller.list.isEmpty){
                    showToast("No team found!");
                    return;
                  }
                  if(controller.timeLineStatusTitle.value=="Round Ended"){
                    showToast("You can't predict. Round Ended! ");
                    return;
                  }
                  if(isGuestMode == "1"){
                    guestDialog();
                    return;
                  }
                  if(subscribe==false){
                    subscribeLeagueDialog();
                    return;
                  }
                  predictionSubmitDialog();
                },
              ),
            ),
          ],
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
                  Obx(() => Text(
                    langController.alart.value,
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
                    langController.login_first.value,
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
                            Get.delete<HomeController>();
                            Navigator.of(context, rootNavigator: true).pushReplacement(PageTransition(child: LoginPage(id: '',), type: PageTransitionType.rightToLeft));
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
  subscribeLeagueDialog() {
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
                  Obx(
                        () => Text(
                          langController.subscribe.value.toString(),
                      style: toolbarTitleStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                        () => Text(
                            langController.subscribebody.value.toString(),
                        style: const TextStyle(
                            color: commonTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 13)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
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
                              backgroundColor:
                              MaterialStateProperty.all(commonTextColor)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(
                                  () => Text(
                                      langController.cancel.value.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            showLoaderDialog(context, langController.wait.value);
                            var response = await sendSubcrptionRequest(
                                widget.leagueId.toString(),
                                widget.seasonId);
                            Navigator.of(context, rootNavigator: true).pop();
                            if (response.statusCode == 200) {

                              homeController.getData(false);
                              rankController.getData(false);
                              Navigator.of(context, rootNavigator: true).pop();
                              predictionSubmitDialog();

                            } else {
                              Navigator.of(context, rootNavigator: true).pop();
                              showToast(
                                  langController.subscription_failed.value);
                            }
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(
                                  () => Text(
                                      langController.yes.value.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
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
  /// submit dialog
  predictionSubmitDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Text(
                    langController.submit_prediction.value.toString(),
                    style: toolbarTitleStyle,
                  ),),
                  const SizedBox(height: 10),
                  const Text(
                    "Are you sure? want\nto submit your prediction",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: commonTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      InkWell(
                        child: Container(
                          height: 40,
                          width: 90,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: commonTextColor,
                          ),
                          alignment: Alignment.center,
                          child: Obx(() => Text(
                            langController.cancel.value.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),),
                        ),
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                      ),

                      InkWell(
                        child: Container(
                          height: 40,
                          width: 90,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: primaryColor,
                          ),
                          alignment: Alignment.center,
                          child: Obx(() => Text(
                            langController.yes.value.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),),
                        ),
                        onTap: ()async{

                          var postData=<PredictionPostModel>[];
                          var selectedRadio="";
                          for(var i=0;i<controller.list.length;i++){
                            for(var j=0;j<controller.list[i].teams!.length;j++){
                              var uniqueIdentity1="${controller.list[i].id}${controller.list[i].teams![0].id}";
                              var uniqueIdentity2="${controller.list[i].id}${controller.list[i].teams![1].id}";
                              var val1=controller.mainList[uniqueIdentity1].text;
                              var val2=controller.mainList[uniqueIdentity2].text;
                              if(val1.toString().isNotEmpty&&val2.toString().isEmpty){
                                showToast("Please enter team ${controller.list[i].teams![1].name} prediction");
                                controller.mainFocusList[uniqueIdentity2].requestFocus();
                                Navigator.of(context).pop();
                                return;
                              }
                              if(val1.toString().isEmpty&&val2.toString().isNotEmpty){
                                showToast("Please enter team ${controller.list[i].teams![0].name} prediction");
                                controller.mainFocusList[uniqueIdentity1].requestFocus();
                                Navigator.of(context).pop();
                                return;
                              }
                              if(val1.toString().isNotEmpty&&val2.toString().isNotEmpty){
                                if(controller.radioValue.value=="${controller.list[i].id}"){
                                  if(controller.list[i].prediction==null||controller.list[i].prediction!.multiplyByTwo==0){
                                    selectedRadio=controller.radioValue.value;
                                  }else{
                                    selectedRadio="";
                                  }

                                }
                                PredictionPostModel model1=PredictionPostModel(controller.list[i].id.toString(), controller.list[i].teams![0].ground, val1);
                                PredictionPostModel model2=PredictionPostModel(controller.list[i].id.toString(), controller.list[i].teams![1].ground, val2);
                                postData.add(model1);postData.add(model2);
                              }
                            }
                          }

                          showLoaderDialog(context, "Please wait...");
                          var response=await sendPredictionRequest(postData,selectedRadio);
                          Navigator.of(context).pop();

                          if(response.statusCode==200){
                            showToast("Prediction Submitted Successfully");
                            Navigator.of(context).pop();
                          }else{
                            var data=jsonDecode(response.body);
                            var message=data['message'];
                            showToast(message);
                            Navigator.of(context).pop();
                          }
                        },
                      ),

                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }


  calculateWidthForTeam1(Win? win) {
    var width=0.0;
    if(win!.home!=0){
      width=(win.home!/100);
    }else{
      width=0.0;
    }
    return width;
  }
  calculateWidthForTie(Comparison? comparison) {
    if(comparison==null){
      return 0;
    }
    if(comparison.win!.home==0&&comparison.win!.away==0){
      return 0;
    }else{
      var sum=(comparison.win!.home!+comparison.win!.away!).round();
      return (sum-100).abs();
    }


  }
  calculateWidthForTeam2(Win? win) {
    var size=MediaQuery.of(context).size.width;
    var width=0.0;
    if(win!.away!=0){
      width=size*(win.away!/100)-60;
    }else{
      width=0.0;
    }
    return width;
  }
  getSeason(String? year) {
    var preYear=year!.replaceAll("20","");
    var postYear=int.parse(preYear)+1;
    return "$preYear/$postYear";
  }

  calculateMaxPercentage(Win? win) {
    var sum=win!.home!+win.away!;
    var sub=100-sum;
    var M = [win.home!, win.away!,sub].reduce(max);
    return M.round();
  }

  getDateOfRounnd(String? startedAt, String? endedAt) {
    DateTime parsedDateFormat1 = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(startedAt!).toLocal();
    DateTime parsedDateFormat2 = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(endedAt!).toLocal();

    return "${parsedDateFormat1.day}/${parsedDateFormat1.month}-${parsedDateFormat2.day}/${parsedDateFormat2.month}";
  }

  getPeopleComment(Comparison? comparison, List<Teams>? teams) {
    var message="";
    var homeTeamPercentage=comparison!.win!.home!.round();
    var homeTeamName=teams![0].name;
    var awayTeamPercentage=comparison.win!.away!.round();
    var awayTeamName=teams[1].name;
    var sum=(homeTeamPercentage+awayTeamPercentage).round();
    var tiePercentage= (sum==0)?0:(sum-100).abs();
    var largest=[homeTeamPercentage,awayTeamPercentage,tiePercentage].reduce(max);

    if(largest==homeTeamPercentage){
      message="$largest% of players are expecting $homeTeamName to win";
    }
    else if(largest==awayTeamPercentage){
      message="$largest% of players are expecting $awayTeamName to win";
    }else{
      message="$largest% of players are expecting to tie";
    }
    return message;


  }

  String getPointCalculation(Prediction? prediction) {
    if(prediction==null){
      return "+0 Point";
    }else{
      if(prediction.multiplyByTwo==0){
        return "+${prediction.points} Points";
      }
      else if(prediction.multiplyByTwo==1){
        return "+${prediction.points} Points";
      }
    }
    return "+0 Points";
  }





}
