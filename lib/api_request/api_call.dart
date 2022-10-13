import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:prediction/model/chat.dart';
import 'package:prediction/model/cup_detail.dart';
import 'package:prediction/model/home.dart';
import 'package:prediction/model/noti.dart';
import 'package:prediction/model/private_league.dart';
import 'package:prediction/model/private_league_detail.dart';
import 'package:prediction/model/rank.dart';
import 'package:prediction/model/rank_detail.dart';
import 'package:prediction/model/round.dart';
import 'package:prediction/model/search.dart';
import 'package:prediction/model/setting.dart';
import 'package:prediction/model/start_prediction.dart';

import '../model/country.dart';
import '../model/custom_cup.dart';
import '../model/prediction_post_model.dart';
import '../util/constant.dart';

sendLoginRequest(String loginWith, String password) async {
  Map<String, String> headers = {
    'Accept': 'application/json',
  };
  var body = {
    "login_with": loginWith,
    "password": password,
  };
  var response = await http.post(Uri.parse(urlLogin), body: body,headers: headers);
  return response;
}
sendUserNameCheckRequest(String userName) async {
  Map<String, String> headers = {
    'Accept': 'application/json',
  };
  var body = {
    "username": userName,
  };
  var response = await http.post(Uri.parse(urlCheckUserName), body: body,headers: headers);
  return response;
}
sendPredictionRequest(List<PredictionPostModel> list,String radio2X) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body={};

  for(var item in list){
    Map<String, String> postKeyAndValue = {'predictions[${item.id}][goals][${item.ground}]': '${item.value}',};
    body.addAll(postKeyAndValue);
  }
  if(radio2X.isNotEmpty){
    Map<String, String> postKeyAndValue = {'predictions[${radio2X}][multiply_by_two]': '1',};
    body.addAll(postKeyAndValue);
  }

  print(body);

  var response = await http.post(Uri.parse(urlSubmitPrediction), body: body,headers: headers);
  return response;
}
sendSubcrptionRequest(String leagueId,String sessionId) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body={
    "league": leagueId,
    "season": sessionId,
    "type": "league",
  };
  var response = await http.post(Uri.parse(urlSubscription), body: body,headers: headers);
  return response;
}
sendJoinLeagueRequest(String id) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body={
    "competition": id,
    "type": "competition",
  };
  var response = await http.post(Uri.parse(urlSubscription), body: body,headers: headers);
  return response;
}
sendLiking(String userId) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body={
    "type": "like",
    "user": userId,
  };
  var response = await http.post(Uri.parse(urlUserLikes), body: body,headers: headers);
  return response;
}

sendMessage(String message,String leagueId) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body={
    "comment": message,
  };
  var response = await http.post(Uri.parse("$urlCreateLeague/$leagueId/chats"), body: body,headers: headers);
  return response;
}
sendReply(String message,String leagueId,String chatId) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body={
    "comment": message,
    "chat": chatId,
  };
  var response = await http.post(Uri.parse("$urlCreateLeague/$leagueId/chats"), body: body,headers: headers);
  return response;
}
sendForgetPassword(String email) async {
  var languageCode=await getStringPrefs(LANGUAGECODE);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'X-L10n': languageCode
  };
  var body={
    "email": email,
  };
  var response = await http.post(Uri.parse("$urlForgetPassword"), body: body,headers: headers);
  return response;
}
sendRegisterRequest(String username, String fullname,String email,String password,String conPassword,String country,String dob,String termsOfService) async {
  Map<String, String> headers = {
    'Accept': 'application/json',
  };
  var body = {
    "username": username,
    "full_name": fullname,
    "email": email,
    "password": password,
    "password_confirmation": conPassword,
    "country": country,
    "dob": dob,
    "terms_of_service": termsOfService,
  };
  var response = await http.post(Uri.parse(urlRegister), body: body,headers: headers);
  return response;
}
sendGoogleRequest(String email, String fullName,String profilePicture,String provider) async {
  Map<String, String> headers = {
    'Accept': 'application/json',
  };
  var body = {
    "email": email,
    "full_name": fullName,
    "profile_picture": profilePicture,
    "provider": provider,
  };
  print(body);
  var response = await http.post(Uri.parse(urlGLogin), body: body,headers: headers);
  return response;
}

sendAdditionalData(String country, String email,String dob,String username,String token,String fullname) async {

  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body = {
    "username": username,
    "country": country,
    "full_name":fullname,
    "dob": dob,
    "email": email,
    "_method": "put",
  };
  var response = await http.post(Uri.parse(urlEditProfile), body: body,headers: headers);
  return response;
}
Future<dynamic> getCountryData() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlCountry"));
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      CountryData modelObject = CountryData.fromJson(map);
      return modelObject.data!;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
sendUpdateProfile(String fullname, String email, String bio, var profilePicture) async {
  String tok = await getStringPrefs(TOKEN);
  print(bio);
  var formData = FormData();
  formData.fields.add(MapEntry("full_name", fullname));
  formData.fields.add(MapEntry("email", email));
  formData.fields.add(MapEntry("bio", bio));
  formData.fields.add(MapEntry("_method", "put"));
  if (profilePicture != null) {
    formData.files
        .add(MapEntry("profile_picture", await MultipartFile.fromFile(profilePicture.path)));
  }

  try {
    Dio dio = Dio();

    dio.options.headers["Content-Type"] = "application/json, text/plain, */*,'utf-8";
    dio.options.headers["Authorization"] = "Bearer $tok";
    dio.options.headers["Content-Type"] = "multipart/form-data";
    var response = await dio.post(urlEditProfile, data: formData);
    return response;
  } on DioError catch (e) {
    print(e);
  }
}
sendChangedPasswordRequest(String oldPassword, String newPassword,String confirmPassword) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body = {
    "current_password": oldPassword,
    "new_password": newPassword,
    "new_password_confirmation": confirmPassword,
    "_method": "put",
  };
  var response = await http.post(Uri.parse(urlChangePassword), body: body,headers: headers);
  return response;
}
Future sendChangedNotification(String value) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body = {
    "receive_notifications": value,
    "_method": "put",
  };
  var response = await http.post(Uri.parse(urlSettings), body: body,headers: headers);
  return response;
}
Future<dynamic> getHomeData() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlGetHome"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      HomeData modelObject = HomeData.fromJson(map);
      return modelObject.data!;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
Future<NotiData> getNotiData() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlNotification"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      NotiData modelObject = NotiData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
Future<PrivateLeagueData> getPrivateLeague() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlCreateLeague?category=league"),headers: headers);
    if (response.statusCode == 200) {

      var map = json.decode(response.body);
      PrivateLeagueData modelObject = PrivateLeagueData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
Future<CustomCupData> getPrivateCup() async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlCreateLeague?category=cup"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      CustomCupData modelObject = CustomCupData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
Future<PrivateLeagueDetailData> getPrivateLeagueDetail(String id,String page) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlCreateLeague1/$id/competitors?page=$page"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      PrivateLeagueDetailData modelObject = PrivateLeagueDetailData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
Future<CupDetailData> getCupDetail(String id) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlCreateLeague/$id"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      CupDetailData modelObject = CupDetailData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
Future<dynamic> getSettingData(String id) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlGetSettings/$id"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      PageData modelObject = PageData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
Future<StartPredictionData> getStartPredictionData(String leagueId,String sessionId,String roundId,String page) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlGetHome/$leagueId/seasons/$sessionId/rounds/$roundId/fixtures?page=$page"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      StartPredictionData modelObject = StartPredictionData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
Future<RankData> getRankData() async {
  String token = await getStringPrefs(TOKEN);
  String sessionId = await getStringPrefs(SEASIONID);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlRankHome/seasons/$sessionId/leagues"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      RankData modelObject = RankData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
Future<RankDetailData> getRankDetailData(String leagueId,String top) async {
  String token = await getStringPrefs(TOKEN);
  String sessionId = await getStringPrefs(SEASIONID);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlRankHome/seasons/$sessionId/leagues/$leagueId?tops=$top"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      RankDetailData modelObject = RankDetailData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
Future<List<Round>> getRoundData(String leagueId,String session) async {
  String token = await getStringPrefs(TOKEN);
  String sessionId=await getStringPrefs(SEASIONID);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlGetHome/$leagueId/seasons/$sessionId/rounds"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      print(map);
      RoundData modelObject = RoundData.fromJson(map);
      return modelObject.data!;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}

Future<ChatData> getLeagueChatData(String leagueId) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  try {
    final response = await http.get(Uri.parse("$urlCreateLeague/$leagueId/chats"),headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      ChatData modelObject = ChatData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}
updateDeviceToken(String device) async {
  String token = await getStringPrefs(TOKEN);
  if(token.isEmpty){
    return;
  }
  var body = {
    "_method": "put",
    "device_token": device,
    "device_platform": "android",
  };
  print(device);
  Map<String,String> headers = {'Authorization':'Bearer $token'};
  var response = await http.post(Uri.parse("$urlDeviceToken"), headers: headers, body: body);
  return response;
}
sendCreateLeagueRequest(String league,String title,String description,String playFor,String contact,String participant,String joinBy) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body = {
    "league": league,
    "title": title,
    "description": description,
    "play_for": playFor,
    "contact": contact,
    "participants": participant,
    "joined_by": joinBy,
  };
  var response = await http.post(Uri.parse(urlCreateLeague), body: body,headers: headers);
  return response;
}
sendCreateCup(String league,String title,String description,String playFor,String contact,String participant,String joinBy,String type,String round) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body = {
    "league": league,
    "title": title,
    "description": description,
    "play_for": playFor,
    "contact": contact,
    "participants": participant,
    "joined_by": joinBy,
    "type": type,
    "round": round,
  };
  print(body);
  var response = await http.post(Uri.parse(urlCreateLeague), body: body,headers: headers);
  return response;
}

sendUpdateDes(String description,String id) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body = {
    "description": description,
    "_method": "put",
  };
  var response = await http.post(Uri.parse("$urlCreateLeague/$id"), body: body,headers: headers);
  return response;
}
Future<dynamic>getRoundList(String type,String participant,String league,String sessions) async {
  String token = await getStringPrefs(TOKEN);

  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var response = await http.get(Uri.parse("$urlGetRound/leagues/$league/seasons/$sessions/rounds?type=$type&participants=$participant"),headers: headers);
  return response;
}

Future<SearchData> getSearchData(String type,String query) async {
  String token = await getStringPrefs(TOKEN);
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var body={
    "q":query
  };
  try {
    final response = await http.post(Uri.parse("$urlSearch?type=$type"),body: body,headers: headers);
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      SearchData modelObject = SearchData.fromJson(map);
      return modelObject;
    } else if (response.statusCode == 500) {
      throw Exception("server");
    } else {
      throw Exception("something");
    }
  } on SocketException {
    throw Exception("internet");
  } on TimeoutException {
    throw Exception("timeout");
  } catch (e) {
    throw Exception("something");
  }
}