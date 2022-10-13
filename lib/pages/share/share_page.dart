import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/constant.dart';

class SharePage extends StatefulWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
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
          title: Text("share_lower".tr,style: toolbarTitleStyle,),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60,),

                Row(
                  children: [
                    Expanded(child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE7E7E7),width: 1),
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFFAFAFA)
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.email,color: primaryColor,),
                          SizedBox(height: 14,),
                          Text("Email",style: TextStyle(color: commonTextColor,fontWeight: FontWeight.w500,fontSize: 16)),
                          Transform.rotate(
                              angle: 51.8,
                              child: Icon(Icons.arrow_forward_ios,color: primaryColor,))
                        ],
                      ),
                    )),
                    SizedBox(width: 10,),
                    Expanded(child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE7E7E7),width: 1),
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFFAFAFA)
                      ),
                      child: Column(
                        children: [
                          Image.asset("assets/images/whatsapp.png",height: 23,width: 23,),
                          SizedBox(height: 14,),
                          Text("Whatsapp",style: GoogleFonts.poppins(textStyle: TextStyle(color: commonTextColor,fontWeight: FontWeight.w500,fontSize: 16)),),
                          Transform.rotate(
                              angle: 51.8,
                              child: Icon(Icons.arrow_forward_ios,color: primaryColor,))
                        ],
                      ),
                    ))
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE7E7E7),width: 1),
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFFAFAFA)
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.chat,color: primaryColor,),
                          SizedBox(height: 14,),
                          Text("SMS/TEXT",style: GoogleFonts.poppins(textStyle: TextStyle(color: commonTextColor,fontWeight: FontWeight.w500,fontSize: 16)),),
                          Transform.rotate(
                              angle: 51.8,
                              child: Icon(Icons.arrow_forward_ios,color: primaryColor,))
                        ],
                      ),
                    )),
                    SizedBox(width: 10,),
                    Expanded(child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE7E7E7),width: 1),
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFFAFAFA)
                      ),
                      child: Column(
                        children: [
                          Image.asset("assets/images/twitter.png",height: 23,width: 23,color: primaryColor,),
                          SizedBox(height: 14,),
                          Text("Twitter",style: GoogleFonts.poppins(textStyle: TextStyle(color: commonTextColor,fontWeight: FontWeight.w500,fontSize: 16)),),
                          Transform.rotate(
                              angle: 51.8,
                              child: Icon(Icons.arrow_forward_ios,color: primaryColor,))
                        ],
                      ),
                    ))
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
