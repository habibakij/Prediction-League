import 'package:get/get.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/model/rank.dart';

import '../model/home.dart';

class RankController extends GetxController{
  var loading=false.obs;
  var list=<Rank>[].obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;

  void getData(var load) async {
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    var list1=<Rank>[];
    try {
      getRankData().then((resp) {

       list1.addAll(resp.data!);
       list.value=list1;
       loading(false);
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
}