import 'package:get/get.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/model/rank.dart';
import 'package:prediction/model/rank_detail.dart';

import '../model/home.dart';

class RankDetailController extends GetxController{
  var loading=false.obs;
  var list=<RankDetail>[].obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;

  void getData(var load,var leagueId,var top) async {
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    list.clear();
    try {
      getRankDetailData(leagueId, top).then((resp) {
       list.addAll(resp.data!);
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