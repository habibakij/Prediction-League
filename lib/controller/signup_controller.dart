
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/model/country.dart';

class SignUpController extends GetxController{
  var loading=false.obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  var list=<Country>[].obs;
  var countryId="19".obs;
  void loadData(var load){
    loading(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    var list1=<Country>[];

    try{
     getCountryData().then((resp) {
       list1.addAll(resp);
       list.value=list1;
       loading(false);
       },onError: (e){
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
    }catch(e){
      loading(false);
      somethingWrong(false);
    }
  }
}