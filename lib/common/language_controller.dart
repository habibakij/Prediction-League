import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:prediction/util/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController{
  var arabic=false.obs;

  @override
  void onInit() {
    super.onInit();
    getEnglishTranslatedData();
  }

  void setDetectGuestMode(String guestMode) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("guestMode", guestMode);
  }

  RxString isGuestMode= "".obs;
  void detectGuestMode() async{
    final prefs = await SharedPreferences.getInstance();
    isGuestMode.value= prefs.getString("guestMode").toString();
    log("check_guest_mode: $isGuestMode");
  }





  /// all translate variable
  var translateResponse= {}.obs;
   RxString
   //login page
       welcomeBack= "".obs,
       login_with="".obs,
       password="".obs,
       forgot_password="".obs,
       signin="".obs,
       google="".obs,
       apple="".obs,
       dont_account="".obs,
       create_account="".obs,
       skip="".obs,
       invalid_email_or_username="".obs,
       empty_password="".obs,
       password_invalid="".obs,
   //container page
       new_notification="".obs,
       press_to_exit="".obs,
       home="".obs,
       rank="".obs,
       my_leagues="".obs,
       my_profile="".obs,
       settings="".obs,
   //create cup page
       create_cup="".obs,
       select_type="".obs,
       cup_title="".obs,
       type="".obs,
       select_start_round="".obs,
       select="".obs,
       no_of_participation="".obs,
       type_of_competition="".obs,
       description_optional="".obs,
       play_for="".obs,
       phone_number="".obs,
       create_cup_upper="".obs,
       cup_details="".obs,
       east="".obs,
       pts="".obs,
       vs="".obs,
       west="".obs,
       yes="".obs,
       cancel="".obs,
       login_first="".obs,
       alart="".obs,
       subscription_failed="".obs,
       wait="".obs,
       subscribe="".obs,
       subscribebody="".obs,
       startprediction="".obs,
       create_league="".obs,
       league_title="".obs,
       please_select="".obs,
       please_title="".obs,
       please_play_for="".obs,
       please_phone="".obs,
       please_general="".obs,
       please_participants="".obs,
       league_successfull="".obs,
       league_create_upper="".obs,
       league_details="".obs,
       owner="".obs,
       joined="".obs,
       your_ranked="".obs,
       winner="".obs,
       status="".obs,
       username="".obs,
       round_point="".obs,
       total_points="".obs,
       full_name="".obs,
       email="".obs,
       country="".obs,
       sign_up="".obs,
       sign_up_success="".obs,
       sign_up_success_body="".obs,
       ok="".obs,
       notification="".obs,
       joining_app="".obs,
       league="".obs,
       private_league="".obs,
       private_cup="".obs,
       likes="".obs,
       bio="".obs,
       edit="".obs,
       profile_details="".obs,
       change_password="".obs,
       point="".obs,
       earned="".obs,
       total_user="".obs,
       your_point="".obs,
       top="".obs,
       contact_us="".obs,
       get_in_touch="".obs,
       follow_us="".obs,
       drop_us_a_message="".obs,
       name="".obs,
       phone="".obs,
       email1="".obs,
       your_message="".obs,
       send="".obs,
       privacy_policy="".obs,
       language="".obs,
       terms_and_conditions="".obs,
       about_us="".obs,
       logout="".obs,
       version="".obs,
       empty_username="".obs,
       invalid_username="".obs,
       empty_confirm_password="".obs,
       confirm_not_matched="".obs,
       empty_fullname="".obs,
       invalid_fullname="".obs,
       empty_email="".obs,
       invalid_email="".obs,
       empty_date="".obs,
       empty_country="".obs,
       confirm_password="".obs,
       by="".obs,
       and="".obs,
       submit_prediction="".obs,
       forget_title="".obs,
       forget_body="".obs,
       forget_bottom="".obs,
       rank_name="".obs,
       poinlr="".obs,
       edit_profile="".obs,
       email_without_star="".obs,
       update_details="".obs,
       profile_updated="".obs,
       profile_updated_successful="".obs,
       empty_bio="".obs,
       old_password="".obs,
       new_password="".obs,
       old_password_hint="".obs,
       new_password_hint="".obs,
       confirm_new_password_hint="".obs,
       change_password_upper="".obs,
       password_changed="".obs,
       password_changed_successfully="".obs,
       apptitle="".obs,
       fun="".obs,
       prize="".obs,
       general="".obs,
       private="".obs,



       search="".obs


  ;

  void getEnglishTranslatedData() async {
    try{
      var response = await http.get(Uri.parse("$baseUrl/l10n/translations"),
          headers: {
            'Accept': 'application/json',
            'X-L10n': 'en'
          });
      if(response.statusCode == 200 || response.statusCode == 201){
        var decode= jsonDecode(response.body);
        translateResponse.value= decode["data"];
        log("check_translate: $translateResponse");
        //login page
        welcomeBack.value = translateResponse["others.welcome_back"].toString();
        login_with.value = translateResponse["others. login_with"].toString();
        password.value = translateResponse["others.password"].toString();
        forgot_password.value = translateResponse["others.forgot_password"].toString();
        signin.value = translateResponse["others.signin"].toString();
        google.value = translateResponse["others.google"].toString();
        apple.value = translateResponse["others.apple"].toString();
        dont_account.value = translateResponse["others.dont_account"].toString();
        create_account.value = translateResponse["others.create_account"].toString();
        skip.value = translateResponse["others.skip"].toString();
        invalid_email_or_username.value = translateResponse["others.invalid_email_or_username"].toString();
        empty_password.value = translateResponse["others.empty_password"].toString();
        password_invalid.value = translateResponse["others.password_invalid"].toString();
        //container page
        new_notification.value = translateResponse["others.new_notification"].toString();
        press_to_exit.value = translateResponse["others.press_to_exit"].toString();
        home.value = translateResponse["others.home"].toString();
        rank.value = translateResponse["others.rank"].toString();
        my_leagues.value = translateResponse["others.my_leagues"].toString();
        my_profile.value = translateResponse["others.my_profile"].toString();
        settings.value = translateResponse["others.settings"].toString();
        //create cup page
        create_cup.value = translateResponse["others.create_cup"].toString();
        select_type.value = translateResponse["others.select_type"].toString();
        cup_title.value = translateResponse["others.cup_title"].toString();
        type.value = translateResponse["others.type"].toString();
        select_start_round.value = translateResponse["others.select_start_round"].toString();
        select.value = translateResponse["others.select"].toString();
        no_of_participation.value = translateResponse["others.no_of_participation"].toString();
        type_of_competition.value = translateResponse["others.type_of_competition"].toString();
        description_optional.value = translateResponse["others.description_optional"].toString();
        play_for.value = translateResponse["others.play_for"].toString();
        phone_number.value = translateResponse["others.phone_number"].toString();
        create_cup_upper.value = translateResponse["others.create_cup_upper"].toString();
        cup_details.value = translateResponse["others.cup_details"].toString();
        east.value = translateResponse["others.east"].toString();
        pts.value = translateResponse["others.pts"].toString();
        vs.value = translateResponse["others.vs"].toString();
        west.value = translateResponse["others.west"].toString();
        yes.value = translateResponse["others.yes"].toString();
        cancel.value = translateResponse["others.cancel"].toString();
        login_first.value = translateResponse["others.login_first"].toString();
        alart.value = translateResponse["others.alart"].toString();
        subscription_failed.value = translateResponse["others.subscription_failed"].toString();
        wait.value = translateResponse["others.wait"].toString();
        subscribe.value = translateResponse["others.subscribe"].toString();
        subscribebody.value = translateResponse["others.subscribebody"].toString();
        startprediction.value = translateResponse["others.startprediction"].toString();
        create_league.value = translateResponse["others.create_league"].toString();
        league_title.value = translateResponse["others.league_title"].toString();
        please_select.value = translateResponse["others.please_select"].toString();
        please_title.value = translateResponse["others.please_title"].toString();
        please_play_for.value = translateResponse["others.please_play_for"].toString();
        please_phone.value = translateResponse["others.please_phone"].toString();
        please_general.value = translateResponse["others.please_general"].toString();
        please_participants.value = translateResponse["others.please_participants"].toString();
        league_successfull.value = translateResponse["others.league_successfull"].toString();
        league_create_upper.value = translateResponse["others.league_create_upper"].toString();
        league_details.value = translateResponse["others.league_details"].toString();
        owner.value = translateResponse["others.owner"].toString();
        joined.value = translateResponse["others.joined"].toString();
        your_ranked.value = translateResponse["others.your_ranked"].toString();
        winner.value = translateResponse["others.winner"].toString();
        status.value = translateResponse["others.status"].toString();
        username.value = translateResponse["others.username"].toString();
        round_point.value = translateResponse["others.round_point"].toString();
        total_points.value = translateResponse["others.total_points"].toString();
        search.value = translateResponse["others.search"].toString();
        full_name.value = translateResponse["others.full_name"].toString();
        email.value = translateResponse["others.email"].toString();
        country.value = translateResponse["others.country"].toString();
        sign_up.value = translateResponse["others.sign_up"].toString();
        sign_up_success.value = translateResponse["others.sign_up_success"].toString();
        sign_up_success_body.value = translateResponse["others.sign_up_success_body"].toString();
        ok.value = translateResponse["others.ok"].toString();
        notification.value = translateResponse["others.notification"].toString();
        joining_app.value = translateResponse["others.joining_app"].toString();
        league.value = translateResponse["others.league"].toString();
        private_league.value = translateResponse["others.private_league"].toString();
        private_cup.value = translateResponse["others.private_cup"].toString();
        likes.value = translateResponse["others.likes"].toString();
        bio.value = translateResponse["others.bio"].toString();
        edit.value = translateResponse["others.edit"].toString();
        profile_details.value = translateResponse["others.profile_details"].toString();
        change_password.value = translateResponse["others.change_password"].toString();
        point.value = translateResponse["others.point"].toString();
        earned.value = translateResponse["others.earned"].toString();
        total_user.value = translateResponse["others.total_user"].toString();
        your_point.value = translateResponse["others.your_point"].toString();
        top.value = translateResponse["others.top"].toString();
        contact_us.value = translateResponse["others.contact_us"].toString();
        get_in_touch.value = translateResponse["others.get_in_touch"].toString();
        follow_us.value = translateResponse["others.follow_us"].toString();
        drop_us_a_message.value = translateResponse["others.drop_us_a_message"].toString();
        name.value = translateResponse["others.name"].toString();
        phone.value = translateResponse["others.phone"].toString();
        email1.value = translateResponse["others.email"].toString();
        your_message.value = translateResponse["others.your_message"].toString();
        send.value = translateResponse["others.send"].toString();
        privacy_policy.value = translateResponse["others.privacy_policy"].toString();
        language.value = translateResponse["others.language"].toString();
        terms_and_conditions.value = translateResponse["others.terms_and_conditions"].toString();
        about_us.value = translateResponse["others.about_us"].toString();
        logout.value = translateResponse["others.logout"].toString();
        version.value = translateResponse["others.version"].toString();
        empty_username.value = translateResponse["others.empty_username"].toString();
        invalid_username.value = translateResponse["others.invalid_username"].toString();
        empty_confirm_password.value = translateResponse["others.empty_confirm_password"].toString();
        confirm_not_matched.value = translateResponse["others.confirm_not_matched"].toString();
        empty_fullname.value = translateResponse["others.empty_fullname"].toString();
        invalid_fullname.value = translateResponse["others.invalid_fullname"].toString();
        empty_email.value = translateResponse["others.empty_email"].toString();
        invalid_email.value = translateResponse["others.invalid_email"].toString();
        empty_date.value = translateResponse["others.empty_date"].toString();
        empty_country.value = translateResponse["others.empty_country"].toString();
        confirm_password.value = translateResponse["others.confirm_password"].toString();
        by.value = translateResponse["others.by"].toString();
        and.value = translateResponse["others.and"].toString();
        submit_prediction.value = translateResponse["others.submit_prediction"].toString();
        forget_title.value = translateResponse["others.forget_title"].toString();
        forget_body.value = translateResponse["others.forget_body"].toString();
        forget_bottom.value = translateResponse["others.forget_bottom"].toString();
        rank_name.value = translateResponse["other.rank_name"].toString();
        poinlr.value = translateResponse["others.poinlr"].toString();
        edit_profile.value = translateResponse["others.edit_profile"].toString();
        email_without_star.value = translateResponse["others.email_without_star"].toString();
        update_details.value = translateResponse["others.update_details"].toString();
        profile_updated.value = translateResponse["others.profile_updated"].toString();
        profile_updated_successful.value = translateResponse["others.profile_updated_successful"].toString();
        empty_bio.value = translateResponse["others.empty_bio"].toString();
        old_password.value = translateResponse["others.old_password"].toString();
        new_password.value = translateResponse["others.new_password"].toString();
        old_password_hint.value = translateResponse["others.old_password_hint"].toString();
        new_password_hint.value = translateResponse["others.new_password_hint"].toString();
        confirm_new_password_hint.value = translateResponse["others.confirm_new_password_hint"].toString();
        change_password_upper.value = translateResponse["others.change_password_upper"].toString();
        password_changed.value = translateResponse["others.password_changed"].toString();
        password_changed_successfully.value = translateResponse["others.password_changed_successfully"].toString();
        apptitle.value = translateResponse["others.apptitle"].toString();
        fun.value = translateResponse["others.fun"].toString();
        prize.value = translateResponse["others.prize"].toString();
        general.value = translateResponse["others.general"].toString();
        private.value = translateResponse["others.private"].toString();

      } else {
        log("try_translate: ${response.statusCode} url: ${response.request}");
        showToast("Somethings want wrong, Please try again");
      }
    } catch(_){
      log("try_translate: ${_.toString()}");
      showToast("Somethings want wrong, Please try again");
    }
  }

  void getDynamicTranslatedData(String key) async {
    try{
      var response = await http.get(Uri.parse("$baseUrl/l10n/translations"),
          headers: {
            'Accept': 'application/json',
            'X-L10n': key
          });
      if(response.statusCode == 200 || response.statusCode == 201){
        var decode= jsonDecode(response.body);
        translateResponse.value= decode["data"];
        log("check_translate: $translateResponse");
        //login page
        welcomeBack.value = translateResponse["others.welcome_back"].toString();
        login_with.value = translateResponse["others. login_with"].toString();
        password.value = translateResponse["others.password"].toString();
        forgot_password.value = translateResponse["others.forgot_password"].toString();
        signin.value = translateResponse["others.signin"].toString();
        google.value = translateResponse["others.google"].toString();
        apple.value = translateResponse["others.apple"].toString();
        dont_account.value = translateResponse["others.dont_account"].toString();
        create_account.value = translateResponse["others.create_account"].toString();
        skip.value = translateResponse["others.skip"].toString();
        invalid_email_or_username.value = translateResponse["others.invalid_email_or_username"].toString();
        empty_password.value = translateResponse["others.empty_password"].toString();
        password_invalid.value = translateResponse["others.password_invalid"].toString();
        //container page
        new_notification.value = translateResponse["others.new_notification"].toString();
        press_to_exit.value = translateResponse["others.press_to_exit"].toString();
        home.value = translateResponse["others.home"].toString();
        rank.value = translateResponse["others.rank"].toString();
        my_leagues.value = translateResponse["others.my_leagues"].toString();
        my_profile.value = translateResponse["others.my_profile"].toString();
        settings.value = translateResponse["others.settings"].toString();
        //create cup page
        create_cup.value = translateResponse["others.create_cup"].toString();
        select_type.value = translateResponse["others.select_type"].toString();
        cup_title.value = translateResponse["others.cup_title"].toString();
        type.value = translateResponse["others.type"].toString();
        select_start_round.value = translateResponse["others.select_start_round"].toString();
        select.value = translateResponse["others.select"].toString();
        no_of_participation.value = translateResponse["others.no_of_participation"].toString();
        type_of_competition.value = translateResponse["others.type_of_competition"].toString();
        description_optional.value = translateResponse["others.description_optional"].toString();
        play_for.value = translateResponse["others.play_for"].toString();
        phone_number.value = translateResponse["others.phone_number"].toString();
        create_cup_upper.value = translateResponse["others.create_cup_upper"].toString();
        cup_details.value = translateResponse["others.cup_details"].toString();
        east.value = translateResponse["others.east"].toString();
        pts.value = translateResponse["others.pts"].toString();
        vs.value = translateResponse["others.vs"].toString();
        west.value = translateResponse["others.west"].toString();
        yes.value = translateResponse["others.yes"].toString();
        cancel.value = translateResponse["others.cancel"].toString();
        login_first.value = translateResponse["others.login_first"].toString();
        alart.value = translateResponse["others.alart"].toString();
        subscription_failed.value = translateResponse["others.subscription_failed"].toString();
        wait.value = translateResponse["others.wait"].toString();
        subscribe.value = translateResponse["others.subscribe"].toString();
        subscribebody.value = translateResponse["others.subscribebody"].toString();
        startprediction.value = translateResponse["others.startprediction"].toString();
        create_league.value = translateResponse["others.create_league"].toString();
        league_title.value = translateResponse["others.league_title"].toString();
        please_select.value = translateResponse["others.please_select"].toString();
        please_title.value = translateResponse["others.please_title"].toString();
        please_play_for.value = translateResponse["others.please_play_for"].toString();
        please_phone.value = translateResponse["others.please_phone"].toString();
        please_general.value = translateResponse["others.please_general"].toString();
        please_participants.value = translateResponse["others.please_participants"].toString();
        league_successfull.value = translateResponse["others.league_successfull"].toString();
        league_create_upper.value = translateResponse["others.league_create_upper"].toString();
        league_details.value = translateResponse["others.league_details"].toString();
        owner.value = translateResponse["others.owner"].toString();
        joined.value = translateResponse["others.joined"].toString();
        your_ranked.value = translateResponse["others.your_ranked"].toString();
        winner.value = translateResponse["others.winner"].toString();
        status.value = translateResponse["others.status"].toString();
        username.value = translateResponse["others.username"].toString();
        round_point.value = translateResponse["others.round_point"].toString();
        total_points.value = translateResponse["others.total_points"].toString();
        search.value = translateResponse["others.search"].toString();
        full_name.value = translateResponse["others.full_name"].toString();
        email.value = translateResponse["others.email"].toString();
        country.value = translateResponse["others.country"].toString();
        sign_up.value = translateResponse["others.sign_up"].toString();
        sign_up_success.value = translateResponse["others.sign_up_success"].toString();
        sign_up_success_body.value = translateResponse["others.sign_up_success_body"].toString();
        ok.value = translateResponse["others.ok"].toString();
        notification.value = translateResponse["others.notification"].toString();
        joining_app.value = translateResponse["others.joining_app"].toString();
        league.value = translateResponse["others.league"].toString();
        private_league.value = translateResponse["others.private_league"].toString();
        private_cup.value = translateResponse["others.private_cup"].toString();
        likes.value = translateResponse["others.likes"].toString();
        bio.value = translateResponse["others.bio"].toString();
        edit.value = translateResponse["others.edit"].toString();
        profile_details.value = translateResponse["others.profile_details"].toString();
        change_password.value = translateResponse["others.change_password"].toString();
        point.value = translateResponse["others.point"].toString();
        earned.value = translateResponse["others.earned"].toString();
        total_user.value = translateResponse["others.total_user"].toString();
        your_point.value = translateResponse["others.your_point"].toString();
        top.value = translateResponse["others.top"].toString();
        contact_us.value = translateResponse["others.contact_us"].toString();
        get_in_touch.value = translateResponse["others.get_in_touch"].toString();
        follow_us.value = translateResponse["others.follow_us"].toString();
        drop_us_a_message.value = translateResponse["others.drop_us_a_message"].toString();
        name.value = translateResponse["others.name"].toString();
        phone.value = translateResponse["others.phone"].toString();
        email1.value = translateResponse["others.email"].toString();
        your_message.value = translateResponse["others.your_message"].toString();
        send.value = translateResponse["others.send"].toString();
        privacy_policy.value = translateResponse["others.privacy_policy"].toString();
        language.value = translateResponse["others.language"].toString();
        terms_and_conditions.value = translateResponse["others.terms_and_conditions"].toString();
        about_us.value = translateResponse["others.about_us"].toString();
        logout.value = translateResponse["others.logout"].toString();
        version.value = translateResponse["others.version"].toString();
        empty_username.value = translateResponse["others.empty_username"].toString();
        invalid_username.value = translateResponse["others.invalid_username"].toString();
        empty_confirm_password.value = translateResponse["others.empty_confirm_password"].toString();
        confirm_not_matched.value = translateResponse["others.confirm_not_matched"].toString();
        empty_fullname.value = translateResponse["others.empty_fullname"].toString();
        invalid_fullname.value = translateResponse["others.invalid_fullname"].toString();
        empty_email.value = translateResponse["others.empty_email"].toString();
        invalid_email.value = translateResponse["others.invalid_email"].toString();
        empty_date.value = translateResponse["others.empty_date"].toString();
        empty_country.value = translateResponse["others.empty_country"].toString();
        confirm_password.value = translateResponse["others.confirm_password"].toString();
        by.value = translateResponse["others.by"].toString();
        and.value = translateResponse["others.and"].toString();
        submit_prediction.value = translateResponse["others.submit_prediction"].toString();
        forget_title.value = translateResponse["others.forget_title"].toString();
        forget_body.value = translateResponse["others.forget_body"].toString();
        forget_bottom.value = translateResponse["others.forget_bottom"].toString();
        rank_name.value = translateResponse["other.rank_name"].toString();
        poinlr.value = translateResponse["others.poinlr"].toString();
        edit_profile.value = translateResponse["others.edit_profile"].toString();
        email_without_star.value = translateResponse["others.email_without_star"].toString();
        update_details.value = translateResponse["others.update_details"].toString();
        profile_updated.value = translateResponse["others.profile_updated"].toString();
        profile_updated_successful.value = translateResponse["others.profile_updated_successful"].toString();
        empty_bio.value = translateResponse["others.empty_bio"].toString();
        old_password.value = translateResponse["others.old_password"].toString();
        new_password.value = translateResponse["others.new_password"].toString();
        old_password_hint.value = translateResponse["others.old_password_hint"].toString();
        new_password_hint.value = translateResponse["others.new_password_hint"].toString();
        confirm_new_password_hint.value = translateResponse["others.confirm_new_password_hint"].toString();
        change_password_upper.value = translateResponse["others.change_password_upper"].toString();
        password_changed.value = translateResponse["others.password_changed"].toString();
        password_changed_successfully.value = translateResponse["others.password_changed_successfully"].toString();
        apptitle.value = translateResponse["others.apptitle"].toString();
        fun.value = translateResponse["others.fun"].toString();
        prize.value = translateResponse["others.prize"].toString();
        general.value = translateResponse["others.general"].toString();
        private.value = translateResponse["others.private"].toString();

      } else {
        log("try_translate: ${response.statusCode} url: ${response.request}");
        showToast("Somethings want wrong, Please try again");
      }
    } catch(_){
      log("try_translate: ${_.toString()}");
      showToast("Somethings want wrong, Please try again");
    }
  }

  void getLang()async{
    arabic.value=await getBooleanPref(ISARABIC);
  }
}