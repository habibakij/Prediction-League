import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/controller/ad_controller/ads_controller.dart';
import 'package:prediction/util/constant.dart';

import '../../common/language_controller.dart';
import '../../package/slider/carousel_slider.dart';
import '../../widget/single_button_widget.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<ChangePasswordPage> {
  final formKey=GlobalKey<FormState>();
  final oldController=TextEditingController();
  final newController=TextEditingController();
  final confirmController=TextEditingController();
  final lanController=Get.put(LanguageController());
  var loading=false;
  var enabled=true;
  bool oldPassword=true;
  bool newPassword=true;
  bool confirmPassword=true;
  final adsController=Get.put(AdsController());
  String? validateOldPassword(String val){
    if(val.isEmpty){
      return lanController.old_password.value;
    }
    if(val.length<6){
      return lanController.password_invalid.value;
    }else{
      return null;
    }
  }
  String? validateNewPassword(String val){
    if(val.isEmpty){
      return lanController.new_password.value;
    }
    if(val.length<6){
      return lanController.password_invalid.value;
    }else{
      return null;
    }
  }
  String? validateConfirmPassword(String val,String password){
    if(val.isEmpty){
      return lanController.empty_confirm_password.value;
    }
    if(val!=password){
      return lanController.confirm_not_matched.value;
    }else{
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
  void dispose(){
    super.dispose();
    oldController.dispose();
    newController.dispose();
    confirmController.dispose();
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
          body: Column(
            children: [
              SizedBox(height: 40,),
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
                        Image.asset("assets/images/lock.png",height: 17,width: 17,),
                        SizedBox(width: 10,),
                        Obx(() => Text(lanController.change_password.value,style:TextStyle(color: Color(0xFF1A1819),fontSize: 12,fontWeight: FontWeight.w600)),)
                      ],
                    ),
                    SizedBox(height: 20,width: 70,)
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
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
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 27),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(lanController.old_password_hint.value,style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                              SizedBox(height: 11,),
                              TextFormField(
                                controller: oldController,
                                obscureText: oldPassword,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: lanController.type.value,
                                    suffixIcon: IconButton(
                                      splashRadius: 20,
                                      onPressed: (){
                                        setState((){
                                          oldPassword=!oldPassword;
                                        });
                                      },
                                      icon: Icon(oldPassword?Icons.visibility:Icons.visibility_off),
                                    ),
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
                                  return validateOldPassword(val!);
                                },
                              ),
                              SizedBox(height: 39,),
                              Obx(() => Text(lanController.new_password_hint.value,style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                              SizedBox(height: 11,),
                              TextFormField(
                                controller: newController,
                                obscureText: newPassword,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: lanController.type.value,
                                    suffixIcon: IconButton(
                                      splashRadius: 20,
                                      onPressed: (){
                                        setState((){
                                          newPassword=!newPassword;
                                        });
                                      },
                                      icon: Icon(newPassword?Icons.visibility:Icons.visibility_off),
                                    ),
                                    hintStyle:TextStyle(color: Color(0xFFAAAAAA),fontWeight: FontWeight.w500,fontSize: 15),
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
                                  return validateNewPassword(val!);
                                },
                              ),

                              SizedBox(height: 39,),
                              Obx(() => Text(lanController.confirm_new_password_hint.value,style: TextStyle(color: Color(0xFF1A1819),fontSize: 16,fontWeight: FontWeight.w500)),),
                              SizedBox(height: 11,),
                              TextFormField(
                                controller: confirmController,
                                obscureText: confirmPassword,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: lanController.type.value,
                                    suffixIcon: IconButton(
                                      splashRadius: 20,
                                      onPressed: (){
                                        setState((){
                                          confirmPassword=!confirmPassword;
                                        });
                                      },
                                      icon: Icon(confirmPassword?Icons.visibility:Icons.visibility_off),
                                    ),
                                    hintStyle:  TextStyle(color: Color(0xFFAAAAAA),fontWeight: FontWeight.w500,fontSize: 15),
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
                                  return validateConfirmPassword(val!, newController.text);
                                },
                              ),

                              SizedBox(height: 50,),
                              Obx(() => SingleButton(title: lanController.change_password_upper.value,
                                loading: loading,
                                bgColor: primaryColor,
                                fontSize: 15,
                                textColor: Colors.white,
                                onPress: enabled?() async{
                                  if(!checkLogin()){
                                    return;
                                  }

                                  setState((){loading=true;enabled=false;});
                                  var response=await sendChangedPasswordRequest(
                                    oldController.text,
                                    newController.text,
                                    confirmController.text,
                                  );
                                  setState((){loading=false;enabled=true;});
                                  if(response.statusCode==200){
                                    showCustomDialog();
                                  }else{
                                    var data=jsonDecode(response.body);
                                    var message=data['message'];
                                    showToast(message);

                                  }
                                }:null,
                                sideColor: primaryColor,
                              ),)

                            ],
                          ),
                        ),
                        SizedBox(height: 40,)


                      ],
                    ),
                  ),
                ),
              )
            ],
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
                    lanController.password_changed.value,
                    style: toolbarTitleStyle,
                  ),),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() => Text(lanController.password_changed_successfully.value,
                      style: TextStyle(
                          color: commonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 13)),),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
