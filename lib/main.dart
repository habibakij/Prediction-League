import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:prediction/pages/splash/splash_page.dart';
import 'package:prediction/util/constant.dart';
import 'common/translation_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String languageCode = await getStringPrefs(LANGUAGECODE);
  String countryCode = await getStringPrefs(COUNTRYCODE);
  bool arabic = await getBooleanPref(ISARABIC);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then((val) {
    runApp(MyApp(
      countryCode: countryCode,
      arabic: arabic,
      languageCode: languageCode,
    ));
  });
}

class MyApp extends StatelessWidget {
  String languageCode;
  String countryCode;
  bool arabic;
  MyApp(
      {Key? key,
      required this.arabic,
      required this.countryCode,
      required this.languageCode})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Message(),
      locale: languageCode.isEmpty ? const Locale('en', "US") : Locale(languageCode, countryCode),
      fallbackLocale: languageCode.isEmpty ? const Locale('en', "US") : Locale(languageCode, countryCode),
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: widget!,
        );
      },
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      title: 'Prediction League',
      theme: ThemeData(
          primaryColor: primaryColor,
          fontFamily: languageCode.isEmpty || languageCode == 'ar' ? "Poppins" : "DIN Next LT Arabic"),
      home: SplashPage(),
    );
  }
}
