import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_progress/loading_progress.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/model/cup_round.dart';
import 'package:prediction/model/round.dart';

import '../../model/session_list.dart';
import '../../util/constant.dart';
class CupController extends GetxController{
  var sessionId=0.obs;
  var loading=false.obs;
  var uefa_flag="https://leaguepred.com/img/leagues/2.jpeg";
  var premier_flag="https://media.api-sports.io/football/leagues/39.png";
  var world_flag="https://media.api-sports.io/football/leagues/1.png";
  var cupRoundList=<CupRound>[].obs;
  void getSeason() async{
    loading(true);
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    try {
      var response = await http.get(Uri.parse(urlSeasons), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        SessionList sessionList = SessionList.fromJson(data);
        var seesion = sessionList.data!.last;
        sessionId.value = seesion.id!;
        loading(false);
      } else {
        loading(false);
      }
    }catch (e){
      loading(false);
    }

  }
  void getCupRounds(var type,var participant,var leagueId,BuildContext context){
    LoadingProgress.start(context);
    cupRoundList.clear();
    try {
      getRoundList(type, participant, leagueId, sessionId.toString()).then((resp) {
        if (resp.statusCode == 200) {
          CupRoundData roundData = CupRoundData.fromJson(jsonDecode(resp.body));
          cupRoundList.addAll(roundData.data!);
        } else {
          showToast("Failed");
        }
        LoadingProgress.stop(context);
      });
    }catch(e){
      LoadingProgress.stop(context);
    }
  }
}