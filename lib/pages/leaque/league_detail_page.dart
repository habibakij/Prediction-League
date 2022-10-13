
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/common/connectivity_checker.dart';
import 'package:prediction/controller/private_league_controller.dart';
import 'package:prediction/controller/private_league_detail_controller.dart';
import 'package:prediction/model/private_league.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/package/smart_refresher/smart_refresher.dart';
import 'package:prediction/pages/UserProfile/user_profile_page.dart';
import 'package:prediction/pages/chat/message_page.dart';

import '../../common/language_controller.dart';
import '../../controller/ad_controller/ads_controller.dart';
import '../../package/slider/carousel_slider.dart';
import '../../util/constant.dart';
import '../../util/expandable_pageview.dart';
import '../../widget/empty_failure_no_internet_view.dart';

class LeagueDetailPage extends StatefulWidget {
  final PrivateLeague privateLeague;
  const LeagueDetailPage({Key? key,required this.privateLeague}) : super(key: key);

  @override
  State<LeagueDetailPage> createState() => _RankDetailPageState();
}

class _RankDetailPageState extends State<LeagueDetailPage> {
  final adsController=Get.put(AdsController());
  var languageController= Get.put(LanguageController());
  var controller=Get.put(PrivateLeagueDetailController());
  var controller1=Get.put(PrivateLeagueController());
  var internetController=Get.put(ConnectivityCheckerController());
  int userId=0;
  var description="";

  getUserId()async{
    userId=await getIntPrefs(USER);
    description=widget.privateLeague.description!;
    setState((){});
  }
  @override
  void initState(){
    super.initState();
    getUserId();
    controller.list.clear();
    controller.page.value=1;
    controller.pageCount.value=1;
    languageController.getLang();
    internetController.startMonitoring();
    controller.getData(true,widget.privateLeague.id.toString(),controller.page.value.toString(),false);

  }
  @override
  void onDispose(){
    Get.delete<PrivateLeagueDetailController>();
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
          title: Obx(()=>Text(languageController.league_details.value,style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF000000),fontSize: 12,fontWeight: FontWeight.w600)),),),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white
          ),
          actions: [
            IconButton(onPressed: (){
              if(controller.loading.value==false){
                Navigator.of(context).push(PageTransition(child: MessagePage(competetors: widget.privateLeague.competitorsCount.toString(), leagueTitle: widget.privateLeague.title!, leagueId: '${widget.privateLeague.id}',), type: PageTransitionType.rightToLeft));

              }else{

              }
               }, icon:  Image.asset(
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

          else if (controller.internetError.value == true) {
            return Center(
              child: EmptyFailureNoInternetView(
                image: 'assets/lottie/no_internet_lottie.json',
                title: 'Internet Error',
                description: 'Internet not found',
                buttonText: "Retry",
                onPressed: () {
                  controller.getData(true,widget.privateLeague.id.toString(),"1".toString(),false);
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
                  controller.getData(true,widget.privateLeague.id.toString(),"1".toString(),false);  },
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
                  controller.getData(true,widget.privateLeague.id.toString(),"1".toString(),false);  },
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
                  controller.getData(true,widget.privateLeague.id.toString(),"1".toString(),false);  },
                status: 1,
              ),
            );
          }
          else{
            return SmartRefresher(
              controller: controller.refreshController,
              enablePullUp: true,
              enablePullDown: true,
              onLoading: (){
                controller.getData(false,widget.privateLeague.id.toString(),controller.page.value.toString(),false);
              },
              onRefresh: (){
                controller.refreshController.refreshToIdle();
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  //ExpandablePageView(hmm: '',
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
                  SizedBox(height: 24,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 23),
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xFFFAFAFA)
                    ),
                    child: Column(
                      children: [


                        SizedBox(height: 18,),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Stack(
                            children: [
                              widget.privateLeague.user!.id==userId?Container(
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
                                    Obx(() => Text(languageController.owner.value.toString(), style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 11)),),
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
                                margin: EdgeInsets.only(top: widget.privateLeague.user!.id==userId?30:0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 32,
                                          width: 60,

                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7),

                                          ),
                                          child: Image.network("${widget.privateLeague.league!.logo}"),
                                          padding: EdgeInsets.all(5),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(child: Text("${widget.privateLeague.league!.name}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF404040),fontWeight: FontWeight.w600,fontSize: 13)),))
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        if(userId!=widget.privateLeague.user!.id){
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
                                                          var response=await sendUpdateDes(controllerDes.text, widget.privateLeague.id.toString());
                                                          LoadingProgress.stop(context);
                                                          if(response.statusCode==200){
                                                            showToast("Updated!");
                                                            description=controllerDes.text;
                                                            controller1.getData(false);
                                                            setState(() {

                                                            });
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
                                        child: Text("Description: ${description} (editable by clicking on it)",style: TextStyle(fontSize: 15),)),
                                    Text("User Name: @${widget.privateLeague.user!.username}",style: TextStyle(fontSize: 15,color: primaryColor),),
                                    Text("Play for ${widget.privateLeague.playFor}",style: TextStyle(fontSize: 15,color: Colors.black),),
                                    widget.privateLeague.playFor=="prize"?Text("Contact: ${widget.privateLeague.contact}"):SizedBox(),



                                  ],
                                ),
                              )
                            ],

                          ),
                        ),
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


                                }, child: Text("${getSeason(widget.privateLeague.season!.year)}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15))))
                        ),
                        SizedBox(height:17 ,),
                        Text("${widget.privateLeague.league!.name}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF404040),fontWeight: FontWeight.w600,fontSize: 16)),),
                        SizedBox(height: 5,),
                        Text("League Type '${widget.privateLeague.joinedBy}'",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF404040),fontWeight: FontWeight.w500,fontSize: 12)),),
                        SizedBox(height: 5,),
                        Text(widget.privateLeague.currentRound==null?"":"Round ${widget.privateLeague.currentRound!.name}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF404040),fontWeight: FontWeight.w500,fontSize: 12)),),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Expanded(child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: primaryColor
                              ),
                              child: Row(
                                children: [
                                  Image.asset("assets/images/ball.png",height: 29,width: 29,color: Colors.white,),
                                  SizedBox(width: 5,),
                                  Column(
                                    children: [
                                      Text("${widget.privateLeague.competitorsCount}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16)),),
                                      SizedBox(height: 4,),
                                      Obx(() => Text(languageController.joined.value.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13))),
                                    ],
                                  )
                                ],
                              ),
                            )),
                            SizedBox(width: 10,),
                            Expanded(child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: commonTextColor
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/images/rank_icon.svg",height: 29,width: 29,color: Colors.white,),
                                  SizedBox(width: 5,),
                                  Column(
                                    children: [
                                      Text("${widget.privateLeague.rank_among_others}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13)),),
                                      SizedBox(height: 4,),
                                      Obx(() => Text(languageController.your_ranked.value.toString(), style: TextStyle(color: Color(0xFFD1D1D1),fontWeight: FontWeight.w500,fontSize: 11))),
                                    ],
                                  )
                                ],
                              ),
                            )),
                            SizedBox(width: 10,),
                            widget.privateLeague.winner!=null?Expanded(child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Color(0xFFFFB001)
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/images/league_icon.svg",height: 29,width: 29,color: Colors.white,),
                                  SizedBox(width: 5,),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text("@${widget.privateLeague.winner!.username}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13)),),
                                        SizedBox(height: 4,),
                                        Obx(() => Text(languageController.winner.value.toString(), style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 11))),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )):SizedBox(),
                          ],
                        )




                      ],
                    ),
                  ),


                  SizedBox(height:36 ,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        dividerThickness: 0,
                        headingRowColor: MaterialStateColor.resolveWith((states){
                          return Color(0xFFF9FAFB);
                        }),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color:
                                Color(0xFF888888).withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(5)),
                        showBottomBorder: true,
                        columns: [
                          DataColumn(label: Text(languageController.rank.value.toString(), textAlign: TextAlign.center,)),
                          DataColumn(label: Text(languageController.status.value.toString(), textAlign: TextAlign.center,)),
                          DataColumn(label: Text(languageController.username.value.toString(), textAlign: TextAlign.center,)),
                          DataColumn(label: Text(languageController.round_point.value.toString(),textAlign: TextAlign.start,)),
                          DataColumn(label: Text(languageController.total_points.value.toString(),textAlign: TextAlign.start)),
                        ],
                        rows: List.generate(
                          controller.list.length,
                              (index) {

                            return DataRow(
                                color: MaterialStateColor.resolveWith((states){
                                  if(index%2==0){
                                    return Color(0xFFFFFFFF);
                                  }else{

                                    return Color(0xFFF9FAFB);
                                  }
                                }),
                                cells: [
                                  DataCell(
                                    Text("${controller.list[index].position}",
                                      textAlign: TextAlign.end,),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        Icon(controller.list[index].position!>=controller.list[index].mostRecentPosition!?Icons.arrow_drop_up:Icons.arrow_drop_down,color: controller.list[index].position!>=controller.list[index].mostRecentPosition!?Colors.green:Colors.red,),
                                        Text("${controller.list[index].mostRecentPosition!}",style: TextStyle(color: controller.list[index].position!>=controller.list[index].mostRecentPosition!?Colors.green:Colors.red),)
                                      ],
                                    ),
                                  ),
                                  DataCell(

                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundImage: NetworkImage("${controller.list[index].user!.profilePicture}"),
                                          ),
                                          SizedBox(width: 5,),
                                          Text("@${controller.list[index].user!.username}"),
                                          SizedBox(width: 5,),
                                          userId==controller.list[index].user!.id?Icon(Icons.star,color: Color(0xFFFFAF00),):SizedBox(),
                                        ],
                                      ),
                                      onTap: (){
                                        Navigator.of(context).push(PageTransition(child: UserProfilePage(userId: controller.list[index].user!.id!.toString(),), type: PageTransitionType.rightToLeft));
                                      }
                                  ),
                                  DataCell(

                                    Text("${controller.list[index].pointsFromLastRound}", textAlign: TextAlign.end,),
                                  ),
                                  DataCell(
                                    Text("${controller.list[index].points}", textAlign: TextAlign.center,),
                                  ),

                                ]);
                          },
                          growable: true,
                        )),
                  ),

                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
