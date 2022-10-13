
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/pages/BottomNavigation/bottom_navigation.dart';
import 'package:prediction/pages/ForgetPassword/forget_password_page.dart';
import 'package:prediction/pages/login/additional_data_page.dart';
import 'package:prediction/pages/signup/signup_page.dart';
import 'package:prediction/util/constant.dart';
import 'package:prediction/widget/single_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/language_controller.dart';
import '../../model/session_list.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
class LoginPage extends StatefulWidget {
  final String id;

  const LoginPage({Key? key,required this.id}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '221421704581-igij50ree878lkh2654vv45dabpmiag3.apps.googleusercontent.com',
    scopes: <String>[
      'email',
    ],
  );

  var languageController= Get.put(LanguageController());
  bool loading=false;
  bool enabled=true;
  bool showPassword=true;
  final fomKey=GlobalKey<FormState>();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  String? validateEmail(String val){
    if(val.isEmpty){
      return languageController.invalid_email_or_username.value;
    }else{
      return null;
    }
  }
  String? validatePassword(String val){
    if(val.isEmpty){
      return languageController.empty_password.value;
    }
    if(val.length<6){
      return languageController.password_invalid.value;
    }else{
      return null;
    }
  }
  bool checkLogin() {
    final isValid = fomKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    fomKey.currentState!.save();
    return true;
  }
  @override
  void initState(){
    super.initState();
    getSeason1();
  }
  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user=_googleSignIn.currentUser;
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: fomKey,
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
                            Obx(() => Text(
                              languageController.welcomeBack.value.toString(),
                              style: const TextStyle(
                                color: commonTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF000000).withOpacity(0.15),
                                    offset: const Offset(0,0),
                                    blurRadius: 4
                                  )
                                ]
                              ),
                              child: Column(
                                children: [
                                  Obx(() => TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: languageController.login_with.value.toString(),
                                        hintStyle: const TextStyle(color: Colors.grey,fontSize: 15),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10)
                                    ),
                                    controller: emailController,
                                    validator: (val) {
                                      return validateEmail(val!);
                                    }
                                  ),),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                  Obx(() => TextFormField(
                                    obscureText: showPassword,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: languageController.password.value.toString(),
                                      suffixIcon: IconButton(
                                        splashRadius: 20,
                                        onPressed: (){
                                          setState((){
                                            showPassword=!showPassword;
                                          });
                                        },
                                        icon: Icon(showPassword?Icons.visibility:Icons.visibility_off),
                                      ),
                                      hintStyle: const TextStyle(color: Colors.grey,fontSize: 15),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                                    ),
                                    controller: passwordController,
                                    validator: (val){
                                      return validatePassword(val!);
                                    },
                                  ),),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Align(alignment: Alignment.centerRight,child: GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(PageTransition(child: ForgetPasswordPage(), type: PageTransitionType.rightToLeft));
                              },
                              child: Obx(() => Text(languageController.forgot_password.value.toString(),style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: Colors.grey.shade900)
                              ),),),
                            ),),
                            const SizedBox(height: 20,),
                           SingleButton(
                              title: languageController.signin.value.toString(),
                              onPress: enabled?()async{languageController.setDetectGuestMode("0");
                              if(!checkLogin()){
                                return;
                              }
                              setState((){loading=true;enabled=false;});
                              var response=await sendLoginRequest(emailController.text, passwordController.text);
                              setState((){loading=false;enabled=true;});
                              if(response.statusCode==200){
                                var data=jsonDecode(response.body);
                                var token=data['data']['bearer_token'];
                                var user=data['data']['user']['id'];

                                await saveString(TOKEN, token);
                                await saveInt(USER, user);
                                Navigator.of(context).pushAndRemoveUntil(PageTransition(child: ContainerPage(id: widget.id,), type: PageTransitionType.fade), (route) => false);
                              }else{
                                var data=jsonDecode(response.body);
                                var message=data['message'];
                                showToast(message);
                              }
                            }:null, bgColor: primaryColor, textColor: Colors.white, loading: loading, sideColor: primaryColor, fontSize: 15,
                            ),

                            SizedBox(height: 30,),
                            Row(
                              children: [
                                Expanded(child: GestureDetector(
                                  onTap:()async{
                                    final googleUser= await _googleSignIn.signIn();
                                    setState(() {
                                      if(googleUser!=null){
                                        user=googleUser;

                                      }
                                    });
                                    if(googleUser==null) return;
                                    LoadingProgress.start(context);
                                    var response=await sendGoogleRequest(user!.email, user!.displayName??"Name", user!.photoUrl??"https://www.google.com", user!.id);
                                    LoadingProgress.stop(context);
                                    if(response.statusCode==201||response.statusCode==200){
                                      var data =jsonDecode(response.body);
                                      var dob=data['data']['user']['dob'];
                                      var token=data['data']['bearer_token'];
                                      var user=data['data']['user']['id'];
                                      if(dob!=null){
                                        await saveString(TOKEN, token);
                                        await saveInt(USER, user);
                                        Navigator.of(context).pushAndRemoveUntil(PageTransition(child: ContainerPage(id: widget.id,), type: PageTransitionType.fade), (route) => false);
                                      }else{
                                        Navigator.of(context).push(PageTransition(child: AdditionalDataPage(token: token, userId: user.toString(), email: googleUser.email, fullname: googleUser.displayName!, id: widget.id,), type: PageTransitionType.rightToLeft));
                                      }
                                    }else{
                                      var data =jsonDecode(response.body);
                                      showToast(data['message']);
                                    }

                                  },
                                  child: Container(

                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Color(0xFFF7F7F7),
                                      border: Border.all(color: Color(0xFFE2E2E2),width: 1)
                                    ),

                                    child: Row(
                                      children: [
                                        Image.asset("assets/images/google.png",height: 20,width: 20,),
                                        SizedBox(width: 18,),
                                        Obx(() => Text(languageController.google.value,style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFB6B6B6),fontWeight: FontWeight.w500,fontSize: 13)),))
                                      ],
                                    ),
                                  ),
                                )),
                                SizedBox(width: 5,),
                                Expanded(child: GestureDetector(
                                  onTap: (){
                                    showToast("Only work with iphone");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Color(0xFFF7F7F7),
                                        border: Border.all(color: Color(0xFFE2E2E2),width: 1)
                                    ),

                                    child: Row(
                                      children: [
                                        Image.asset("assets/images/apple.png",height: 20,width: 20,),
                                        SizedBox(width: 18,),
                                        Obx(() => Text(languageController.apple.value,style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFFB6B6B6),fontWeight: FontWeight.w500,fontSize: 13)),))
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                            SizedBox(height: 25,),
                            Center(child: Obx(() => Text(languageController.dont_account.value.toString(),style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey.shade900)))),)
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Obx(() => SingleButton(
                              title: languageController.create_account.value.toString(),
                              onPress: (){
                              Navigator.of(context).push(PageTransition(child: SignUpPage(id: widget.id,), type: PageTransitionType.rightToLeft));
                            },
                              bgColor: Color(0xFF1A1819),
                              textColor: Colors.white,
                              loading: false,
                              sideColor: Color(0xFF1A1819),
                              fontSize: 15,
                            ),),
                            SizedBox(height: 13),
                            Obx(() => SingleButton(
                              title: languageController.skip.value.toString(),
                              onPress: (){
                                languageController.setDetectGuestMode("1");
                                Navigator.of(context).push(PageTransition(child: ContainerPage(id: widget.id,), type: PageTransitionType.rightToLeft));
                              },
                              bgColor: Colors.white,
                              textColor: Color(0xFF080808),
                              loading: false,
                              sideColor: Color(0xFF1A1819),
                              fontSize: 15,
                            ),),

                            // SingleButton(title: "skip".tr, onPress: (){
                            //   showToast("Under Construction");
                            //  // Navigator.of(context).push(PageTransition(child: ContainerPage(), type: PageTransitionType.rightToLeft));
                            // }, bgColor: Colors.white, textColor: Color(0xFF080808), loading: false, sideColor: Color(0xFF1A1819), fontSize: 15,),

                            SizedBox(height: 10),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    )
    ;
  }
  void getSeason1() async{
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    var response=await http.get(Uri.parse(urlSeasons),headers: headers);
    if(response.statusCode==200){
      var data=jsonDecode(response.body);
      SessionList sessionList=SessionList.fromJson(data);
      var seesion=sessionList.data!.last;

      await saveString(SEASIONID, seesion.id!.toString());

    }else{

    }


  }

}
