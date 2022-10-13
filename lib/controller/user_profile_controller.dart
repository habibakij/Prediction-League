import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:prediction/model/player_rank.dart';
import 'package:prediction/model/user_profile_data.dart';
import 'package:prediction/util/country.dart';
import '../util/constant.dart';

class UserProfileController extends GetxController{
  var loading=false.obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  var userProfile=UserProfile().obs;
  var listData=<PlayerRank>[].obs;
  var likes=0.obs;
  var countryFlag="".obs;
  @override
  void onClose(){
    super.onClose();
  }
  void getData(var load,String userId) async{
    print("userId $userId");
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    String token = await getStringPrefs(TOKEN);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await http.get(Uri.parse("$urlUserInfo/$userId"),headers:headers);
      if (response.statusCode == 200) {
        var data=jsonDecode(response.body);
        UserProfileData modelObject = UserProfileData.fromJson(data);
        userProfile.value=modelObject.data!;
        likes.value=userProfile.value.likes!;
        var c=countries.firstWhere((element) => element.code==userProfile.value.country!.code);
        countryFlag.value=c.flag;
        getData1(userId);
      } else if (response.statusCode == 500) {
        loading(false);
       serverError(true);
      } else {
        loading(false);
        somethingWrong(true);
      }
    } on SocketException {
      loading(false);
      internetError(true);
    } on TimeoutException {
      loading(false);
      timeoutError(true);
    } catch (e) {
      loading(false);
      somethingWrong(true);
    }
  }
  void getData1(String userId) async{
    listData.clear();
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    String token = await getStringPrefs(TOKEN);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await http.get(Uri.parse("$urlUserInfo/$userId/leagues"),headers:headers);
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        listData.value = list.map((category) => PlayerRank.fromJson(category)).toList();
        loading(false);
      } else if (response.statusCode == 500) {
        loading(false);
        serverError(true);
      } else {
        loading(false);
        somethingWrong(true);
      }
    } on SocketException {
      loading(false);
      internetError(true);
    } on TimeoutException {
      loading(false);
      timeoutError(true);
    } catch (e) {
      loading(false);
      somethingWrong(true);
    }
  }

}