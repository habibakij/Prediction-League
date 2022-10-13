
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import '../../util/constant.dart';

class IntroController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    getLaunchScreedAds();
  }

  RxString lFileName= "".obs;
  var launchScreenResponse= [];
  Future<void> getLaunchScreedAds() async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/ads?type=launch-screen"),
          headers: {
            'Accept': 'application/json',
            'Charset': 'utf-8',
          });
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decode= jsonDecode(response.body);
        launchScreenResponse= decode["data"];
        for (var element in launchScreenResponse) {
          Map map= element;
          lFileName.value= map["file"].toString();
        }
        log("check_launch_response: $lFileName");
      } else {
        log("launch_status_code: ${response.statusCode}, url: ${response.request}");
        showToast("Somethings want wrong, Please try again");
      }
    } catch (_) {
      log("launch_try_error: ${_.toString()}");
      showToast("Internal error occur, Please try again");
    }
  }


}