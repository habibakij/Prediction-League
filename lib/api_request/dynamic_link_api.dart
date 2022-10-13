import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:prediction/pages/login/login_page.dart';
import 'package:prediction/util/constant.dart';

import 'api_call.dart';

class DynamicLinksApi {
  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  static Future<void> initDynamicLinks(BuildContext context,String id) async {
    if(id.isNotEmpty){

      var response=await sendJoinLeagueRequest(id);
      if(response.statusCode==200){
        showToast("You successfully joined!");
      }else{
        showToast("Joined to cup or league Failed!");
      }
    }
    dynamicLinks.onLink.listen((dynamicLinkData) async{
    final Uri deepLink=dynamicLinkData.link;
    var token=await getStringPrefs(TOKEN);
    if(deepLink.toString().isNotEmpty){
      List<String> seperatedLink=[];
      seperatedLink.addAll(deepLink.path.split("/"));
      if(token.toString().isNotEmpty){


        var response=await sendJoinLeagueRequest(seperatedLink[1]);

        if(response.statusCode==200){
          showToast("You successfully joined!");
        }else{
          showToast("Joined to cup or league Failed!");
        }
      }else{
        Get.offAll(LoginPage(id: seperatedLink[1],));
      }

    }
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  Future<String> createReferralLink(String referralCode,bool short) async {
    String url="https://leaguepred.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/$referralCode'),
      androidParameters: const AndroidParameters(
        packageName: 'com.prediction.app',
        minimumVersion: 0
      ),

    );

    Uri shareUrl;
    if (short) {
      final ShortDynamicLink shortLink =
      await dynamicLinks.buildShortLink(parameters);
      shareUrl = shortLink.shortUrl;
    } else {
      shareUrl = await dynamicLinks.buildLink(parameters);
    }

    return shareUrl.toString();
  }
}