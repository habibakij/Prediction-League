
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/common/connectivity_checker.dart';
import 'package:prediction/controller/rank_detail_controller.dart';
import 'package:prediction/model/rank.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/pages/UserProfile/user_profile_page.dart';
import '../../common/language_controller.dart';
import '../../controller/ad_controller/ads_controller.dart';
import '../../package/slider/carousel_slider.dart';
import '../../util/constant.dart';
import '../../util/expandable_pageview.dart';
import '../../widget/empty_failure_no_internet_view.dart';

class RankDetailPage extends StatefulWidget {
  final League league;
  final String top;
  final Season season;
  final World world;
  final int points;
  const RankDetailPage({Key? key,required this.league,required this.top,required this.season,required this.world,required this.points}) : super(key: key);
  @override
  State<RankDetailPage> createState() => _RankDetailPageState();
}



class _RankDetailPageState extends State<RankDetailPage> {
  var languageController= Get.put(LanguageController());
  final adsController=Get.put(AdsController());
  final controller=Get.put(RankDetailController());
  final internetController=Get.put(ConnectivityCheckerController());

  int userId=0;
  @override
  void initState(){
    super.initState();
    internetController.startMonitoring();
    controller.getData(true, widget.league.id.toString(), widget.top);
    getUserId();

  }
  getUserId()async{
    userId=await getIntPrefs(USER);
    setState((){});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back,color: primaryColor,),),
        title: Text("apptitle".tr,style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF000000),fontSize: 12,fontWeight: FontWeight.w600)),),
        centerTitle: true,
        actions: [
          // IconButton(onPressed: (){}, icon: Icon(Icons.notifications,color: primaryColor,))
        ],
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
                controller.getData(true,widget.league.id.toString(),widget.top);
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
                controller.getData(true,widget.league.id.toString(),widget.top);
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
                controller.getData(true,widget.league.id.toString(),widget.top);
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
                controller.getData(true,widget.league.id.toString(),widget.top);
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
                controller.getData(true,widget.league.id.toString(),widget.top);
              },
              status: 1,
            ),
          );
        }
        else{
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              //Image.asset("assets/images/banner.png",height: 85,width: double.infinity,fit: BoxFit.cover,),

              //ExpandablePageView(hmm: '',
              //children:adsController.adsWidgetList),
              Container(
                constraints: BoxConstraints(
                    maxHeight: height(context, ""),
                    minHeight: 90
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

                    SizedBox(height: 25,),
                    Row(
                      children: [
                        Container(
                          height: 32,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFF1F7F7)
                          ),
                          child: Image.network("${widget.league.logo}",fit: BoxFit.cover,),
                        ),
                        SizedBox(width: 17,),
                        Text("${widget.league.name}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF404040),fontWeight: FontWeight.w700,fontSize: 14)),)
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


                            }, child: Text("Season ${getSeason(widget.season.year)}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15))))
                    ),
                    SizedBox(height:17 ,),
                    Text(widget.top=="world"?"WORLD WIDE RANK":widget.top=="continent"?"CONTINENT RANK":"COUNTRY RANK",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF404040),fontWeight: FontWeight.w600,fontSize: 16)),),
                    SizedBox(height: 9,),
                    Row(
                      children: [
                        Expanded(child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: Color(0xFFE2E2E2)
                          ),
                        )),
                        Expanded(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/profile_icon.svg",height: 18,color: Color(0xFFFFAF00),),
                            SizedBox(width: 10,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(languageController.total_user.value.toString(),style: TextStyle(color: Color(0xFFA5A5A5),fontWeight: FontWeight.w400,fontSize: 11)),),
                                Text("${widget.world.total}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w600,fontSize: 13)),)
                              ],
                            )
                          ],
                        ))
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Expanded(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/rank_icon.svg",height: 18,color: Color(0xFFFFAF00),),
                            SizedBox(width: 10,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(languageController.your_ranked.value.toString(),style:TextStyle(color: Color(0xFFA5A5A5),fontWeight: FontWeight.w400,fontSize: 11)),),
                                Text("${widget.world.position}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w600,fontSize: 13)),)
                              ],
                            )
                          ],
                        )),
                        Expanded(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline,color: Color(0xFFFFAF00),),
                            SizedBox(width: 10,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(languageController.your_point.value.toString(),style: TextStyle(color: Color(0xFFA5A5A5),fontWeight: FontWeight.w400,fontSize: 11)),),
                                Text("${widget.points}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w600,fontSize: 13)),)
                              ],
                            )
                          ],
                        ))
                      ],
                    ),

                  ],
                ),
              ),
              SizedBox(height:19 ,),
              Container(
                height: 31,
                margin: EdgeInsets.symmetric(horizontal: 100),
                width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xFF1A1819)
                ),
                child: Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(languageController.top.value.toString(),style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.w600)),),),
                    Text(" 100",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFFFFFFF),fontSize: 16,fontWeight: FontWeight.w600)),),
                  ],
                ),),
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
                      //need to add those to translate file
                      DataColumn(label: Obx(() => Text(languageController.rank.value.toString(),textAlign: TextAlign.center,)),),
                      DataColumn(label: Obx(()=>Text(languageController.status.value.toString(),textAlign: TextAlign.start,))),
                      DataColumn(label: Obx(()=>Text(languageController.rank_name.value.toString(),textAlign: TextAlign.start,))),
                      DataColumn(label: Obx(()=>Text(languageController.poinlr.value.toString(),textAlign: TextAlign.start,))),
                      DataColumn(label: Obx(() => Text(languageController.point.value.toString(),textAlign: TextAlign.start)),),
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
                                        backgroundImage: CachedNetworkImageProvider("${controller.list[index].user!.profilePicture}"),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("@${controller.list[index].user!.username}",style: TextStyle(color: controller.list[index].user!.id==userId?Color(0xFFFFAF00):Color(0xFF686868)),),
                                      controller.list[index].user!.id==userId?Icon(Icons.star,color: Color(0xFFFFAF00),):SizedBox(),
                                    ],
                                  ),
                                  onTap: (){
                                    Navigator.of(context).push(PageTransition(child: UserProfilePage(userId: '${controller.list[index].user!.id!}',), type: PageTransitionType.rightToLeft));
                                  }
                              ),

                              DataCell(

                                Row(
                                  children: [
                                    Container(
                                      height:30,
                                      width:50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: primaryColor
                                      ),
                                      child: Center(child: Text(controller.list[index].pointsFromLastRound!=null?"${controller.list[index].pointsFromLastRound!}":"0"),),
                                    )
                                  ],
                                ),

                              ),

                              DataCell(
                                Text("${controller.list[index].points}", textAlign: TextAlign.end,),
                              ),

                            ]);
                      },
                      growable: true,
                    )),
              ),

            ],
          );
        }
      })
    );
  }
  getSeason(String? year) {
    var preYear=year!.replaceAll("20","");
    var postYear=int.parse(preYear)+1;
    return "$preYear/$postYear";
  }
}
