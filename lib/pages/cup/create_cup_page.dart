
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/common/language_controller.dart';
import 'package:prediction/controller/cup/cup_controller.dart';
import 'package:prediction/controller/private_cup_controller.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/pages/share/share_cup_page.dart';
import '../../controller/ad_controller/ads_controller.dart';
import '../../package/slider/carousel_slider.dart';
import '../../util/constant.dart';
import '../../util/expandable_pageview.dart';

class CreateCupPage extends StatefulWidget {
  @override
  State<CreateCupPage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<CreateCupPage> {
  var languageController= Get.put(LanguageController());
  final adsController=Get.put(AdsController());
  final controller=Get.put(CupController());
  final pCupController=Get.put(PrivateCupController());
  String leagueType="";
  String playFor="";
  var participants;
  var competition;
  var round;
  var privateOrGeneral="";
  final titleController=TextEditingController();
  final descriptionController=TextEditingController();
  final phoneController=TextEditingController();
  var participationList=["128","64","32","16","8","4"];
  var typeCompetitionList=["home-and-away","one-match"];

  @override
  void initState(){
    super.initState();
    controller.getSeason();
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
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
            title:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/create_cup.png",color: primaryColor,height: 18,width: 18,),
                SizedBox(width: 10,),
                Obx(() => Text(languageController.create_cup.value.toString(),style: toolbarTitleStyle,),),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                splashRadius: 1,

                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ))
            ],
          ),
          body: Obx((){
            if(controller.loading.value==true){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 5,),
                    Text("Please wait...")
                  ],
                ),
              );
            }else{
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Image.asset("assets/images/banner.png"),
                   //ExpandablePageView(children:adsController.adsWidgetList),
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
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 19,),
                          Center(child: Obx(() => Text(languageController.select_type.value.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Color(0xFF1A1819)),)),),
                          SizedBox(height: 23,),

                          Container(

                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFFAFAFA),
                                border: Border.all(color: Color(0xFFE7E7E7),width: 1)
                            ),
                            child: Column(
                              children: [
                                Radio(
                                    value: "uefa",
                                    activeColor: primaryColor,
                                    groupValue: leagueType,
                                    onChanged: (val){
                                      controller.cupRoundList.clear();
                                      round=null;
                                      leagueType=val as String;
                                      competition=null;
                                      participants=null;
                                      setState((){

                                      });


                                    }
                                ),
                                SizedBox(height: 10,),
                                Image.network(controller.uefa_flag,height: 40,width: 55,),
                                SizedBox(height: 14,),
                                Text("UFEA Champions\nLeague",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w500,fontSize: 13)),textAlign: TextAlign.center,),
                                SizedBox(height: 10,)
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(

                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFFAFAFA),
                                border: Border.all(color: Color(0xFFE7E7E7),width: 1)
                            ),
                            child: Column(
                              children: [
                                Radio(
                                    value: "premier",
                                    activeColor: primaryColor,
                                    groupValue: leagueType,
                                    onChanged: (val){
                                      controller.cupRoundList.clear();
                                      round=null;
                                      leagueType=val as String;
                                      competition=null;
                                      participants=null;
                                      setState((){

                                      });
                                    }
                                ),
                                SizedBox(height: 10,),
                                Image.network(controller.premier_flag,height: 40,width: 55,),
                                SizedBox(height: 14,),
                                Text("Premier League",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w500,fontSize: 13)),textAlign: TextAlign.center,),
                                SizedBox(height: 10,)
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFFAFAFA),
                                border: Border.all(color: Color(0xFFE7E7E7),width: 1)
                            ),
                            child: Column(
                              children: [
                                Radio(
                                    value: "world",
                                    activeColor: primaryColor,
                                    groupValue: leagueType,
                                    onChanged: (val){
                                      controller.cupRoundList.clear();
                                      round=null;
                                      leagueType=val as String;
                                      competition=null;
                                      participants=null;
                                      setState((){

                                      });
                                    }
                                ),
                                SizedBox(height: 10,),
                                Image.network(controller.world_flag,height: 40,width: 55,),
                                SizedBox(height: 14,),
                                Text("World Cup",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w500,fontSize: 13)),textAlign: TextAlign.center,),
                                SizedBox(height: 10,)
                              ],
                            ),
                          ),

                          SizedBox(height: 39,),
                          Obx(() => Text(languageController.cup_title.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                          SizedBox(height: 11,),
                          SizedBox(
                            height: 54,
                            child: TextFormField(
                              controller: titleController,
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
                          ),
                          SizedBox(height: 17,),
                          Obx(() => Text(languageController.description_optional.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                          SizedBox(height: 11,),
                          SizedBox(
                            height: 54,
                            child: TextFormField(
                              controller: descriptionController,
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
                          ),

                          Visibility(
                            visible: true,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 17,),
                              Obx(() => Text(languageController.no_of_participation.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                              SizedBox(height: 11,),
                              SizedBox(
                                height: 54,
                                child: DropdownButtonFormField(
                                  value: participants,
                                  decoration: InputDecoration(
                                      filled: true,
                                      hintText: languageController.select.value.toString(),
                                      hintStyle: TextStyle(color: Color(0xFFAAAAAA),fontWeight: FontWeight.w500,fontSize: 15),
                                      fillColor: Color(0xFFFAFAFA),
                                      contentPadding: EdgeInsets.only(left: 10,right: 10),
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
                                  onChanged: (value) {
                                    controller.cupRoundList.clear();
                                    round=null;
                                    setState((){
                                      participants=value;

                                    });
                                    if(competition!=null&&leagueType.isNotEmpty){
                                      controller.getCupRounds(competition, participants, leagueType=="uefa"?"2":leagueType=="premier"?"39":"1", context);
                                    }
                                  },
                                  items: participationList.map((e) => DropdownMenuItem(child: Text(
                                    "$e",

                                  ),value: e,)).toList(),
                                ),
                              ),
                            ],
                          )),
                          SizedBox(height: 17,),
                          Obx(() => Text(languageController.type_of_competition.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                          SizedBox(height: 11,),
                          SizedBox(
                            height: 54,
                            child: DropdownButtonFormField(
                              value: competition,
                              decoration: InputDecoration(
                                  filled: true,
                                  hintText: languageController.select.value.toString(),
                                  hintStyle:TextStyle(color: Color(0xFFAAAAAA),fontWeight: FontWeight.w500,fontSize: 15),
                                  fillColor: Color(0xFFFAFAFA),
                                  contentPadding: EdgeInsets.only(left: 10,right: 10),
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
                              onChanged: (value) {
                                setState((){
                                  competition=value;
                                  if(leagueType.isEmpty){
                                    showToast("Please select cup type");
                                    return;
                                  }
                                  if(participants==null||participants.toString().isEmpty){
                                    showToast("Please select no of participation");
                                    return;
                                  }

                                  controller.getCupRounds(competition, participants, leagueType=="uefa"?"2":leagueType=="premier"?"39":"1", context);

                                });
                              },
                              items: typeCompetitionList.map((e) => DropdownMenuItem(child: Text(
                                "$e",

                              ),value: e,)).toList(),
                            ),
                          ),

                          Visibility(
                              visible: controller.cupRoundList.isNotEmpty?true:false,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 17,),
                              Obx(() => Text(languageController.select_start_round.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                              SizedBox(height: 11,),
                              SizedBox(
                                height: 54,
                                child: DropdownButtonFormField(
                                  value: round,
                                  decoration: InputDecoration(
                                      filled: true,
                                      hintText: languageController.select.value.toString(),
                                      hintStyle: TextStyle(color: Color(0xFFAAAAAA),fontWeight: FontWeight.w500,fontSize: 15),
                                      fillColor: Color(0xFFFAFAFA),
                                      contentPadding: EdgeInsets.only(left: 10,right: 10),
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
                                  onChanged: (value) {
                                    setState((){
                                      round=value;
                                    });
                                  },
                                  items: controller.cupRoundList.map((e) => DropdownMenuItem(child: Text(
                                    "${e.name}",

                                  ),value: e.id,)).toList(),
                                ),
                              ),
                            ],
                          )),


                          SizedBox(height: 17,),
                          Obx(() => Text(languageController.play_for.value.toString(),style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                          SizedBox(height: 11,),
                          Row(
                            children: [
                              Expanded(child: Container(
                                decoration: BoxDecoration(
                                    border:Border.all(color: Color(0xFFE7E7E7),width: 1),
                                    borderRadius: BorderRadius.circular(13),
                                    color: Color(0xFFFAFAFA)
                                ),
                                child: Row(
                                  children: [
                                    Radio(value: "fun",
                                        groupValue: playFor,
                                        onChanged: (val){
                                          setState((){
                                            playFor=val as String;
                                          });
                                        }
                                    ),
                                    SizedBox(width: 10,),
                                    Obx(() => Text(languageController.fun.value))
                                  ],
                                ),
                              )),
                              SizedBox(width: 10,),
                              Expanded(child: Container(
                                decoration: BoxDecoration(
                                    border:Border.all(color: Color(0xFFE7E7E7),width: 1),
                                    borderRadius: BorderRadius.circular(13),
                                    color: Color(0xFFFAFAFA)
                                ),
                                child: Row(
                                  children: [
                                    Radio(value: "prize",
                                        groupValue: playFor,
                                        onChanged: (val){
                                          setState((){
                                            playFor=val as String;
                                          });
                                        }
                                    ),
                                    SizedBox(width: 10,),
                                    Obx(() => Text(languageController.prize.value))
                                  ],
                                ),
                              )),
                            ],
                          ),
                          Visibility(
                            visible: playFor=="prize"?true:false,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 17,),
                              Obx(() => Text(languageController.phone_number.value.toString(),style:  TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                              SizedBox(height: 11,),
                              SizedBox(
                                height: 54,
                                child: TextFormField(
                                  controller: phoneController,
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
                              ),
                            ],
                          )),
                          SizedBox(height: 17,),

                          Center(child: Obx(() => Text(languageController.select.value.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Color(0xFF1A1819)),)),),
                          SizedBox(height: 11,),
                          Row(
                            children: [
                              Expanded(child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xFFFAFAFA),
                                    border: Border.all(color: Color(0xFFE7E7E7),width: 1)
                                ),
                                child: Column(
                                  children: [
                                    Radio(
                                        value: "general",
                                        activeColor: primaryColor,
                                        groupValue: privateOrGeneral,
                                        onChanged: (val){
                                          setState((){
                                            privateOrGeneral=val as String;
                                            showToast(languageController.general.value);
                                          });
                                        }
                                    ),
                                    SizedBox(height: 10,),
                                    Image.asset("assets/images/general.png",height: 32,width: 60,),
                                    SizedBox(height: 14,),
                                    Obx(() => Text(languageController.general.value,style: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w500,fontSize: 13),textAlign: TextAlign.center,),),
                                    SizedBox(height: 10,)
                                  ],
                                ),
                              )),
                              SizedBox(width: 10,),
                              Expanded(child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xFFFAFAFA),
                                    border: Border.all(color: Color(0xFFE7E7E7),width: 1)
                                ),
                                child: Column(
                                  children: [
                                    Radio(
                                        value: "private",
                                        activeColor: primaryColor,
                                        groupValue: privateOrGeneral,
                                        onChanged: (val){
                                          setState((){
                                            privateOrGeneral=val as String;
                                            showToast(languageController.private.value);
                                          });
                                        }
                                    ),
                                    SizedBox(height: 10,),
                                    Image.asset("assets/images/private.png",height: 32,width: 60,),
                                    SizedBox(height: 14,),
                                    Obx(() => Text(languageController.private.value,style: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w500,fontSize: 13),textAlign: TextAlign.center,),),
                                    SizedBox(height: 10,)
                                  ],
                                ),
                              ))
                            ],
                          ),


                          SizedBox(height: 20,),
                          SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                      elevation: MaterialStateProperty.all(0),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(27)
                                      ))
                                  ),
                                  onPressed: ()async{
                                    if(leagueType.isEmpty){
                                      showToast("Please select cup type");
                                      return;
                                    }
                                    if(titleController.text.isEmpty){
                                      showToast("Please enter cup title");
                                      return;
                                    }
                                    if(playFor.isEmpty){
                                      showToast("Please select Play For?");
                                      return;
                                    }
                                    if(playFor=="prize"&&phoneController.text.isEmpty){
                                      showToast("Please enter phone number");
                                      return;
                                    }
                                    if(privateOrGeneral.isEmpty){
                                      showToast("Please select Private or General");
                                      return;
                                    }
                                    if(round==null||round.toString().isEmpty){
                                      showToast("Please select round");
                                      return;
                                    }
                                    if(competition==null||competition.toString().isEmpty){
                                      showToast("Please select type of competition");
                                      return;
                                    }
                                    LoadingProgress.start(context);
                                    var response=await sendCreateCup(
                                        leagueType=="uefa"?"2":leagueType=="premier"?"39":"1",
                                        titleController.text,
                                        descriptionController.text,
                                        playFor,
                                        phoneController.text,
                                        participants,
                                        privateOrGeneral,
                                        competition,
                                        round.toString()
                                    );
                                    LoadingProgress.stop(context);
                                    if(response.statusCode==201){
                                      pCupController.getData(false);
                                      showToast(languageController.league_successfull.value);
                                      var data=jsonDecode(response.body);
                                      var code=data['data']['code'];
                                      var id=data['data']['id'];
                                      Navigator.of(context).push(PageTransition(child: ShareCupPage(code: code, title: titleController.text, playfor: playFor, participant: participants, id: id.toString(), competitionType: competition,), type: PageTransitionType.rightToLeft));
                                    }else{
                                      var data=jsonDecode(response.body);
                                      var message=data['message'];
                                      showToast(message);
                                    }

                                  }, child: Text(languageController.create_cup_upper.value.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15)))
                          ),

                          SizedBox(height: 20,)
                        ],
                      ),
                    )

                  ],
                ),
              );
            }
          })
        )
    );
  }
}
