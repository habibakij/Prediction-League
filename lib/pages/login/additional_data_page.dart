import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/controller/profile_controller.dart';
import 'package:prediction/util/constant.dart';

import '../../common/connectivity_checker.dart';
import '../../common/language_controller.dart';
import '../../controller/signup_controller.dart';
import '../../package/page_transition/enum.dart';
import '../../package/page_transition/page_transition.dart';
import '../../widget/empty_failure_no_internet_view.dart';
import '../../widget/single_button_widget.dart';
import '../BottomNavigation/bottom_navigation.dart';

class AdditionalDataPage extends StatefulWidget {
  final String fullname;
  final String email;
  final String token;
  final String userId;
  final String id;
  const AdditionalDataPage({Key? key,required this.email,required this.fullname,required this.userId,required this.token,required this.id}) : super(key: key);

  @override
  State<AdditionalDataPage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<AdditionalDataPage> {
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
    fullNameController.text=widget.fullname;
    emailController.text=widget.email;
    setState((){});
  }
  String? validateUserName(String val){
    if(val.isEmpty){
      return "Username field is required!";
    }
    if(!GetUtils.isUsername(val)){
      return "Username is invalid";
    }else{
      return null;
    }
  }
  String? validateFullName(String val){
    RegExp regExp = new RegExp(fullNamePattern);
    if (val.isEmpty) {
      return 'Please enter full name';
    }
    if (!regExp.hasMatch(val)) {
      return "Provide valid Full Name";
    }
    return null;
  }
  String? validateEmail(String val){
    if(val.isEmpty){
      return "Email field is required!";
    }
    if(!GetUtils.isEmail(val)){
      return "Email is invalid";
    }else{
      return null;
    }
  }
  String? validateDOB(String val){
    if(val.isEmpty){
      return "Date of birth field is required!";
    } else{
      return null;
    }
  }
  String? validateCountry(String val){
    if(val.isEmpty){
      return "Country field is required!";
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
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: primaryColor,
                            )),
                        SizedBox(
                          height: 20,
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
                                          enabled: false,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: languageController.email.value.toString(),
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

                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
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
                              var response=await sendAdditionalData(
                                  controller.countryId.value,
                                  widget.email,
                                dateController.text,
                                userNameController.text,
                                widget.token,
                                widget.fullname
                              );
                              setState((){loading=false;enabled=true;});
                              if(response.statusCode==200){
                                await saveString(TOKEN, widget.token);
                                await saveInt(USER, int.parse(widget.userId));

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
                      Navigator.of(context).pushAndRemoveUntil(PageTransition(
                          child: ContainerPage(id: widget.id,),
                          type: PageTransitionType.rightToLeft), (route) => false);
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