
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/pages/share/share_league_page.dart';
import '../../common/language_controller.dart';
import '../../controller/ad_controller/ads_controller.dart';
import '../../controller/leage_controller/create_league_controller.dart';
import '../../controller/private_league_controller.dart';
import '../../package/slider/carousel_slider.dart';
import '../../util/constant.dart';
import '../../util/expandable_pageview.dart';

class CreateLeaguePage extends StatefulWidget {
  @override
  State<CreateLeaguePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<CreateLeaguePage> {
  final appController=Get.put(CreateLeagueController());
  final adsController=Get.put(AdsController());
  var languageController= Get.put(LanguageController());
  final controller=Get.put(PrivateLeagueController());
  TextEditingController phoneOrEmailController= TextEditingController();
  TextEditingController titleController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  String groupValueLeagueType="";
  String groupValueSelectType="";
  var participantsValue;
  var list=[
    "50","100","200","500","Unlimited"
  ];
  var uefa_flag="https://leaguepred.com/img/leagues/2.jpeg";
  var premier_flag="https://media.api-sports.io/football/leagues/39.png";
  var world_flag="https://media.api-sports.io/football/leagues/1.png";
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
            }, icon: const Icon(Icons.arrow_back,color: primaryColor,),),
            title:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/league_icon.svg",color: primaryColor,),
                const SizedBox(width: 10,),
                Obx(() => Text(languageController.create_league.value.toString() ,style: toolbarTitleStyle,),),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: primaryColor,
                  ))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image.asset("assets/images/banner.png"),
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
                      const SizedBox(height: 19,),
                      Center(child: Obx(() => Text(languageController.select_type.value.toString(), style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: commonTextColor),)),),
                      const SizedBox(height: 23,),
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
                                groupValue: groupValueLeagueType,
                                onChanged: (val){
                                  setState((){
                                    groupValueLeagueType=val as String;
                                  });
                                }
                            ),
                            SizedBox(height: 10,),
                            Image.network(uefa_flag,height: 40,width: 55,),
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
                                groupValue: groupValueLeagueType,
                                onChanged: (val){
                                  setState((){
                                    groupValueLeagueType=val as String;
                                  });
                                }
                            ),
                            SizedBox(height: 10,),
                            Image.network(premier_flag,height: 40,width: 55,),
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
                                groupValue: groupValueLeagueType,
                                onChanged: (val){
                                  setState((){
                                    groupValueLeagueType=val as String;
                                  });
                                }
                            ),
                            SizedBox(height: 10,),
                            Image.network(world_flag,height: 40,width: 55,),
                            SizedBox(height: 14,),
                            Text("World Cup",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF1A1819),fontWeight: FontWeight.w500,fontSize: 13)),textAlign: TextAlign.center,),
                            SizedBox(height: 10,)
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => Text(languageController.league_title.value.toString(), style: const TextStyle(color: commonTextColor,fontSize: 16,fontWeight: FontWeight.w500)),),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 54,
                        child: TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: languageController.type.value.toString(),
                              hintStyle: const TextStyle(color: Color(0xFFAAAAAA),fontWeight: FontWeight.w500,fontSize: 15),
                              fillColor: const Color(0xFFFAFAFA),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1)
                              ),enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1)
                          )
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Obx(() => Text(languageController.description_optional.value.toString(), style: const TextStyle(color: commonTextColor,fontSize: 16,fontWeight: FontWeight.w500)),),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 54,
                        child: TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: languageController.type.value.toString(),
                              hintStyle: const TextStyle(color: Color(0xFFAAAAAA),fontWeight: FontWeight.w500,fontSize: 15),
                              fillColor: const Color(0xFFFAFAFA),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1)
                              ),enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1)
                          )
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Obx(() => Text(languageController.play_for.value.toString(), style: const TextStyle(color: commonTextColor,fontSize: 16,fontWeight: FontWeight.w500)),),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: Container(
                            decoration: BoxDecoration(
                                border:Border.all(color: const Color(0xFFE7E7E7),width: 1),
                                borderRadius: BorderRadius.circular(13),
                                color: const Color(0xFFFAFAFA)
                            ),
                            child: Row(
                              children: [
                                Radio(value: "fun",
                                    groupValue: appController.groupValuePlayFor.value,
                                    onChanged: (val){
                                      setState((){
                                        appController.groupValuePlayFor.value= val as String;
                                      });
                                    }
                                ),
                                const SizedBox(width: 10,),
                                Obx(() => Text(languageController.fun.value))
                              ],
                            ),
                          )),
                          const SizedBox(width: 10,),
                          Expanded(child: Container(
                            decoration: BoxDecoration(
                                border:Border.all(color: const Color(0xFFE7E7E7),width: 1),
                                borderRadius: BorderRadius.circular(13),
                                color: const Color(0xFFFAFAFA)
                            ),
                            child: Row(
                              children: [
                                Radio(value: "prize",
                                    groupValue: appController.groupValuePlayFor.value,
                                    onChanged: (val){
                                      setState((){
                                        appController.groupValuePlayFor.value= val as String;
                                      });
                                    }
                                ),
                                const SizedBox(width: 10,),
                                Obx(() => Text(languageController.prize.value)),
                              ],
                            ),
                          )),
                        ],
                      ),

                      Obx(() => Visibility(
                        visible: appController.groupValuePlayFor.value == "prize" ? true : false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Obx(() => Text(languageController.phone_number.value.toString(), style: const TextStyle(color: commonTextColor,fontSize: 16,fontWeight: FontWeight.w500)),),
                            const SizedBox(height: 11,),
                            SizedBox(
                              height: 54,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: languageController.type.value.toString(),
                                  hintStyle: const TextStyle(color: Color(0xFFAAAAAA),fontWeight: FontWeight.w500,fontSize: 15),
                                  fillColor: const Color(0xFFFAFAFA),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1),
                                  ),
                                ),
                                controller: phoneOrEmailController,
                              ),
                            ),
                          ],
                        ),),
                      ),

                      const SizedBox(height: 10),
                      Obx(() => Center(child: Text(languageController.select.value.toString(), style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: commonTextColor),)),),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 140,
                            width: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFFFAFAFA),
                                border: Border.all(color: primaryColor.withOpacity(.5), width: 1)
                            ),
                            child: Column(
                              children: [
                                Radio(
                                    value: "general",
                                    activeColor: primaryColor,
                                    groupValue: groupValueSelectType,
                                    onChanged: (val){
                                      setState((){
                                        groupValueSelectType=val as String;
                                        showToast(languageController.general.value);
                                      });
                                    }
                                ),
                                const SizedBox(height: 10,),
                                Image.asset("assets/images/general.png",height: 32,width: 60,),
                                const SizedBox(height: 14,),
                                Obx(() => Text(
                                  languageController.general.value,
                                  style: const TextStyle(
                                      color: commonTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),),
                                const SizedBox(height: 10,)
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            height: 140,
                            width: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFFFAFAFA),
                                border: Border.all(color: primaryColor.withOpacity(.5), width: 1)
                            ),
                            child: Column(
                              children: [
                                Radio(
                                    value: "private",
                                    activeColor: primaryColor,
                                    groupValue: groupValueSelectType,
                                    onChanged: (val){
                                      setState((){
                                        groupValueSelectType=val as String;
                                        showToast(languageController.private.value);
                                      });
                                    }
                                ),
                                const SizedBox(height: 10,),
                                Image.asset("assets/images/private.png",height: 32,width: 60,),
                                const SizedBox(height: 14,),
                                Obx(() => Text(
                                  languageController.private.value,
                                  style: const TextStyle(color: commonTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),),
                                const SizedBox(height: 10,)
                              ],
                            ),
                          )
                        ],
                      ),

                      Visibility(
                         visible: groupValueSelectType=="private"?true:false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Obx(() => Text(languageController.no_of_participation.value.toString(),style: const TextStyle(color: commonTextColor,fontSize: 16,fontWeight: FontWeight.w500)),),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 54,
                            child: DropdownButtonFormField(
                              value: participantsValue,
                              decoration: InputDecoration(
                                  filled: true,
                                  hintText: languageController.type.value.toString(),
                                  hintStyle: const TextStyle(color: Color(0xFFAAAAAA),fontWeight: FontWeight.w500,fontSize: 15),
                                  fillColor: const Color(0xFFFAFAFA),
                                  contentPadding: const EdgeInsets.only(left: 10,right: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1)
                                  ),enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE7E7E7),width: 1)
                              )
                              ),
                              onChanged: (value) {
                                setState((){
                                  participantsValue= value;
                                });
                              },
                              items: list.map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                ),)
                              ).toList(),
                            ),
                          ),
                        ],
                      )),

                      const SizedBox(height: 20),
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
                                if(groupValueLeagueType.isEmpty){
                                  showToast(languageController.please_select.value);
                                  return;
                                }
                                if(titleController.text.isEmpty){
                                  showToast(languageController.please_title.value);
                                  return;
                                }
                                if(appController.groupValuePlayFor.value.isEmpty){
                                  showToast(languageController.please_play_for.value);
                                  return;
                                }
                                if(appController.groupValuePlayFor.value=="prize"&&phoneOrEmailController.text.isEmpty){
                                  showToast(languageController.please_phone.value);
                                  return;
                                }
                                if(groupValueSelectType.isEmpty){
                                  showToast(languageController.please_general.value);
                                  return;
                                }
                                if(groupValueSelectType=="private"&&participantsValue==null){
                                  showToast(languageController.please_participants.value);
                                  return;
                                }
                                LoadingProgress.start(context);
                                var league=groupValueLeagueType=="premier"?"39":groupValueLeagueType=="uefa"?"2":"1";
                                var title=titleController.text;
                                var description=descriptionController.text;
                                var playFor=appController.groupValuePlayFor.value;
                                var contact=phoneOrEmailController.text;
                                var participant=groupValueSelectType=="general"?"-1":participantsValue=="Unlimited"?"-1":participantsValue;
                                var joinBy=groupValueSelectType;
                                var response=await sendCreateLeagueRequest(league, title, description, playFor, contact, participant, joinBy);
                                LoadingProgress.stop(context);

                                if(response.statusCode==201){
                                  showToast(languageController.league_successfull.value);
                                  var data=jsonDecode(response.body);
                                  var code=data['data']['code'];
                                  var id=data['data']['id'];
                                  controller.getData(false);
                                  var participant=groupValueSelectType=="general"?"Unlimited":participantsValue=="Unlimited"?"Unlimited":participantsValue;
                                  Navigator.of(context).push(PageTransition(child: ShareLeaguePage(participant: participant, code: code, playfor: 'Play for $playFor', title: title, id: id.toString(),), type: PageTransitionType.rightToLeft));
                                }else{
                                  var data=jsonDecode(response.body);
                                  var message=data['message'];
                                  showToast(message);
                                }


                              }, child: Text(languageController.league_create_upper.value.toString(), style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15)))
                      ),

                      const SizedBox(height: 20,)
                    ],
                  ),
                )

              ],
            ),
          ),
        )
    );
  }
}
