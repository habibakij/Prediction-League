
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:http/http.dart' as http;
import 'package:prediction/model/session_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:http/http.dart' as http;
import 'package:prediction/util/constant.dart';
import '../model/home.dart';
import '../util/constant.dart';

class HomeController extends GetxController{
  var loading=false.obs;
  var list=<Home>[].obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  var season="".obs;
  var seasonId=0.obs;
  void getData(var load) async {
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    list.clear();
    try {
      getHomeData().then((resp) {
       list.addAll(resp);

       getSeason();
      }, onError: (e) {
        loading(false);
        if (e.toString() == "Exception: internet") {
          internetError(true);
        }
        if (e.toString() == "Exception: something") {
          somethingWrong(true);
        }
        if (e.toString() == "Exception: server") {
          serverError(true);
        }
        if (e.toString() == "Exception: timeout") {
          timeoutError(true);
        } else {
          serverError(true);
        }
      });
    } catch (e) {
      loading(false);
      somethingWrong(true);
    }
  }

  void getSeason() async{
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    var response=await http.get(Uri.parse(urlSeasons),headers: headers);
    if(response.statusCode==200){
      var data=jsonDecode(response.body);
      SessionList sessionList=SessionList.fromJson(data);
      var seesion=sessionList.data!.last;
      seasonId.value=seesion.id!;
      await saveString(SEASIONID, seasonId.value.toString());
      season.value=seesion.year!;
      loading(false);
    }else{
      loading(false);
    }


  }
}