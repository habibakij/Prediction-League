import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/util/constant.dart';
import 'package:share_plus/share_plus.dart';

import '../../api_request/dynamic_link_api.dart';

class ShareCupPage extends StatefulWidget {
  final String code;
  final String title;
  final String playfor;
  final String participant;
  final String id;
  final String competitionType;
  const ShareCupPage({Key? key,required this.code,required this.title,required this.playfor,required this.participant,required this.id,required this.competitionType}) : super(key: key);

  @override
  State<ShareCupPage> createState() => _ShareCupPageState();
}

class _ShareCupPageState extends State<ShareCupPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close,color: Color(0xFF000000),),
          ),
          title: Text("share_cup".tr,style: toolbarTitleStyle,),
           centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 29),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Center(child: Image.asset("assets/images/create_cup.png")),
                SizedBox(height: 40,),
                Text("${widget.title}",style: TextStyle(color: commonTextColor,fontSize: 20,fontWeight: FontWeight.w600)),
                SizedBox(height: 6,),
                Text("${widget.competitionType}",style: TextStyle(color: commonTextColor,fontSize: 20,fontWeight: FontWeight.w600)),
                SizedBox(height: 6,),
                Text("invite".tr,style: TextStyle(color: Color(0xFF909090),fontSize: 15,fontWeight: FontWeight.w500)),
                SizedBox(height: 18,),
                SizedBox(
                    width: double.infinity,
                    height: 43,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27)
                            ))
                        ),
                        onPressed: (){

                        }, child: Text("${widget.code}",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15))))
                ),
                SizedBox(height: 64,),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFFAFAFA),
                    border: Border.all(color: Color(0xFFE7E7E7),width: 1)
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 4,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(width: 17,),
                          Text("Play for ${widget.playfor}",style: TextStyle(color: primaryColor,fontSize: 17,fontWeight: FontWeight.w600)),
                          SizedBox(width: 17,),
                          Expanded(
                            child: Divider(
                              thickness: 4,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 4,
                              color: commonTextColor,
                            ),
                          ),
                          SizedBox(width: 17,),
                          Text("private_cup1".tr,style: TextStyle(color: commonTextColor,fontSize: 17,fontWeight: FontWeight.w600)),
                          SizedBox(width: 17,),
                          Expanded(
                            child: Divider(
                              thickness: 4,
                              color: commonTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 4,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(width: 17,),
                          Text("${widget.participant} Participants",style: GoogleFonts.poppins(textStyle: TextStyle(color: primaryColor,fontSize: 17,fontWeight: FontWeight.w600)),),
                          SizedBox(width: 17,),
                          Expanded(
                            child: Divider(
                              thickness: 4,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 109,),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.share,color: Colors.white,),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27)
                            ))
                        ),
                        onPressed: ()async{
                          var link=await DynamicLinksApi().createReferralLink(widget.id, true);
                          await Share.share(link,subject: link);

                        }, label: Text("share".tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15)))
                ),
                SizedBox(height: 6,),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.copy,color: Colors.white,),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(commonTextColor),
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27)
                            ))
                        ),
                        onPressed: (){
                          Clipboard.setData(ClipboardData(text: widget.code));
                          showToast("Code Copied");
                        }, label: Text("copy".tr,style:TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15)))
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
