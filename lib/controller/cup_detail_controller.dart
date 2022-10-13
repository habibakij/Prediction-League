import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/model/cup_detail.dart';
import 'package:prediction/model/custom_cup.dart';
import 'package:prediction/model/private_league.dart';

class CupDetailController extends GetxController{
  var loading=false.obs;
  var detailData=CupDetail().obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  var westList=<Fixtures>[];
  var eastList=<Fixtures>[];

  void getData(var load,var id) async {
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);

    try {
      getCupDetail(id).then((resp) {
        detailData.value=resp.data!;
        getEastWest(0);
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

  void getEastWest(int i) {
    westList.clear();
    eastList.clear();
    try {
      if(detailData.value.rounds!.isNotEmpty){
        var m = (detailData.value.rounds![i].fixtures!.length / 2).round();
        westList=detailData.value.rounds![i].fixtures!.sublist(m*0, (0+1)*m <= detailData.value.rounds![0].fixtures!.length ? (0+1)*m : null);
        eastList=detailData.value.rounds![i].fixtures!.sublist(m*1, (1+1)*m <= detailData.value.rounds![0].fixtures!.length ? (1+1)*m : null);
      }
    }catch(e){

    }
  }
}