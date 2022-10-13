import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../util/constant.dart';

class NotificationDetailsController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }

  var loading= false.obs;

  var detailsData= {}.obs;
  RxString detailsTitle= "".obs;
  RxString detailsText= "".obs;
  RxString detailsRead= "".obs;
  RxString detailsCreate= "".obs;
  Future<void> notificationDetailsData(String notificationId, var loadingState) async {
    try{
      loading.value= loadingState;
      String token = await getStringPrefs(TOKEN);
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      final response = await http.get(Uri.parse("$urlNotification/$notificationId"),headers: headers);
      if(response.statusCode == 200 || response.statusCode == 201){
        loading.value= false;
        var decode= jsonDecode(response.body);
        detailsData.value= decode["data"];
        detailsRead.value= decode["read_at"];
        detailsCreate.value= decode["created_at"];
        detailsTitle.value= detailsData["title"];
        detailsText.value= detailsData["text"];
        log("check_response_data: $detailsTitle $detailsText $detailsRead $detailsCreate");
      } else if(response.statusCode == 500) {
        loading.value= false;
        showToast("Server error");
      } else {
        loading.value= false;
        showToast("Internal error occur, Please try again");
      }
    }catch(exception){
      loading.value= false;
      log("check_details: $exception");
      showToast("Somethings want wrong, Please try again");
    }
  }

}