
import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/common/connectivity_checker.dart';
import 'package:prediction/controller/signup_controller.dart';
import 'package:prediction/pages/setting/privacy_policy_page.dart';
import 'package:prediction/pages/setting/terms_and_service_page.dart';
import 'package:prediction/util/constant.dart';
import 'package:prediction/widget/single_button_widget.dart';
import '../../common/language_controller.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../widget/empty_failure_no_internet_view.dart';
import '../BottomNavigation/bottom_navigation.dart';

class SignUpPage extends StatefulWidget {
  final String id;

  const SignUpPage({Key? key,required this.id}) : super(key: key);

  @override
  State<SignUpPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpPage> {
  var languageController= Get.put(LanguageController());
  TextEditingController dateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final controller=Get.put(SignUpController());
  final internetController=Get.put(ConnectivityCheckerController());
  final formKey=GlobalKey<FormState>();
  var checkbox = false;
  var loading=false;
  var enabled=true;
  bool checkingUserName=false;
  String fullNamePattern = r'^[a-z A-Z,.\-]+$';
  bool conPassword=true;
  bool showPassword=true;
  @override
  void initState() {
    super.initState();
    //controller.getData(true);
    internetController.startMonitoring();
    controller.loadData(true);
  }
  String? validateUserName(String val){
    if(val.isEmpty){
      return languageController.empty_username.value;
    }
    if(!GetUtils.isUsername(val)){
      return languageController.invalid_username.value;
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
  String? validateConfirmPassword(String val,String password){
    if(val.isEmpty){
      return languageController.empty_confirm_password.value;
    }
    if(val!=password){
      return languageController.confirm_not_matched.value;
    }else{
      return null;
    }
  }
  String? validateFullName(String val){
    RegExp regExp = new RegExp(fullNamePattern);
    if (val.isEmpty) {
      return languageController.empty_fullname.value;
    }
    if (!regExp.hasMatch(val)) {
      return languageController.invalid_fullname.value;
    }
    return null;
  }
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
  String? validateDOB(String val){
    if(val.isEmpty){
      return languageController.empty_date.value;
    } else{
      return null;
    }
  }
  String? validateCountry(String val){
    if(val.isEmpty){
      return languageController.empty_country.value;
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
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SafeArea(
              child: Obx((){
                if(controller.loading.value==true){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      Center(child: Text("Preparing form data..."),)
                    ],
                  );
                }
                else if (internetController.isOnline.value == false) {
                  return Center(
                    child: EmptyFailureNoInternetView(
                      image: 'assets/lottie/no_internet_lottie.json',
                      title: 'Internet Error',
                      description: 'Internet not found',
                      buttonText: "Retry",
                      onPressed: () {
                        controller.loadData(true);
                      },
                      status: 1,
                    ),
                  );
                } else if (controller.internetError.value == true) {
                  return Center(
                    child: EmptyFailureNoInternetView(
                      image: 'assets/lottie/no_internet_lottie.json',
                      title: 'Internet Error',
                      description: 'Internet not found',
                      buttonText: "Retry",
                      onPressed: () {
                        controller.loadData(true);
                      },
                      status: 1,
                    ),
                  );
                } else if (controller.serverError.value == true) {
                  return Center(
                    child: EmptyFailureNoInternetView(
                      image: 'assets/lottie/failure_lottie.json',
                      title: 'Server error'.tr,
                      description: 'Please try again later',
                      buttonText: "Retry",
                      onPressed: () {
                        controller.loadData(true);
                      },
                      status: 1,
                    ),
                  );
                } else if (controller.somethingWrong.value == true) {
                  return Center(
                    child: EmptyFailureNoInternetView(
                      image: 'assets/lottie/failure_lottie.json',
                      title: 'Something went wrong',
                      description: 'Please try again later',
                      buttonText: "Retry",
                      onPressed: () {
                        controller.loadData(true);
                      },
                      status: 1,
                    ),
                  );
                }else  if(controller.timeoutError.value==true){
                  return Center(
                    child: EmptyFailureNoInternetView(
                      image: 'assets/lottie/failure_lottie.json',
                      title: 'Timeout',
                      description: 'Please try again',
                      buttonText: "Retry",
                      onPressed: () {
                        controller.loadData(true);
                      },
                      status: 1,
                    ),
                  );
                }else{
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // IconButton(
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //     },
                        //     icon: Icon(
                        //       Icons.arrow_back,
                        //       color: primaryColor,
                        //     )),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: 137,
                              width: 88,
                            )),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() => Text(
                                    languageController.create_account.value.toString(),
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: commonTextColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600)),
                                  ),),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                              Color(0xFF000000).withOpacity(0.15),
                                              offset: Offset(0, 0),
                                              blurRadius: 4)
                                        ]),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: userNameController,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: languageController.username.value.toString(),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey, fontSize: 15),
                                                    contentPadding: EdgeInsets.symmetric(
                                                        horizontal: 0, vertical: 10)
                                                ),
                                                onChanged: (val)async{
                                                  if(GetUtils.isUsername(val)&&val.length>=4){
                                                    setState((){
                                                      checkingUserName=true;

                                                    });
                                                    var response=await sendUserNameCheckRequest(val);
                                                    setState((){
                                                      checkingUserName=false;

                                                    });
                                                    if(response.statusCode==200){


                                                    }else{
                                                      showToast("User name already used");
                                                      setState((){});
                                                    }
                                                  }
                                                },
                                                validator: (val){
                                                  return validateUserName(val!);
                                                },

                                              ),
                                            ),
                                            checkingUserName?SizedBox(width: 10,):SizedBox(),
                                            checkingUserName?SizedBox(height:30,width:30,child: CircularProgressIndicator()):SizedBox()


                                          ],
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                        TextFormField(
                                          controller: fullNameController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: languageController.full_name.value.toString(),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey, fontSize: 15),
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 10)),
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                        // birth date
                                        Container(
                                          height: 45,
                                          alignment: Alignment.centerLeft,
                                          child: TextFormField(
                                            autofocus: false,
                                            readOnly: true,
                                            controller: dateController,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              focusColor: Colors.black,
                                              hintText: 'yyyy-mm-dd',
                                              hintStyle: TextStyle(
                                                  fontSize: 16, color: Colors.grey),
                                            ),
                                            onTap: () {
                                              showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1970),
                                                  lastDate: DateTime(2222))
                                                  .then((date) {
                                                if (date != null) {
                                                  dateController.text = dateFormat.format(date);
                                                }
                                              });
                                            },
                                            validator: (val){
                                              return validateDOB(val!);
                                            },
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                        TextFormField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: languageController.email1.value.toString(),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey, fontSize: 15),
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 10)),
                                          validator: (val){
                                            return validateEmail(val!);
                                          },
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                        TextFormField(

                                          readOnly: true,

                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: languageController.country.value.toString(),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey, fontSize: 15),
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 10)),
                                          onTap: () {
                                            showCountryPicker(
                                              context: context,
                                              showPhoneCode:
                                              true, // optional. Shows phone code before the country name.
                                              onSelect: (Country country) {
                                                var c=controller.list.firstWhere((element) => element.code==country.countryCode);
                                                print(c.id);
                                                controller.countryId.value=c.id.toString();
                                                countryController.text = country.displayName;
                                              },
                                            );
                                          },
                                          controller: countryController,
                                          validator: (val){
                                            return validateCountry(val!);
                                          },
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                        TextFormField(
                                          obscureText: showPassword,
                                          controller: passwordController,
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
                                              hintStyle: TextStyle(
                                                  color: Colors.grey, fontSize: 15),
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 10)),
                                          validator: (val){
                                            return validatePassword(val!);
                                          },
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                        TextFormField(
                                          obscureText: conPassword,
                                          controller: confirmController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: languageController.confirm_password.value.toString(),
                                              suffixIcon: IconButton(
                                                splashRadius: 20,
                                                onPressed: (){
                                                  setState((){
                                                    conPassword=!conPassword;
                                                  });
                                                },
                                                icon: Icon(conPassword?Icons.visibility:Icons.visibility_off),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey, fontSize: 15),
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 10)),
                                          validator: (val){
                                            return validateConfirmPassword(val!, passwordController.text);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Checkbox(
                                          value: checkbox,
                                          activeColor: primaryColor,
                                          onChanged: (val) {
                                            setState(() {
                                              checkbox = val as bool;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text.rich(
                                            TextSpan(text: languageController.by.value.toString(), children: [
                                              TextSpan(
                                                  text: languageController.terms_and_conditions.value.toString(),
                                                  style: TextStyle(color: primaryColor),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () => Navigator.of(context)
                                                        .push(PageTransition(
                                                        child: TermsAndServicePage(id: '1',),
                                                        type: PageTransitionType
                                                            .rightToLeft))),
                                              TextSpan(text: languageController.and.value.toString(),),
                                              TextSpan(
                                                  text: languageController.privacy_policy.value.toString(),
                                                  style: TextStyle(color: primaryColor),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () => Navigator.of(context)
                                                        .push(PageTransition(
                                                        child: PrivacyPolicyPage(id: '2',),
                                                        type: PageTransitionType
                                                            .rightToLeft)))
                                            ])),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SingleButton(title: languageController.sign_up.value.toString(),
                            loading: loading,
                            bgColor: primaryColor,
                            fontSize: 15,
                            textColor: Colors.white,
                            onPress: () async{
                             if(!checkLogin()){
                               return;
                             }

                             setState((){loading=true;enabled=false;});
                             var response=await sendRegisterRequest(
                                 userNameController.text,
                               fullNameController.text,
                               emailController.text,
                                 passwordController.text,
                                 confirmController.text,
                                 controller.countryId.value,
                                 dateController.text,
                                 checkbox?"1":"0"
                             );
                             setState((){loading=false;enabled=true;});
                             if(response.statusCode==201){
                               var data=jsonDecode(response.body);
                               var token=data['data']['bearer_token'];
                               await saveString(TOKEN, token);
                               var user=data['data']['user']['id'];
                               await saveInt(USER, user);
                               showCustomDialog();
                             }else{
                               var data=jsonDecode(response.body);
                               var message=data['message'];
                               showToast(message);

                             }
                            },
                            sideColor: primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  );
                }
              }),
            ),
          ),
        ));
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
                  Text(
                    languageController.sign_up_success.value.toString(),
                    style: toolbarTitleStyle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      languageController.sign_up_success_body.value.toString(),
                      style: TextStyle(
                          color: commonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 13)),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(PageTransition(
                          child: ContainerPage(id: widget.id,),
                          type: PageTransitionType.rightToLeft));
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
