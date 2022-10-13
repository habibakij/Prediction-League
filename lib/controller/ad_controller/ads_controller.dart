
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../util/constant.dart';

class AdsController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCountryCode();
  }
  String countryCode= "";
  void getCountryCode() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    countryCode = pref.getString("countryCode").toString();
    log("check_country_code: $countryCode");
    getBannerAds();
  }

  String cashImage= "https://cdn.digitalsport.co/wp-content/uploads/2017/05/image001.jpg";
  //String cashImage= "https://cdn.digitalsport.co/wp-content/uploads/2017/05/image001.jpg";
  //String cashImage= "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSS96UV_t62k1ocvK-_dWohSqvVzRhZAHLvA&usqp=CAU";
 // String cashImage= "https://cdn.digitalsport.co/wp-content/uploads/2017/05/image001.jpg";
  /// get banner ads
  RxList fileName= [].obs;
  RxList targetDate= [].obs;
  RxList appearanceTime= [].obs;
  var bannerResponse= [];
  var adsWidgetList=<Widget>[].obs;
  Future<void> getBannerAds() async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/ads?type=banner&country[code]=$countryCode"),
          headers: {
            'Accept': 'application/json',
            'Charset': 'utf-8',
          });
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decode= jsonDecode(response.body);
        fileName.clear();
        targetDate.clear();
        appearanceTime.clear();
        adsWidgetList.clear();
        bannerResponse= decode["data"];
        log("check_banner_response: $bannerResponse");
        for (var element in bannerResponse) {
          Map map= element;
          fileName.add(map["file"].toString());
          targetDate.add(map["ended_at"].toString());
          appearanceTime.add(map["time_of_appearance"]);
        }
//         for(var i=0;i<fileName.length;i++){
//           Widget widget=Container(
//             constraints: BoxConstraints(
//               maxWidth: double.infinity,
//               maxHeight: MediaQuery.of(context).size.height*0.4,
//
//             ),
//             child: Image.network(
//               fileName.isEmpty
//                   ? cashImage
//                   : appearanceTime[i] >=
//                   1
//                   ? "http://167.71.227.239${fileName[i].toString()}"
//                   :cashImage,
// //height: 80,
//               width: double.infinity,
//               fit: BoxFit.fill,
//             ),
//           );
//           adsWidgetList.add(widget);
//         }
//         if(fileName.isEmpty){
//           Widget widget=Container(
//             constraints: BoxConstraints(
//               maxWidth: double.infinity,
//               maxHeight: MediaQuery.of(context).size.height*0.4,
//
//             ),
//             child: Image.network(
//                cashImage,
//
// //height: 80,
//               width: double.infinity,
//               fit: BoxFit.fill,
//             ),
//           );
//           adsWidgetList.add(widget);
//         }
        print("hmm ${adsWidgetList.length}");
        log("check_banner_data: $fileName $targetDate $appearanceTime");
      } else {
        log("banner_status_code: ${response.statusCode}, url: ${response.request}");
        showToast("Somethings want wrong, Please try again");
      }
    } catch (_) {
      log("banner_try_error: ${_.toString()}");
      showToast("Internal error occur, Please try again");
    }
  }

}