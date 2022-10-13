import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:prediction/api_request/api_call.dart';

import '../../common/language_controller.dart';
import '../../util/constant.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final emailContrller=TextEditingController();
  var languageController= Get.put(LanguageController());
  final formKey=GlobalKey<FormState>();

  String? validateEmail(String val){
    if(val.isEmpty){
      return languageController.empty_email.value;
    }
    if(!GetUtils.isEmail(val)){
      return languageController.invalid_email.value;
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
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, icon: Icon(Icons.arrow_back,color: primaryColor,)),
                      SizedBox(height: 20,),
                      Center(child: Image.asset("assets/images/logo.png",height: 137,width: 88,)),
                      SizedBox(height: 25,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("forget_password".tr,style: TextStyle(color: commonTextColor,fontSize: 20,fontWeight: FontWeight.w600)),
                            SizedBox(height: 15,),
                            Text("forget_title".tr,style: TextStyle(color: commonTextColor.withOpacity(0.5),fontSize: 15,fontWeight: FontWeight.w600)),
                            SizedBox(height: 30,),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFF000000).withOpacity(0.15),
                                        offset: Offset(0,0),
                                        blurRadius: 4
                                    )
                                  ]
                              ),
                              child: Column(
                                children: [
                                  TextFormField(

                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "enter_email".tr,
                                        hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 10)
                                    ),
                                    validator: (val){
                                      return validateEmail(val!);
                                    },
                                    controller: emailContrller,
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 50,),

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
                                      if(!checkLogin()){
                                        return;
                                      }
                                     LoadingProgress.start(context);
                                      var response=await sendForgetPassword(emailContrller.text);
                                      LoadingProgress.stop(context);
                                      if(response.statusCode==200){
                                        showCustomDialog();
                                      }else{
                                        var data=jsonDecode(response.body);
                                        var message=data['message'];
                                        showToast(message);
                                      }
                                    }, child: Text("send_password".tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15)))
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
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
                    languageController.forget_title.value.toString(),
                    style: toolbarTitleStyle,
                  ),),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() => Text(
                      languageController.forget_body.value.toString(),
                      style: TextStyle(
                          color: commonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 13)),),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() => Text(
                      languageController.forget_bottom.value.toString(),
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
                      child: Text(
                          languageController.ok.value.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
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
