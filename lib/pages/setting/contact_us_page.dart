import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/common/language_controller.dart';
import 'package:prediction/controller/ad_controller/ads_controller.dart';
import 'package:prediction/util/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../package/slider/carousel_slider.dart';

class ContactUsPage extends StatefulWidget {
  @override
  State<ContactUsPage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<ContactUsPage> {
  var languageController= Get.put(LanguageController());
  final adsController=Get.put(AdsController());
  final nameController=TextEditingController();
  final phoneController=TextEditingController();
  final emailController=TextEditingController();
  final messageController=TextEditingController();
  Future<void> _makeEmail(String email,String query) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: query
    );
    await launchUrl(launchUri);
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
          body: SingleChildScrollView(

            child: Column(
              children: [
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                     Navigator.of(context).pop();
                    }, icon: Icon(Icons.arrow_back,color: primaryColor,),splashRadius: 20,),
                    Obx(() => Text(languageController.contact_us.value.toString(), style: TextStyle(color: Color(0xFF1A1819),fontSize: 12,fontWeight: FontWeight.w600)),),
                    SizedBox(height: 20,width: 70,)
                  ],
                ),
                SizedBox(height: 20,),

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
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 20,),
                        Obx(() => Text(languageController.get_in_touch.value.toString(), style: TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 16)),),
                        SizedBox(height: 12,),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: primaryColor,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.email,color: Colors.white,),
                                  SizedBox(width: 20,),
                                  Text("abcd@gmail.com",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize:12,fontWeight: FontWeight.w500 )),)
                                ],
                              ),
                              SizedBox(height: 24,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() => Text(languageController.follow_us.value.toString(), style: TextStyle(color: Colors.white,fontSize:13,fontWeight: FontWeight.w500 )),),
                                  Row(
                                    children: [
                                      Image.asset("assets/images/facebook.png",height: 14,),
                                      SizedBox(width: 8,),
                                      Image.asset("assets/images/twitter.png",height: 14,),
                                      SizedBox(width: 8,),
                                      Image.asset("assets/images/instagram.png",height: 14,),

                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 31,),
                        Obx(() => Text(languageController.drop_us_a_message.value.toString(), style: TextStyle(color: primaryColor,fontWeight: FontWeight.w600,fontSize: 16)),),
                        SizedBox(height: 18,),
                        Obx(() => Text(languageController.name.value.toString(), style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                        SizedBox(height: 11,),
                        SizedBox(
                          height: 54,
                          child: TextFormField(
                            controller: nameController,
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
                        SizedBox(height: 10,),
                        Obx(() => Text(languageController.phone.value.toString(), style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                        SizedBox(height: 11,),
                        SizedBox(
                          height: 54,
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
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
                        SizedBox(height: 10,),
                        Obx(() => Text(languageController.email1.value.toString(), style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                        SizedBox(height: 11,),
                        SizedBox(
                          height: 54,
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
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

                        SizedBox(height: 10,),
                        Obx(() => Text(languageController.your_message.value.toString(), style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                        SizedBox(height: 11,),
                        SizedBox(
                          height: 54,
                          child: TextFormField(
                            controller: messageController,
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

                        SizedBox(height: 10,),
                        SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ))
                                ),
                                onPressed: (){
                                  if(nameController.text.isEmpty){
                                    showToast("Please enter name");
                                    return;
                                  }
                                  if(phoneController.text.isEmpty){
                                    showToast("Please enter phone");
                                    return;
                                  }
                                  if(emailController.text.isEmpty){
                                    showToast("Please enter email");
                                    return;
                                  }
                                  if(messageController.text.isEmpty){
                                    showToast("Please enter message");
                                    return;
                                  }
                                  var subject="subject=App Feedback&body=${messageController.text}\n name: ${nameController.text}\n phone: ${phoneController.text}\n email: ${emailController.text}";
                                  _makeEmail("lipan@technovicinity.com", subject);
                                }, child: Text(languageController.send.value.toString(), style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15)))
                        ),
                        SizedBox(height: 10,),


                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
