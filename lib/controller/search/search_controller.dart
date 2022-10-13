
import 'package:get/get.dart';
import 'package:prediction/api_request/api_call.dart';

import 'package:prediction/model/search.dart';


class SearchController extends GetxController{
  var loading=false.obs;
  var list=<Search>[].obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  var season="".obs;
  var seasonId=0.obs;
  void getData(var load,String type,String query) async {
    print("type $type");
    print("search $query");
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    list.clear();
    try {
      getSearchData(type,query).then((resp) {
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