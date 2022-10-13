

import 'package:get/get.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/model/chat.dart';

class ChatController extends GetxController{
  var loading=false.obs;
  var list=<Chat>[].obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  var season="".obs;
  var seasonId=0.obs;
  void getData(var load,var leagueId) async {
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    var tempList=<Chat>[];
    try {
      getLeagueChatData(leagueId).then((resp) {
        tempList.addAll(resp.data!);
        list.value=tempList;
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