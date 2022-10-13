


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/common/connectivity_checker.dart';
import 'package:prediction/common/language_controller.dart';
import 'package:prediction/controller/private_cup_controller.dart';
import 'package:prediction/controller/private_league_controller.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/pages/cup/create_cup_page.dart';
import 'package:prediction/pages/cup/cup_detail_page.dart';
import 'package:prediction/pages/leaque/create_league_page.dart';
import 'package:prediction/pages/search/search_page.dart';
import 'dart:math' as math;
import '../../controller/ad_controller/ads_controller.dart';
import '../../model/fab_menu.dart';
import '../../package/page_transition/enum.dart';
import '../../package/slider/carousel_slider.dart';
import '../../util/constant.dart';
import '../../util/expandable_pageview.dart';
import '../../widget/empty_failure_no_internet_view.dart';
import '../login/login_page.dart';
import '../notification/notification_page.dart';
import 'league_detail_page.dart';

class LeaguePage extends StatefulWidget {
  @override
  State<LeaguePage> createState() => _LeaguePageState();
}

class _LeaguePageState extends State<LeaguePage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final langController=Get.put(LanguageController());
  final adsController=Get.put(AdsController());
  final controller=Get.put(PrivateLeagueController());
  final cupcontroller=Get.put(PrivateCupController());
  final netController=Get.put(ConnectivityCheckerController());
  int userId=0;
  List<MenuData> menuDataList=[];
  getUserId()async{
    userId=await getIntPrefs(USER);
    setState((){});
  }

  @override
  void initState(){
    super.initState();
    getUserId();
    tabController=TabController(length: 2, vsync: this);
    langController.getLang();
    langController.detectGuestMode();
    netController.startMonitoring();
    controller.getData(true);
    cupcontroller.getData(true);
    menuDataList = [
       MenuData("assets/images/join.png", (context, menuData) {
         Navigator.of(context, rootNavigator: true).push(PageTransition(child: SearchPage(), type: PageTransitionType.rightToLeft));
      },labelText: 'Join another’s private leagues/cups'),
       MenuData("assets/images/create_cup.png", (context, menuData) {
       Navigator.of(context,rootNavigator: true).push(PageTransition(child: CreateCupPage(), type: PageTransitionType.rightToLeft));
      },labelText: 'Create cup'),
      MenuData("assets/images/create_league.png", (context, menuData) {
        Navigator.of(context,rootNavigator: true).push(PageTransition(child: CreateLeaguePage(), type: PageTransitionType.rightToLeft));
      },labelText: 'Create special league'),
      MenuData("assets/images/close_icon.png", (context, menuData) {

      },labelText: 'Cancel')
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FabMenu(
        menus: menuDataList,
        maskColor: Colors.black,
        mainButtonBackgroundColor: Colors.black,
        menuButtonColor: Colors.black,
        menuButtonBackgroundColor: Colors.black,
        labelTextColor: Colors.white,
        mainButtonColor: Colors.black,
        labelBackgroundColor: Colors.black,
        mainIcon: Icons.add,
      ),
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
      body: Column(
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


          Container(
            height: 47,
            decoration: BoxDecoration(
              color: Color(0xFFF4F4F4)
            ),
            child: TabBar(
              controller: tabController,
              indicatorColor: primaryColor,
              unselectedLabelColor: const Color(0xFF1A1819),
              labelColor: primaryColor,
              unselectedLabelStyle: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Color(0xFF1A1819))),
              labelStyle: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: primaryColor)),
              tabs: const [
                Tab(text:"Leagues",height: 35,),
                Tab(text:"Cups",height: 35,),

              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                RefreshIndicator(
                  onRefresh: ()async{
                    controller.getData(false);
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      //ExpandablePageView(children:adsController.adsWidgetList),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          children: [
                            const SizedBox(height: 26,),
                            GestureDetector(
                              onTap: (){
                                if(langController.isGuestMode.value == "1"){
                                  guestDialog();
                                } else {
                                  Navigator.of(context, rootNavigator: true).push(PageTransition(child: SearchPage(), type: PageTransitionType.rightToLeft));
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 22),
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Color(0xFFE7E7E7)),
                                    color: Color(0xFFFAFAFA)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => Text(langController.search.value.toString(), style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xFFAAAAAA))),),
                                    SvgPicture.asset("assets/images/search.svg")
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 27,),
                            Obx(() {
                              if(controller.loading.value==true){
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Center(child: CircularProgressIndicator()),
                                    Center(child: Text("Please wait..."),)
                                  ],
                                );
                              }
                              else if (langController.isGuestMode.value == "1"){
                                return Center(
                                  child: EmptyFailureNoInternetView(
                                    image: 'assets/lottie/login.json',
                                    title: langController.alart.value,
                                    description: langController.login_first.value,
                                    buttonText: "Log In",
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pushReplacement(PageTransition(child: LoginPage(id: '',), type: PageTransitionType.rightToLeft));
                                    },
                                    status: 1,
                                  ),
                                );
                              }
                              else if (netController.isOnline.value == false) {
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
                              }
                              else if (controller.internetError.value == true) {
                                return Center(
                                  child: EmptyFailureNoInternetView(
                                    image: 'assets/lottie/no_internet_lottie.json',
                                    title: 'Internet Error',
                                    description: 'Internet not found',
                                    buttonText: "Retry",
                                    onPressed: () {
                                      controller.getData(true); },
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
                                      controller.getData(true);  },
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
                                      controller.getData(true); },
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
                                      controller.getData(true); },
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
                              }
                              else{
                                return ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: controller.list.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context,index){
                                      return InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 18),
                                          child: Stack(
                                            children: [
                                              controller.list[index].user!.id==userId?Container(
                                                height: 40,
                                                width: 102,
                                                padding: EdgeInsets.only(bottom: 10),
                                                decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(11),topRight: Radius.circular(11)),
                                                    color: primaryColor
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Obx(() => Text(langController.owner.value.toString(), style:TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 11)),),
                                                  ],
                                                ),
                                              ):SizedBox(),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Color(0xFFFAFAFA),
                                                    border: Border.all(color: Color(0xFFE7E7E7))
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                                                margin: EdgeInsets.only(top:  controller.list[index].user!.id==userId?30:0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 32,
                                                            width: 60,

                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),

                                                            ),
                                                            child: Image.network("${controller.list[index].league!.logo}"),
                                                            padding: EdgeInsets.all(5),
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("${controller.list[index].league!.name}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF404040),fontWeight: FontWeight.w600,fontSize: 13)),),
                                                                Text(controller.list[index].currentRound==null?"":"Round ${controller.list[index].currentRound!.name}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 11)),),
                                                                SizedBox(height: 12,),
                                                                controller.list[index].winner!=null?Text("@${controller.list[index].winner!.username}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 11)),)
                                                                    :Text("Play for ${controller.list[index].playFor}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 11)),)
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    controller.list[index].winner!=null&&userId==controller.list[index].winner!.id?Container(

                                                      padding: EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: Color(0xFFFFB001)
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Obx(() => Text(langController.winner.value.toString(), style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 12)),),),
                                                          SizedBox(width: 15,),
                                                          SvgPicture.asset("assets/images/league_icon.svg",color: Colors.white,height: 10,width: 10,)
                                                        ],
                                                      ),
                                                    ):Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: Colors.white
                                                      ),
                                                      padding:EdgeInsets.all(8),
                                                      child: Row(
                                                        children: [
                                                          Image.asset("assets/images/ball.png",height: 20,width: 20,),
                                                          SizedBox(width: 15,),
                                                          Text("${controller.list[index].rank_among_others}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 13)),)
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],

                                          ),
                                        ),
                                        onTap: (){
                                          if(langController.isGuestMode.value == "1"){
                                            guestDialog();
                                          }else{
                                            Navigator.of(context,rootNavigator: true).push(PageTransition(child: LeagueDetailPage( privateLeague: controller.list[index],), type: PageTransitionType.rightToLeft));

                                          }
                                        },
                                      );
                                    });
                              }
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                RefreshIndicator(
                  onRefresh: ()async{
                    cupcontroller.getData(false);
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    primary: true,
                    children: [
                     // ExpandablePageView(children:adsController.adsWidgetList),
                      const SizedBox(height: 26,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 27),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                if(langController.isGuestMode.value == "1"){
                                  guestDialog();
                                } else {
                                  Navigator.of(context, rootNavigator: true).push(PageTransition(child: SearchPage(), type: PageTransitionType.rightToLeft));
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 22),
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Color(0xFFE7E7E7)),
                                    color: Color(0xFFFAFAFA)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() => Text(langController.search.value.toString(), style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color(0xFFAAAAAA))),),
                                    SvgPicture.asset("assets/images/search.svg")
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 27,),
                            Obx(() {
                              if(cupcontroller.loading.value==true){
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Center(child: CircularProgressIndicator()),
                                    Center(child: Text("Please wait..."),)
                                  ],
                                );
                              }
                              else if (langController.isGuestMode.value == "1"){
                                return Center(
                                  child: EmptyFailureNoInternetView(
                                    image: 'assets/lottie/login.json',
                                    title: langController.alart.value,
                                    description: langController.login_first.value,
                                    buttonText: "Log In",
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pushReplacement(PageTransition(child: LoginPage(id: '',), type: PageTransitionType.rightToLeft));
                                    },
                                    status: 1,
                                  ),
                                );
                              }
                              else if (netController.isOnline.value == false) {
                                return Center(
                                  child: EmptyFailureNoInternetView(
                                    image: 'assets/lottie/no_internet_lottie.json',
                                    title: 'Internet Error',
                                    description: 'Internet not found',
                                    buttonText: "Retry",
                                    onPressed: () {
                                      cupcontroller.getData(true);
                                    },
                                    status: 1,
                                  ),
                                );
                              }
                              else if (cupcontroller.internetError.value == true) {
                                return Center(
                                  child: EmptyFailureNoInternetView(
                                    image: 'assets/lottie/no_internet_lottie.json',
                                    title: 'Internet Error',
                                    description: 'Internet not found',
                                    buttonText: "Retry",
                                    onPressed: () {
                                      cupcontroller.getData(true); },
                                    status: 1,
                                  ),
                                );
                              }
                              else if (cupcontroller.serverError.value == true) {
                                return Center(
                                  child: EmptyFailureNoInternetView(
                                    image: 'assets/lottie/failure_lottie.json',
                                    title: 'Server error'.tr,
                                    description: 'Please try again later',
                                    buttonText: "Retry",
                                    onPressed: () {
                                      cupcontroller.getData(true);  },
                                    status: 1,
                                  ),
                                );
                              }
                              else if (cupcontroller.somethingWrong.value == true) {
                                return Center(
                                  child: EmptyFailureNoInternetView(
                                    image: 'assets/lottie/failure_lottie.json',
                                    title: 'Something went wrong',
                                    description: 'Please try again later',
                                    buttonText: "Retry",
                                    onPressed: () {
                                      cupcontroller.getData(true); },
                                    status: 1,
                                  ),
                                );
                              }
                              else  if(cupcontroller.timeoutError.value==true){
                                return Center(
                                  child: EmptyFailureNoInternetView(
                                    image: 'assets/lottie/failure_lottie.json',
                                    title: 'Timeout',
                                    description: 'Please try again',
                                    buttonText: "Retry",
                                    onPressed: () {
                                      cupcontroller.getData(true); },
                                    status: 1,
                                  ),
                                );
                              }
                              else  if(cupcontroller.loading.value==false&&cupcontroller.list.isEmpty){
                                return Center(
                                  child: EmptyFailureNoInternetView(
                                    image: 'assets/lottie/empty_lottie.json',
                                    title: 'No Data',
                                    description: 'No data found',
                                    buttonText: "Retry",
                                    onPressed: () {
                                      cupcontroller.getData(true); },
                                    status: 0,
                                  ),
                                );
                              }
                              else{
                                return ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: cupcontroller.list.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context,index){
                                      return InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 18),
                                          child: Stack(
                                            children: [
                                              cupcontroller.list[index].user!.id==userId?Container(
                                                height: 40,
                                                width: 102,
                                                padding: EdgeInsets.only(bottom: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(11),topRight: Radius.circular(11)),
                                                    color: primaryColor
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Obx(() => Text(langController.owner.value.toString(), style:TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 11)),),
                                                  ],
                                                ),
                                              ):SizedBox(),
                                              cupcontroller.list[index].out==true?Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  height: 40,
                                                  width: 102,
                                                  padding: EdgeInsets.only(bottom: 10),
                                                  decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(11),topRight: Radius.circular(11)),
                                                      color: Colors.red
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("out".tr, style:TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 11)),
                                                    ],
                                                  ),
                                                ),
                                              ):SizedBox(),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Color(0xFFFAFAFA),
                                                    border: Border.all(color: Color(0xFFE7E7E7))
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                                                margin: EdgeInsets.only(top:  cupcontroller.list[index].user!.id==userId||cupcontroller.list[index].out==true?30:0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 32,
                                                            width: 60,

                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),

                                                            ),
                                                            child: Image.network("${cupcontroller.list[index].league!.logo}"),
                                                            padding: EdgeInsets.all(5),
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("${cupcontroller.list[index].title}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF404040),fontWeight: FontWeight.w600,fontSize: 13)),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                                                Text(cupcontroller.list[index].currentRound==null?"":"Round ${cupcontroller.list[index].currentRound!.name??"Round 1"}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 11)),),
                                                                SizedBox(height: 12,),
                                                                Text(cupcontroller.list[index].winner==null?"${cupcontroller.list[index].status}":"@${cupcontroller.list[index].winner!.username}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 11)),),


                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    cupcontroller.list[index].winner!=null&&userId==cupcontroller.list[index].winner!.id?Container(
                                                      width:100,
                                                      padding: EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: Color(0xFFFFB001)
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Obx(() => Text(langController.winner.value.toString(), style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 12)),),),
                                                          SizedBox(width: 15,),
                                                          SvgPicture.asset("assets/images/league_icon.svg",color: Colors.white,height: 10,width: 10,)
                                                        ],
                                                      ),
                                                    ):Container(
                                                      width:100,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: Colors.white
                                                      ),
                                                      padding:EdgeInsets.all(8),
                                                      child: Row(
                                                        children: [
                                                          Image.asset("assets/images/ball.png",height: 20,width: 20,),
                                                          SizedBox(width: 15,),
                                                          Column(
                                                            children: [
                                                              Text("${cupcontroller.list[index].competitorsCount}/${cupcontroller.list[index].participants}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 13)),),
                                                              Obx(() => Text(langController.joined.value.toString(), style: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w500,fontSize: 10)),),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],

                                          ),
                                        ),
                                        onTap: (){
                                          if(langController.isGuestMode.value == "1"){
                                            guestDialog();
                                          }else{
                                            Navigator.of(context,rootNavigator: true).push(PageTransition(child: CupDetailPage(id: '${cupcontroller.list[index].id}',), type: PageTransitionType.rightToLeft));

                                          }
                                        },
                                      );
                                    });
                              }
                            })
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,)
        ],
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

}


