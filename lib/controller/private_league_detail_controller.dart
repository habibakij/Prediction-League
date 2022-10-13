import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/model/private_league.dart';
import 'package:prediction/model/private_league_detail.dart';

import '../package/smart_refresher/smart_refresher.dart';

class PrivateLeagueDetailController extends GetxController{
  var loading=false.obs;
  var list=<PrivateLeagueDetail>[].obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  var pageCount=0.obs;
  var page=1.obs;
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void onClose(){
    super.onClose();
    refreshController.dispose();

  }
  void getData(var load,String leagueId,String pageNumber,bool refresh) async {
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    try {
      getPrivateLeagueDetail(leagueId,pageNumber.toString()).then((resp) {

        pageCount.value=resp.meta!.lastPage!;
        if(refresh){
          page.value=1;
        }else{
          if(pageCount.value!=0){
            if(page.value-1>=pageCount.value){
              refreshController.loadNoData();

            }
          }
        }

        if(resp.data!.isEmpty){
          refreshController.loadNoData();
          loading(false);
          return;
        }

        if(refresh){
          list.value=resp.data!;
          refreshController.refreshToIdle();
        }else{
          list.addAll(resp.data!);
          refreshController.loadComplete();
        }
        print(page.value);
        page.value++;
        loading(false);
      }, onError: (e) {
        print(e.toString());
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