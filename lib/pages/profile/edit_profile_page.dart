import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/controller/ad_controller/ads_controller.dart';
import 'package:prediction/controller/profile_controller.dart';
import 'package:prediction/util/constant.dart';

import '../../common/language_controller.dart';
import '../../package/slider/carousel_slider.dart';
import '../../widget/single_button_widget.dart';

class EditProfilePage extends StatefulWidget {

  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final formKey=GlobalKey<FormState>();
  final lanController=Get.put(LanguageController());
  final controller=Get.put(ProfileController());
  var loading=false;
  var enabled=true;
  final adsController=Get.put(AdsController());
  String fullNamePattern = r'^[a-z A-Z,.\-]+$';
  String? validateFullName(String val){
    RegExp regExp = new RegExp(fullNamePattern);
    if (val.isEmpty) {
      return lanController.empty_fullname.value;
    }
    return null;
  }
  String? validateEmail(String val){
    if(val.isEmpty){
      return lanController.empty_email.value;
    }
    if(!GetUtils.isEmail(val)){
      return lanController.invalid_email.value;
    }else{
      return null;
    }
  }
  String? validateBio(String val){
    if(val.isEmpty){
      return lanController.empty_bio.value;
    } else{
      return null;
    }
  }
  bool checkLogin() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    formKey.currentState!.save();
    return true;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lanController.getLang();
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
                SizedBox(height: 39.5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                       Navigator.of(context).pop();
                      }, icon: Icon(Icons.arrow_back,color: primaryColor,),),
                      Row(
                        children: [
                          Image.asset("assets/images/edit.png",height: 17,width: 17,),
                          SizedBox(width: 10,),
                          Obx(() => Text(lanController.edit_profile.value,style: TextStyle(color: Color(0xFF1A1819),fontSize: 12,fontWeight: FontWeight.w600)),)
                        ],
                      ),
                      SizedBox(height: 20,width: 70,)
                    ],
                  ),
                ),
                const SizedBox(height: 20,),


                SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              SizedBox(height: 30,),
                              Center(
                                child: SizedBox(
                                  height: 124,
                                  width: 124,
                                  child: Stack(
                                    children: [
                                      GetBuilder<ProfileController>(
                                        builder: (_) {
                                          return controller.frontImageSignUp != null
                                              ? CircleAvatar(
                                              radius: 60,
                                              child: ClipOval(
                                                child: Image.file(
                                                  File(controller.frontImageSignUp!.path),
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.fill,
                                                ),
                                              ))
                                              :controller.profileImage.isNotEmpty? CircleAvatar(
                                              radius: 60,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  height: 120,
                                                  width: 120,
                                                  imageUrl: "${controller.profileImage.value}",
                                                  placeholder: (context, url) => Container(
                                                      height: 120,
                                                      width: 120,
                                                      color: Colors.grey[300],
                                                      child: const Icon(Icons.image,)),
                                                  errorWidget: (context, url, error) => CircleAvatar(
                                                    backgroundImage: AssetImage("assets/images/profile_image.png"),),
                                                ),))
                                              :CircleAvatar(
                                            radius: 60,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: AssetImage("assets/images/profile_image.png"),


                                          );
                                        },
                                      ),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                              onTap: (){
                                                controller.getGalleryImageSignUp();
                                              },
                                              child: CircleAvatar(backgroundColor:Colors.white,radius:20,child: Icon(Icons.edit,color: primaryColor,))))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Obx(() => Text(lanController.full_name.value,style:TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                              SizedBox(height: 11,),
                              Obx(() => TextFormField(
                                controller: controller.fullNameController,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: lanController.type.value,
                                    hintStyle: TextStyle(color: Color(0xFFAAAAAA),fontWeight: FontWeight.w500,fontSize: 15),
                                    fillColor: Color(0xFFFAFAFA),
                                    contentPadding: EdgeInsets.all(14),
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
                                validator: (val){
                                  return validateFullName(val!);
                                },
                              ),),
                              SizedBox(height: 10),
                              Obx(() => Text(lanController.email_without_star.value,style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                              SizedBox(height: 11,),
                              Obx(() => TextFormField(
                                controller: controller.emailController,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: lanController.type.value,
                                    contentPadding: EdgeInsets.all(14),
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
                                validator: (val){
                                  return validateEmail(val!);
                                },
                              ),),

                              SizedBox(height: 10),
                              Obx(() => Text(lanController.bio.value,style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                              SizedBox(height: 11,),
                              Obx(() => TextFormField(
                                controller: controller.bioController,
                                maxLines: 5,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    filled: true,

                                    hintText: lanController.type.value,
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
                              ),),

                              SizedBox(height: 15,),
                              Obx(() => SingleButton(title: lanController.update_details.value,
                                loading: loading,
                                bgColor: primaryColor,
                                fontSize: 15,
                                textColor: Colors.white,
                                onPress: () async{
                                  if(!checkLogin()){
                                    return;
                                  }

                                  setState((){loading=true;enabled=false;});
                                  var response=await sendUpdateProfile(
                                      controller.fullNameController.text,
                                      controller.emailController.text,
                                      controller.bioController.text,
                                      controller.frontImageSignUp
                                  );
                                  setState((){loading=false;enabled=true;});
                                  if(response.statusCode==200){
                                    controller.getData(false);
                                    showCustomDialog();
                                  }else{
                                    var data=jsonDecode(response.body);
                                    var message=data['message'];
                                    showToast(message);

                                  }
                                },
                                sideColor: primaryColor,
                              ),),
                              SizedBox(height: 10),


                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30,)
              ],
            ),
          ),
        )
    );
  }
  showCustomDialog() {
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
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() => Text(
                    lanController.profile_updated.value,
                    style: toolbarTitleStyle,
                  ),),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() => Text(lanController.profile_updated_successful.value,
                      style: TextStyle(
                          color: commonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 13)),),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.getData(false);
                      Navigator.of(context,rootNavigator: true).pop();
                      

                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                        backgroundColor:
                        MaterialStateProperty.all(primaryColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(()=>Text(lanController.ok.value,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),)
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        });
  }
}
