
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/common/language_controller.dart';

import '../../controller/ad_controller/ads_controller.dart';
import '../../util/constant.dart';
import '../../util/expandable_pageview.dart';

class StartRoundPage extends StatefulWidget {
  @override
  State<StartRoundPage> createState() => _StartPredictionPageState();
}

class _StartPredictionPageState extends State<StartRoundPage> {
  var languageController= Get.put(LanguageController());
  final adsController=Get.put(AdsController());
  int index=0;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark),
        child: Scaffold(
          backgroundColor: Colors.white,
            body: ListView(
              padding: EdgeInsets.zero,
          children: [
            Container(
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 61,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.arrow_back,color: primaryColor,),),
                  Text("League Name",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w600)),),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications,
                        color: primaryColor,
                      ))
                ],
              ),
            ),
            /*Image.asset(
              "assets/images/banner.png",
              height: 85,
              width: double.infinity,
              fit: BoxFit.cover,
            ),*/

            //ExpandablePageView(hmm: '',
           // children:adsController.adsWidgetList),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(10, (i) => GestureDetector(
                    onTap: (){
              setState((){
              index=i;
              });
              },
                child: index==i?Container(
                  margin: EdgeInsets.only(right: 3),
                  height: 74,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(8),bottomLeft: Radius.circular(8)),
                    color: primaryColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Round",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 12)),),
                      SizedBox(height: 4,),
                      Text((i+1).toString(),style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20)),),
                      SizedBox(height: 5,),
                      Text("06/09-09/09",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 10)),)
                    ],
                  ),
                ):Container(
                  margin: EdgeInsets.only(right: 3),
                  height: 57,
                  width: 84,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(8),bottomLeft: Radius.circular(8)),
                    color: Color(0xFFF4F4F4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text((i+1).toString(),style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF999999),fontWeight: FontWeight.w700,fontSize: 17)),),
                      SizedBox(height: 5,),
                      Text("06/09-09/09",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF999999),fontWeight: FontWeight.w400,fontSize: 8)),)
                    ],
                  ),
                ),
              )),
              ),
            ),
            SizedBox(height: 15,),
            Center(child: Text("Round Started",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF000000),fontSize: 14,fontWeight: FontWeight.w600)),)),
            Center(child: Text("06/09/2022",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontSize: 18,fontWeight: FontWeight.w600)),)),
            SizedBox(height: 5,),
            Row(
              children: [
                Text(languageController.earned.value.toString(),),
                SizedBox(width: 10,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primaryColor
                  ),
                  child: Center(child: Text("+5 Point"),),
                )
              ],
            ),
            SizedBox(height: 25,),
            ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                itemCount: 2,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    margin: EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF000000).withOpacity(0.08),
                              offset: Offset(0, 1),
                              blurRadius: 8)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Match Status",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 13)),),
                            Row(
                              children: [
                                Image.asset("assets/images/circle.png",height: 16,width: 16,),
                                SizedBox(width: 10,),
                                Text("X2 Pts",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFBEBEBE),fontWeight: FontWeight.w400,fontSize: 13)),),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 29,),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Real Madri",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF424242),fontWeight: FontWeight.w500,fontSize: 12)),),
                                      Text("2ND",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF424242),fontWeight: FontWeight.w500,fontSize: 12)),)


                                    ],
                                  ),
                                  SizedBox(width: 9,),
                                  Image.asset('assets/images/real.png',height: 18,width: 18,)
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 35,
                              width: 47,
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF4F4F4),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide.none
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide.none
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide.none
                                    ),
                                  ),
                              ),
                            ),
                            SizedBox(width: 12,),
                            Text("VS",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF000000),fontWeight: FontWeight.w500,fontSize: 14)),),
                            SizedBox(width: 12,),
                            SizedBox(
                              height: 35,
                              width: 47,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF4F4F4),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide.none
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide.none
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide.none
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Row(

                                children: [
                                  Image.asset('assets/images/barchelona.png',height: 18,width: 18,),
                                  SizedBox(width: 9,),
                                  Column(

                                    children: [
                                      Text("Real Madri",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF424242),fontWeight: FontWeight.w500,fontSize: 12)),),
                                      Text("1 ST",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF424242),fontWeight: FontWeight.w500,fontSize: 12)),)



                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 17,),
                        Text("42% of players are expectiong southamptom to win",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF828282),fontSize: 12,fontWeight: FontWeight.w500)),),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Container(
                              height:41,
                              width: MediaQuery.of(context).size.width*0.285,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(23),bottomLeft: Radius.circular(23)),
                                color: primaryColor
                              ),
                              child: Center(child: Text("42%",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFFFFFFF),fontSize: 13,fontWeight: FontWeight.w600)),)),
                            ),
                            Container(
                              height:41,
                              width: MediaQuery.of(context).size.width*0.285,
                              color: Color(0xFFC3D6DA),
                              child: Center(child: Text("36%",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFFFFFFF),fontSize: 13,fontWeight: FontWeight.w600)),)),
                            ),
                            Container(
                              height:41,
                              width: MediaQuery.of(context).size.width*0.285,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(23),bottomRight: Radius.circular(23)),
                                  color: Color(0xFF1A1819)
                              ),
                              child: Center(child: Text("22%",style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFFFFFFF),fontSize: 13,fontWeight: FontWeight.w600)),)),
                            ),
                          ],
                        ),
                        SizedBox(height: 14,),
                        Container(
                          height: 32,
                          padding: EdgeInsets.symmetric(
                              horizontal: 19, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  topLeft: Radius.circular(16)),
                              color: Color(0xFFF4F4F4)),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Season 21/22",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF535353),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic)),
                              ),
                              Text(
                                "Round 1",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF535353),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })
          ],
        )));
  }
}
