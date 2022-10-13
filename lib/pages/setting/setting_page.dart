
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/common/language_controller.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/pages/login/login_page.dart';
import 'package:prediction/pages/setting/about_us_page.dart';
import 'package:prediction/pages/setting/contact_us_page.dart';
import 'package:prediction/pages/setting/privacy_policy_page.dart';
import 'package:prediction/pages/setting/terms_and_service_page.dart';
import 'package:prediction/util/constant.dart';

import '../../controller/ad_controller/ads_controller.dart';
import '../../package/slider/carousel_slider.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool noti = false;
  bool lang = false;
  final languageController = Get.put(LanguageController());
  GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '221421704581-igij50ree878lkh2654vv45dabpmiag3.apps.googleusercontent.com',
    scopes: <String>[
      'email',
    ],
  );
  final adsController = Get.put(AdsController());
  @override
  void initState() {
    super.initState();
    languageController.getLang();
    languageController.detectGuestMode();
    getData();
  }

  getData() async {
    lang = await getBooleanPref(ISARABIC);
    noti=await getBooleanPref(NOTIOFF);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Obx(() => Text(
            languageController.settings.value.toString(),
            style: TextStyle(
                color: commonTextColor,
                fontWeight: FontWeight.w600,
                fontSize: lang ? 20 : 14)),),
        SizedBox(
          height: 30,
        ),
        Expanded(
            child: ListView(
          padding: EdgeInsets.zero,
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
                          /*if(adsController.appearanceTime.isNotEmpty){
                            if(adsController.appearanceTime[index] == 0){
                              adsController.fileName.removeAt(index);
                            } else {
                              adsController.appearanceTime[index]--;
                            }
                          }
                          log("check_index: ${appController.appearanceTime[index]}");*/
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
                            adsController.fileName.isEmpty ? adsController.cashImage : adsController.appearanceTime[index] >= 0 ?
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
            Container(
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xFFFFFFFF),
                  border: Border.all(color: Color(0xFFDFDFDF), width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                      languageController.language.value.toString(),
                      style: TextStyle(
                          color: commonTextColor,
                          fontSize: lang ? 20 : 13,
                          fontWeight: FontWeight.w600)),),
                  Row(
                    children: [
                      Obx(
                        () => Text(languageController.arabic.value ? "Ar" : "En",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      FlutterSwitch(
                        switchBorder: Border.all(color: Color(0xFFE8E8E8), width: 1),
                        width: 60.0,
                        height: 30.0,
                        toggleSize: 30.0,
                        activeColor: Color(0xFFF5F5F5),
                        inactiveColor: Color(0xFFF5F5F5),
                        toggleColor: primaryColor,
                        value: lang,
                        borderRadius: 18.0,
                        padding: 1.0,
                        showOnOff: false,
                        onToggle: (val) async {
                          lang = val;

                          loading();
                          await saveBoolean(ISARABIC, val);
                          languageController.arabic.value = val;
                          languageController.getLang();
                          if (val == false) {

                            await Future.delayed(const Duration(seconds: 1));
                            languageController.getDynamicTranslatedData("en");

                            await saveString(LANGUAGECODE, "en");
                            await saveString(COUNTRYCODE, "US");
                            var locale = const Locale("en", "US");
                            Get.updateLocale(locale);
                            Loader.hide();

                          } else {


                            await Future.delayed(const Duration(seconds: 1));
                            languageController.getDynamicTranslatedData("ar");

                            await saveString(LANGUAGECODE, "ar");
                            await saveString(COUNTRYCODE, "SA");
                            var locale = const Locale("ar", "SA");
                            Get.updateLocale(locale);
                            Loader.hide();


                          }
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Obx(() => Text(!languageController.arabic.value ? "Ar" : "En",
                          style: TextStyle(
                              color: Color(0xFF969696),
                              fontSize: 13,
                              fontWeight: FontWeight.w600)))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xFFFFFFFF),
                  border: Border.all(color: Color(0xFFDFDFDF), width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                      languageController.notification.value.toString(),
                      style: TextStyle(
                          color: commonTextColor,
                          fontSize: lang ? 20 : 13,
                          fontWeight: FontWeight.w600)),),
                  Row(
                    children: [
                      Text(
                        "On",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFF969696),
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      FlutterSwitch(
                        switchBorder:
                            Border.all(color: Color(0xFFE8E8E8), width: 1),
                        width: 60.0,
                        height: 30.0,
                        toggleSize: 30.0,
                        activeColor: Color(0xFFF5F5F5),
                        inactiveColor: Color(0xFFF5F5F5),
                        toggleColor: primaryColor,
                        value: noti,
                        borderRadius: 18.0,
                        padding: 1.0,
                        showOnOff: false,
                        onToggle: (val) async{
                          setState(() {
                            noti = val;

                          });
                          loading();
                          await saveBoolean(NOTIOFF, true);
                          await sendChangedNotification(noti==true?"0":"1").then((value){
                            Loader.hide();
                          });

                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Off",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFF969696),
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xFFFFFFFF),
                  border: Border.all(color: Color(0xFFDFDFDF), width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                      languageController.privacy_policy.value.toString(),
                      style: TextStyle(
                          color: commonTextColor,
                          fontSize: lang ? 20 : 13,
                          fontWeight: FontWeight.w600)),),
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: Obx(
                        () => IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).push(PageTransition(
                                  child: PrivacyPolicyPage(id: '2',),
                                  type: PageTransitionType.rightToLeft));
                            },
                            icon: Transform.rotate(
                                angle: languageController.arabic.value ? 53.4 : 0,
                                child: SvgPicture.asset(
                                  "assets/images/right_arrow.svg",
                                  height: 20,
                                  color: primaryColor,
                                ))),
                      ))
                ],
              ),
            ),

            SizedBox(
              height: 12,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xFFFFFFFF),
                  border: Border.all(color: Color(0xFFDFDFDF), width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                      languageController.terms_and_conditions.value.toString(),
                      style: TextStyle(
                          color: commonTextColor,
                          fontSize: lang ? 20 : 13,
                          fontWeight: FontWeight.w600)),),
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: Obx(
                            () => IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).push(PageTransition(
                                  child: TermsAndServicePage(id: '1',),
                                  type: PageTransitionType.rightToLeft));
                            },
                            icon: Transform.rotate(
                                angle: languageController.arabic.value ? 53.4 : 0,
                                child: SvgPicture.asset(
                                  "assets/images/right_arrow.svg",
                                  height: 20,
                                  color: primaryColor,
                                ))),
                      ))
                ],
              ),
            ),

            SizedBox(
              height: 12,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xFFFFFFFF),
                  border: Border.all(color: Color(0xFFDFDFDF), width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                      languageController.about_us.value.toString(),
                      style: TextStyle(
                          color: commonTextColor,
                          fontSize: lang ? 20 : 13,
                          fontWeight: FontWeight.w600)),),
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: Obx(
                            () => IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).push(PageTransition(
                                  child: AboutUsPage(id: '4',),
                                  type: PageTransitionType.rightToLeft));
                            },
                            icon: Transform.rotate(
                                angle: languageController.arabic.value ? 53.4 : 0,
                                child: SvgPicture.asset(
                                  "assets/images/right_arrow.svg",
                                  height: 20,
                                  color: primaryColor,
                                ))),
                      ))
                ],
              ),
            ),

            SizedBox(
              height: 12,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xFFFFFFFF),
                  border: Border.all(color: Color(0xFFDFDFDF), width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                      languageController.contact_us.value.toString(),
                      style: TextStyle(
                          color: commonTextColor,
                          fontSize: lang ? 20 : 13,
                          fontWeight: FontWeight.w600)),),
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: Obx(
                            () => IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).push(PageTransition(
                                  child: ContactUsPage(),
                                  type: PageTransitionType.rightToLeft));
                            },
                            icon: Transform.rotate(
                                angle: languageController.arabic.value ? 53.4 : 0,
                                child: SvgPicture.asset(
                                  "assets/images/right_arrow.svg",
                                  height: 20,
                                  color: primaryColor,
                                ))),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Obx(() => Visibility(
              visible: languageController.isGuestMode.value == "1" ? false : true,
              child: Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton.icon(
                      icon: Image.asset(
                        "assets/images/logout.png",
                        height: 14,
                        width: 14,
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27)))),
                      onPressed: () {
                        showDialog(context: context, builder: (context){
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Are you sure you want to logout?",),
                                  SizedBox(height: 30,),
                                  Row(
                                    children: [
                                      Expanded(child: ElevatedButton(

                                        onPressed: (){
                                          Navigator.of(context,rootNavigator: true).pop();
                                        },
                                        child: Text("Cancel",style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white,fontSize: 14),)),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xFF262324)
                                        ),
                                      )),
                                      SizedBox(width: 10,),
                                      Expanded(child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xFF77CEDA)
                                        ),
                                        onPressed: ()async{

                                          _googleSignIn.signOut();
                                          languageController.setDetectGuestMode("0");
                                          await saveString(TOKEN, "");
                                          Navigator.of(context,rootNavigator: true).pop();
                                          Navigator.of(context,rootNavigator: true).pushAndRemoveUntil(PageTransition(child: LoginPage(id: '',), type: PageTransitionType.fade), (route) => false);
                                        },
                                        child: Text("Yes",style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white,fontSize: 14),)),
                                      )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });

                      },
                      label: Text(
                          languageController.logout.value.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: lang ? 22 : 15)))),
            ),),

            SizedBox(
              height: 22,
            ),
            Obx(() => Text(
              languageController.version.value.toString(),
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: lang ? 19 : 13),
              textAlign: TextAlign.center,
            ),),
            SizedBox(height: 10),
          ],
        ))
      ],
    );
  }

  void loading(){
    Loader.show(context,
        isSafeAreaOverlay: false,
        isBottomBarOverlay: false,
        overlayFromBottom: 0,
        overlayFromTop: 0,
        overlayColor: Colors.black26,
        progressIndicator: const CircularProgressIndicator(backgroundColor: Colors.red),
        themeData: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green))
    );
  }
}
