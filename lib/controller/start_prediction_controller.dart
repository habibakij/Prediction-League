import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/model/start_prediction.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../model/round.dart';
import '../package/smart_refresher/smart_refresher.dart';

class StartPredictionController extends GetxController{
  var loading=false.obs;
  var loading1=false.obs;
  var list=<StartPrediction>[].obs;
  var roundList=<Round>[].obs;
  var internetError=false.obs;
  var somethingWrong=false.obs;
  var serverError=false.obs;
  var timeoutError=false.obs;
  var pageCount=0.obs;
  var page=1.obs;
  var radioValue="0".obs;
  var startTeamName="".obs;
  var changeable=true.obs;
  var initRoundId=0.obs;
  var timeLineStatus="Time not Found".obs;
  var timeLineStatusTitle="Round".obs;
  var showAlart=false.obs;
  Map<String, dynamic> mainList = <String, dynamic>{};
  Map<String, dynamic> mainFocusList = <String, dynamic>{};
  Map<String, dynamic> mainRadioList = <String, dynamic>{};
  RxInt index = 0.obs;
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final ItemScrollController itemScrollController = ItemScrollController();
  @override
  void onClose(){
    super.onClose();
    refreshController.dispose();

  }
  void loadRound(leagueId, sessionId) {
    loading(true);
    loading1(true);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    roundList.clear();
    print(leagueId);
    print(sessionId);
    try {
      getRoundData(leagueId, sessionId).then((resp) {
        roundList.addAll(resp);
        //selected index
        for(var i=0;i<roundList.length; i++){
          if(roundList[i].current_round==true){
            index.value=i;
          }

        }
        var contain=roundList.where((element) => element.current_round==true).toList();
        var roundIndex=roundList.indexWhere((element) => element.current_round==true);
        var length=roundList.length;
        //current round is empty
        if(contain.isEmpty||roundIndex==0){
          for(var i=0;i<3;i++){
            roundList[i].enabled=true;
          }
        }
        //corrent round not empty
        else{


          if(roundIndex==(length-1)){
            for(var i=0;i<roundList.length;i++){
              roundList[i].enabled=true;
            }
          }else{
            for(var i=0;i<=roundIndex+1;i++){
              roundList[i].enabled=true;
            }
          }

        }

        initRoundId.value=roundList[index.value].id!;
        if(roundList[index.value].startedAt!=null){
          timeLineStatus.value=calculateTimeDifferenceBetween(startDate1: roundList[index.value].startedAt!, DbEndDate1: roundList[index.value].endedAt!);
        }

        loading(false);
        getData(true,leagueId,sessionId,initRoundId.value.toString(),page.value.toString(),false);
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
  void getData(var load,String leagueId,String sessionId,String roundId,String pageNumber,bool refresh) async {
    loading1(load);
    internetError(false);
    serverError(false);
    somethingWrong(false);
    timeoutError(false);
    try {
      getStartPredictionData(leagueId, sessionId, roundId,pageNumber).then((resp) {
        pageCount.value=resp.meta!.lastPage!;
        if(refresh){
          mainList.clear();
          mainFocusList.clear();
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
          loading1(false);
          return;
        }
        if(refresh){
          list.value=resp.data!;
          for(var i=0;i<list.length;i++){
            var homeTeam=list[i].teams!.firstWhere((element) => element.ground=="home");
            var awayTeam=list[i].teams!.firstWhere((element) => element.ground=="away");
            list[i].teams!.clear();
            list[i].teams!.add(homeTeam);
            list[i].teams!.add(awayTeam);
            TextEditingController textEditingController1 = TextEditingController();
            TextEditingController textEditingController2 = TextEditingController();
            FocusNode fieldFocusNode1 = FocusNode();
            FocusNode fieldFocusNode2 = FocusNode();
            var uniqueIdentity1="${list[i].id!}${list[i].teams![0].id!}";
            var uniqueIdentity2="${list[i].id!}${list[i].teams![1].id!}";
            mainList[uniqueIdentity1]=textEditingController1;
            mainList[uniqueIdentity2]=textEditingController2;
            mainFocusList[uniqueIdentity1]=fieldFocusNode1;
            mainFocusList[uniqueIdentity2]=fieldFocusNode2;
            if(list[i].prediction!=null){
              mainList[uniqueIdentity1].text=list[i].prediction!.homeTeamGoals.toString();
              mainList[uniqueIdentity2].text=list[i].prediction!.awayTeamGoals.toString();

            }
            if(list[i].prediction!=null&&list[i].prediction!.multiplyByTwo==1){
              radioValue.value="${list[i].id}";
            }
            mainRadioList["${list[i].id}"]="${list[i].id}";
          }
          refreshController.refreshToIdle();
        }else{
          list.addAll(resp.data!);
          for(var i=0;i<list.length;i++){
            var homeTeam=list[i].teams!.firstWhere((element) => element.ground=="home");
            var awayTeam=list[i].teams!.firstWhere((element) => element.ground=="away");
            list[i].teams!.clear();
            list[i].teams!.add(homeTeam);
            list[i].teams!.add(awayTeam);
            TextEditingController textEditingController1 = TextEditingController();
            TextEditingController textEditingController2 = TextEditingController();
            FocusNode fieldFocusNode1 = FocusNode();
            FocusNode fieldFocusNode2 = FocusNode();
            var uniqueIdentity1="${list[i].id!}${list[i].teams![0].id!}";
            var uniqueIdentity2="${list[i].id!}${list[i].teams![1].id!}";
            mainList[uniqueIdentity1]=textEditingController1;
            mainList[uniqueIdentity2]=textEditingController2;
            mainFocusList[uniqueIdentity1]=fieldFocusNode1;
            mainFocusList[uniqueIdentity2]=fieldFocusNode2;
            if(list[i].prediction!=null){
              mainList[uniqueIdentity1].text=list[i].prediction!.homeTeamGoals.toString();
              mainList[uniqueIdentity2].text=list[i].prediction!.awayTeamGoals.toString();

            }
            if(list[i].prediction!=null&&list[i].prediction!.multiplyByTwo==1){
              radioValue.value="${list[i].id}";
            }
            mainRadioList["${list[i].id}"]="${list[i].id}";
          }
          refreshController.loadComplete();
        }



        print(page.value);
        page.value++;
        loading1(false);
        Timer(
            const Duration(seconds: 1),
                () => roundList.isNotEmpty?itemScrollController.scrollTo(
                index: index.value,
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear):null);

      }, onError: (e) {
        loading1(false);
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
      loading1(false);
      somethingWrong(true);
    }
  }


  String calculateTimeDifferenceBetween(
      {required String startDate1,required String DbEndDate1}) {
    DateTime startDate = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(startDate1).toLocal();
    DateTime DbEndDate = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(DbEndDate1).toLocal();
    DateTime endDate = DateTime.now();
    int seconds = endDate.difference(startDate).inSeconds;
    if (seconds >= 60 && seconds < 3600) {
      if(startDate.difference(endDate).inMinutes>=0){
        timeLineStatusTitle.value="Submit Your Prediction";
        return '${startDate.difference(endDate).inMinutes.abs()} minute left';
      }else{
        timeLineStatusTitle.value="Round Ended";
        return '${DbEndDate.day}/${DbEndDate.month}/${DbEndDate.year}';
      }

    }

    else if (seconds >= 3600 && seconds < 86400) {
      if(startDate.difference(endDate).inHours>=0){
        timeLineStatusTitle.value="Submit Your Prediction";
        return '${startDate.difference(endDate).inHours} hour left';
      }else{
        timeLineStatusTitle.value="Round Ended";
        return '${DbEndDate.day}/${DbEndDate.month}/${DbEndDate.year}';
      }

    }


    else {
      if(startDate.difference(endDate).inDays>=0){
        timeLineStatusTitle.value="Submit Your Prediction";
        return '${startDate.difference(endDate).inDays} day left';
      }else{
        timeLineStatusTitle.value="Round Ended";
        return '${DbEndDate.day}/${DbEndDate.month}/${DbEndDate.year}';
      }

    }
  }


}