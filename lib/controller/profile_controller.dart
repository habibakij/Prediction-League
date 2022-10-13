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
import 'package:prediction/model/profile_data.dart';
import '../util/constant.dart';

class ProfileController extends GetxController{
  var loading=false.obs;
  var frontImageSignUp;
  var profileImage="".obs;
  final picker = ImagePicker();
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  final fullNameController=TextEditingController();
  final emailController=TextEditingController();
  final bioController=TextEditingController();
  var joiningDate="".obs;
  var profile=Profile().obs;
  var privateLeagueCount=0.obs;
  var privateCupCount=0.obs;
  var leagueCount=0.obs;
  @override
  void onClose(){
    super.onClose();
    fullNameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }
  void getData(var load) async{
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    String token = await getStringPrefs(TOKEN);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await http.get(Uri.parse("$urlEditProfile"),headers:headers);
      if (response.statusCode == 200) {
        var data=jsonDecode(response.body);
        ProfileData profileData=ProfileData.fromJson(data);
        profile.value=profileData.data!;
        profileImage.value=profileData.data!.profilePicture??"";
        fullNameController.text=profileData.data!.fullName??"Name";
        emailController.text=profileData.data!.email??"abcd@gmail.com";
        var bio=profileData.data!.bio??"Please update bio";
        bioController.text=bio;
        joiningDate.value=profileData.data!.createdAt!;
        joiningDate.value=joiningDate.value.substring(0,10);
        privateLeagueCount.value=profileData.data!.private_leagues_count??0;
        privateCupCount.value=profileData.data!.private_cups_count??0;
        leagueCount.value=profileData.data!.leagues_count??0;
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
  Future<void> getGalleryImageSignUp() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        frontImageSignUp = File(pickedFile.path);
        _cropFrontImage(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    }on PlatformException catch(e){
      if (kDebugMode) {
        print("$e");
      }
    }
    update();
  }
  _cropFrontImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (croppedImage != null) {
      frontImageSignUp = croppedImage;

      update();

    }else{
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }
}