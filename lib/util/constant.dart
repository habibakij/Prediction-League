import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timeago/timeago.dart' as timeago;
const primaryColor = Color(0xFF42B7B1);
const commonTextColor = Color(0xFF1A1819);
const LANGUAGECODE = "LANGUAGECODE";
const COUNTRYCODE = "COUNTRYCODE";
const ISARABIC = "ISARABIC";
const ISLOCATIONCONFIRM = "ISLOCATIONCONFIRM";
const TOKEN = "TOKEN";
const USER = "USER";
const SEASIONID = "SEASIONID";
const NOTIOFF = "NOTIOFF";

height(BuildContext context,String name){

  return MediaQuery.of(context).size.height*0.2;
}



var toolbarTitleStyle = const TextStyle(
    color: commonTextColor, fontSize: 15, fontWeight: FontWeight.w600);

showToast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}
showLoaderDialog(BuildContext context, String title) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(),
        SizedBox(
          width: 10,
        ),
        Container(margin: EdgeInsets.only(left: 7), child: Text(title)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

bool directionRTL(BuildContext context) {
  return intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
}

Future<void> saveBoolean(String keyword, bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(keyword, value);
}

Future<void> saveString(String keyword, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(keyword, value);
}

Future<void> saveInt(String keyword, int value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(keyword, value);
}

getStringPrefs(String keyword) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString(keyword) ?? "";
}

getIntPrefs(String keyword) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt(keyword) ?? 0;
}

getBooleanPref(String keyword) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool(keyword) ?? false;
}

clearPrefsData() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.clear();
}

saveGPSLocationNCountryCode(String location, String countryCode) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("gpsLocation", location);
  pref.setString("countryCode", countryCode);
  log("location_saved: $location, $countryCode");
}
getSeason(String? year) {
  var preYear=year!.replaceAll("20","");
  var postYear=int.parse(preYear)+1;
  return "$preYear/$postYear";
}
String getTimeAgo(String dateTime){
  DateTime parsedDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(dateTime).toLocal();
  return timeago.format(parsedDateFormat);
}
String getMatchDate(String dateTime){
  DateTime parsedDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(dateTime).toLocal();
  return "Scheduled for ${parsedDateFormat.month}/${parsedDateFormat.month}/${parsedDateFormat.year}";
}

const baseUrl="https://leaguepred.com/api";
const imageBaseUrl="https://leaguepred.com/";
const urlLogin="$baseUrl/login";
const urlRegister="$baseUrl/register";
const urlCountry="$baseUrl/countries";
const urlEditProfile="$baseUrl/account/profile";
const urlChangePassword="$baseUrl/account/password";
const urlGetHome="$baseUrl/api-football/leagues";
const urlGetSettings="$baseUrl/pages";
const urlSubmitPrediction="$baseUrl/predictions";
const urlSubscription="$baseUrl/subscriptions";
const urlRankHome="$baseUrl/paginations/ranks";
const urlCheckUserName="$baseUrl/availability/username";
const urlSeasons="$baseUrl/api-football/seasons";
const urlUserInfo="$baseUrl/paginations/users";
const urlUserLikes="$baseUrl/likings";
const urlDeviceToken="$baseUrl/account/device";
const urlCreateLeague="$baseUrl/custom-football/competitions";
const urlCreateLeague1="$baseUrl/paginations/custom-football/competitions";
const urlNotification="$baseUrl/notifications";
const urlSearch="$baseUrl/custom-football/search";
const urlGLogin="$baseUrl/login/google";
const urlForgetPassword="$baseUrl/password/email";
const urlGetRound="$baseUrl/custom-football";
const urlSettings="$baseUrl/account/settings";


