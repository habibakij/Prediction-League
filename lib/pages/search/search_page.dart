import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/common/connectivity_checker.dart';
import 'package:prediction/common/language_controller.dart';
import 'package:prediction/controller/search/search_controller.dart';
import 'package:prediction/util/constant.dart';

import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../widget/empty_failure_no_internet_view.dart';
import '../notification/notification_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  TabController? tabController;
  final langController=Get.put(LanguageController());
  final controller=Get.put(SearchController());
  final internetController=Get.put(ConnectivityCheckerController());
  final searchController=TextEditingController();
  var type="joined_by";
  int userId=0;

  getUserId()async{
    userId=await getIntPrefs(USER);
    setState((){});
  }
  @override
  void initState(){
    super.initState();
    getUserId();
    tabController=TabController(length: 2, vsync: this)
    ..addListener(() {
      setState(() {
        switch(tabController!.index) {
          case 0:
            if(searchController.text.isNotEmpty){
              controller.list.clear();
              controller.getData(true, "joined_by", searchController.text);
            }
            type="joined_by";

            break;
          case 1:
            if(searchController.text.isNotEmpty){
              controller.list.clear();
              controller.getData(true, "popular", searchController.text);
            }
            type="popular";
            break;
        }
      });
    });
    langController.getLang();
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            shadowColor: primaryColor,
            foregroundColor: primaryColor,
            bottomOpacity: 0.0,
            surfaceTintColor: primaryColor,
            backgroundColor: primaryColor,
            leading: IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Icon(Icons.arrow_back,color: Colors.white,),),
            title:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/search.svg",color: Colors.white,),
                SizedBox(width: 10,),
                Text("search".tr,style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w600)),
              ],
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: primaryColor,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context,rootNavigator: true).push(PageTransition(child: NotificationPage(), type: PageTransitionType.fade));
                  },
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ))
            ],
          ),
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 70,
                    margin: EdgeInsets.only(top: 70),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                        color: Color(0xFFF4F4F4)
                    ),
                    child: TabBar(
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 3.0, color: primaryColor),
                        insets: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: primaryColor,
                      controller: tabController,
                      tabs: [
                        Tab(text: "Search League",),
                        Tab(text: "Popular League",)
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                        color: primaryColor
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 27,vertical: 10),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: searchController,
                        onChanged: (val)async{
                          controller.list.clear();
                          await Future.delayed(Duration(seconds: 1));
                          var type=tabController!.index==0?"joined_by":"popular";
                          controller.getData(true, type,val);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          hintText: "search".tr,
                          contentPadding: EdgeInsets.only(left: 15,right: 15),
                          hintStyle: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),
                          suffixIcon: SvgPicture.asset("assets/images/search.svg",height:15,width: 15,fit: BoxFit.scaleDown,color: Colors.white,),
                          fillColor: Color(0xFFFAFAFA).withOpacity(0.5),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white,width: 1)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white,width: 1)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white,width: 1)
                          ),
                        ),
                      ),
                    ),

                  ),

                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                    children: [
                  Obx(() {
                    if(controller.loading.value==true){

                      return Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF8FC7FF),
                        ),
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
                            controller.getData(true,type,searchController.text);
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
                            controller.getData(true,type,searchController.text);
                          },
                          status: 1,
                        ),
                      );
                    } else if (controller.serverError.value == true) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'Server error',
                          description: 'Please try again later',
                          buttonText: "Retry",
                          onPressed: () {
                            controller.getData(true,type,searchController.text);
                          },
                          status: 1,
                        ),
                      );
                    } else if (controller.somethingWrong.value == true&&searchController.text.isNotEmpty) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'Something went wrong',
                          description: 'Please try again later',
                          buttonText: "Retry",
                          onPressed: () {
                            controller.getData(true,type,searchController.text);
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
                            controller.getData(true,type,searchController.text);
                          },
                          status: 1,
                        ),
                      );
                    }
                    else  if(controller.loading.value==false&&controller.list.isEmpty&&searchController.text.isNotEmpty){
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/empty_lottie.json',
                          title: 'No data',
                          description: 'No data found',
                          buttonText: "Retry",
                          onPressed: () {
                          },
                          status: 0,
                        ),
                      );
                    }
                    else  if(searchController.text.isEmpty){
                      return Center(
                          child: Text("Explore!",style: TextStyle(fontSize: 18),)
                      );
                    }{
                      return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: controller.list.length,
                          padding: EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                          itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: (){
                                showDialog(context: context, builder: (context){
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),

                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(Icons.close),
                                            ),
                                          ),
                                          Text("Enter the ${controller.list[index].league!.name!.toUpperCase()}",),
                                          SizedBox(height: 30,),
                                          ElevatedButton(

                                            onPressed: () async{
                                               LoadingProgress.start(context);
                                               var response=await sendJoinLeagueRequest(controller.list[index].id.toString());
                                               LoadingProgress.stop(context);
                                               Navigator.of(context).pop();
                                               if(response.statusCode==200){

                                                 showSuccessDialog(context,controller.list[index].league!.name!,controller.list[index].user!.username!);
                                               }else{
                                                 var data=jsonDecode(response.body);
                                                 var message=data['message'];
                                                 showFailedDialog(context,controller.list[index].league!.name!,message);
                                               }
                                            },
                                            child: Text("JOIN LEAGUE",style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white,fontSize: 14),)),
                                            style: ElevatedButton.styleFrom(
                                                primary: primaryColor
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 18),
                                child: Stack(
                                  children: [
                                    userId==controller.list[index].user!.id?Container(
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
                                          Text("owner".tr,style:TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 11)),
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
                                      margin: EdgeInsets.only(top: userId==controller.list[index].user!.id?30:0),
                                      child: Row(
                                        children: [
                                          Expanded(child: Row(
                                            children: [
                                              Container(
                                                height: 32,
                                                width: 60,

                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7),

                                                ),
                                                child: Image.network(controller.list[index].league!.logo??""),
                                                padding: EdgeInsets.all(5),
                                              ),
                                              SizedBox(width: 10,),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(controller.list[index].league!.name??"Name".toUpperCase(),style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF404040),fontWeight: FontWeight.w600,fontSize: 13,))),
                                                    Text(controller.list[index].currentRound!=null?"Round ${controller.list[index].currentRound!.name}":"",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 11)),),
                                                    SizedBox(height: 12,),
                                                    SizedBox(height: 12,),
                                                    controller.list[index].winner!=null?Text("@${controller.list[index].winner!.username}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 11)),)
                                                        :Text("Play for ${controller.list[index].playFor}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 11)),)

                                                  ],
                                                ),
                                              )
                                            ],
                                          ),),
                                          controller.list[index].winner!=null?Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Color(0xFFFFB001)
                                            ),
                                            child: Row(
                                              children: [
                                                Text("winner".tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 12)),
                                                SizedBox(width: 15,),
                                                SvgPicture.asset("assets/images/league_icon.svg",color: Colors.white,)
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
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      controller.list[index].participants==-1?Text("${controller.list[index].competitorsCount}/Unlimited",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 13)),):
                                                      Text("${controller.list[index].competitorsCount}/${controller.list[index].participants}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 13)),),
                                                      Text("joined".tr,style: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w500,fontSize: 10))
                                                    ],
                                                  ),
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
                            );
                          });
                    }
                  }),
                      Obx(() {
                        if(controller.loading.value==true){

                          return Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF8FC7FF),
                            ),
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
                                controller.getData(true,type,searchController.text);
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
                                controller.getData(true,type,searchController.text);
                              },
                              status: 1,
                            ),
                          );
                        } else if (controller.serverError.value == true&&searchController.text.isNotEmpty) {
                          return Center(
                            child: EmptyFailureNoInternetView(
                              image: 'assets/lottie/failure_lottie.json',
                              title: 'Server error',
                              description: 'Please try again later',
                              buttonText: "Retry",
                              onPressed: () {
                                controller.getData(true,type,searchController.text);
                              },
                              status: 1,
                            ),
                          );
                        } else if (controller.somethingWrong.value == true&&searchController.text.isNotEmpty) {
                          return Center(
                            child: EmptyFailureNoInternetView(
                              image: 'assets/lottie/failure_lottie.json',
                              title: 'Something went wrong',
                              description: 'Please try again later',
                              buttonText: "Retry",
                              onPressed: () {
                                controller.getData(true,type,searchController.text);
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
                                controller.getData(true,type,searchController.text);
                              },
                              status: 1,
                            ),
                          );
                        }
                        else  if(controller.loading.value==false&&controller.list.isEmpty&&searchController.text.isNotEmpty){
                          return Center(
                            child: EmptyFailureNoInternetView(
                              image: 'assets/lottie/empty_lottie.json',
                              title: 'No data',
                              description: 'No data found',
                              buttonText: "Retry",
                              onPressed: () {
                              },
                              status: 0,
                            ),
                          );
                        }
                        else  if(searchController.text.isEmpty){
                          return Center(
                              child: Text("Explore!",style: TextStyle(fontSize: 18),)
                          );
                        }{
                          return ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: controller.list.length,
                              padding: EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    showDialog(context: context, builder: (context){
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),

                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: IconButton(
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: Icon(Icons.close),
                                                ),
                                              ),
                                              Text("Enter the ${controller.list[index].league!.name!.toUpperCase()}",),
                                              SizedBox(height: 30,),
                                              ElevatedButton(

                                                onPressed: () async{
                                                  LoadingProgress.start(context);
                                                  var response=await sendJoinLeagueRequest(controller.list[index].id.toString());
                                                  LoadingProgress.stop(context);
                                                  Navigator.of(context).pop();
                                                  if(response.statusCode==200){
                                                    showSuccessDialog(context,controller.list[index].league!.name!,controller.list[index].user!.username!);
                                                  }else {
                                                    var data=jsonDecode(response.body);
                                                    var message=data['message'];
                                                    showFailedDialog(context,controller.list[index].league!.name!,message);
                                                  }
                                                },
                                                child: Text("JOIN LEAGUE",style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white,fontSize: 14),)),
                                                style: ElevatedButton.styleFrom(
                                                    primary: primaryColor
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 18),
                                    child: Stack(
                                      children: [
                                        userId==controller.list[index].user!.id?Container(
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
                                              Text("owner".tr,style:TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 11)),
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
                                          margin: EdgeInsets.only(top: userId==controller.list[index].user!.id?30:0),
                                          child: Row(
                                            children: [
                                              Expanded(child: Row(
                                                children: [
                                                  Container(
                                                    height: 32,
                                                    width: 60,

                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(7),

                                                    ),
                                                    child: Image.network(controller.list[index].league!.logo??""),
                                                    padding: EdgeInsets.all(5),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(controller.list[index].league!.name??"Name".toUpperCase(),style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF404040),fontWeight: FontWeight.w600,fontSize: 13,))),
                                                        Text(controller.list[index].currentRound!=null?"Round ${controller.list[index].currentRound!.name}":"",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 11)),),
                                                        SizedBox(height: 12,),
                                                        SizedBox(height: 12,),
                                                        controller.list[index].winner!=null?Text("@${controller.list[index].winner!.username}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.orange,fontWeight: FontWeight.w500,fontSize: 11)),)
                                                            :Text("Play for ${controller.list[index].playFor}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 11)),)

                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),),
                                              controller.list[index].winner!=null?Container(
                                                padding: EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: Color(0xFFFFB001)
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text("winner".tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 12)),
                                                    SizedBox(width: 15,),
                                                    SvgPicture.asset("assets/images/league_icon.svg",color: Colors.white,)
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
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          controller.list[index].participants==-1?Text("${controller.list[index].competitorsCount}/Unlimited",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 13)),):
                                                          Text("${controller.list[index].competitorsCount}/${controller.list[index].participants}",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 13)),),
                                                          Text("joined".tr,style: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w500,fontSize: 10))
                                                        ],
                                                      ),
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
                                );
                              });
                        }
                      }),
                ]),
              )

            ],
          ),
        )
    );
  }

  void showSuccessDialog(BuildContext context,String title,String userName) {
    showDialog(context: context, builder: (context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),

        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                ),
              ),
              Text("Congratulations!",style: TextStyle(fontSize: 18,color: Colors.black),),
              
              SizedBox(height: 30,),
              Image.asset("assets/images/success.png",height: 60,fit: BoxFit.fill,),
              SizedBox(height: 30,),
              Text("You have successfully joined",style: TextStyle(fontSize: 16,color: Colors.black54),),
              SizedBox(height: 10,),
              Text(title,style: TextStyle(fontSize: 20),),
              SizedBox(height: 10,),
              Text("@$userName",style: TextStyle(fontSize: 14,color: primaryColor),),
              SizedBox(height: 10,),
              Text("GET READY!",style: TextStyle(color: Colors.orange,fontSize: 30),),
              SizedBox(height: 20,),
              ElevatedButton(

                onPressed: () async{
                  Navigator.of(context).pop();
                },
                child: Text("OK",style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white,fontSize: 14),)),
                style: ElevatedButton.styleFrom(
                    primary: primaryColor
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void showFailedDialog(BuildContext context,String title,String message) {
    showDialog(context: context, builder: (context){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),

        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                ),
              ),
              Text("Ooops!",style: TextStyle(fontSize: 18,color: Colors.black),),

              SizedBox(height: 30,),
              Image.asset("assets/images/failed.png",height: 60,fit: BoxFit.fill,),
              SizedBox(height: 30,),
              Text("You cannot join",style: TextStyle(fontSize: 16,color: Colors.black54),),
              SizedBox(height: 10,),
              Text(title,style: TextStyle(fontSize: 20),),
              SizedBox(height: 10,),
              Text("because of the following error",style: TextStyle(fontSize: 14,color: primaryColor),),
              SizedBox(height: 10,),

              Text(message,style: TextStyle(fontSize: 14,color: primaryColor),),
              SizedBox(height: 10,),
              Text("HARD LUCK",style: TextStyle(color: Colors.red,fontSize: 30),),
              SizedBox(height: 20,),
              ElevatedButton(

                onPressed: () async{
                  Navigator.of(context).pop();
                },
                child: Text("OK",style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white,fontSize: 14),)),
                style: ElevatedButton.styleFrom(
                    primary: primaryColor
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

