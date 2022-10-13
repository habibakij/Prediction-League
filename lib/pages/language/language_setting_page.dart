import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/pages/login/login_page.dart';
import 'package:prediction/util/constant.dart';

import '../../common/language_controller.dart';

class LanguageSettingPage extends StatefulWidget {
  const LanguageSettingPage({Key? key}) : super(key: key);

  @override
  State<LanguageSettingPage> createState() => _LanguageSettingPageState();
}

class _LanguageSettingPageState extends State<LanguageSettingPage> {

  final languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.white),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 193,),
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 137,
                    width: 88,
                  ),
                ),
                const SizedBox(height: 83),
                Text("choose1".tr,
                  style: const TextStyle(color: Color(0xFF1A1819), fontWeight: FontWeight.w500, fontSize: 20),
                ),
                const SizedBox(height: 3),
                Text("please_select".tr,
                    style: const TextStyle(color: Color(0xFF1A1819), fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(height: 110),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                    ),
                    onPressed: () async {
                      loading();
                      await Future.delayed(const Duration(seconds: 1));
                      languageController.getDynamicTranslatedData("en");
                      await saveBoolean(ISARABIC, false);
                      await saveString(LANGUAGECODE, "en");
                      await saveString(COUNTRYCODE, "US");
                      var locale = const Locale("en", "US");
                      Get.updateLocale(locale);
                      Loader.hide();
                      //await Future.delayed(const Duration(milliseconds: 100));
                      Navigator.of(context).push(PageTransition(child: LoginPage(id: '',), type: PageTransitionType.fade));
                    },
                    child: Text("ENGLISH",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1A1819)),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                    ),
                    onPressed: () async {
                      loading();
                      await Future.delayed(const Duration(seconds: 1));
                      languageController.getDynamicTranslatedData("ar");
                      await saveBoolean(ISARABIC, true);
                      await saveString(LANGUAGECODE, "ar");
                      await saveString(COUNTRYCODE, "SA");
                      var locale = const Locale("ar", "SA");
                      //await Future.delayed(const Duration(milliseconds: 200));
                      Get.updateLocale(locale);
                      Loader.hide();
                      Navigator.of(context).push(PageTransition(child: LoginPage(id: '',), type: PageTransitionType.fade));
                    },
                    child: Text("العربية",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
                        ),
                    ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
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
