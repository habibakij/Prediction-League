
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prediction/api_request/dynamic_link_api.dart';
import 'package:prediction/common/language_controller.dart';
import 'package:prediction/controller/ad_controller/ads_controller.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/pages/chat/message_page.dart';
import 'package:prediction/pages/home/home_page.dart';
import 'package:prediction/pages/leaque/league_page.dart';
import 'package:prediction/pages/profile/profile_page.dart';
import 'package:prediction/pages/rank/rank_page.dart';
import 'package:prediction/pages/setting/setting_page.dart';
import 'package:http/http.dart' as http;
import '../../api_request/api_call.dart';
import '../../controller/chat/chat_controller.dart';
import '../../model/session_list.dart';
import '../../package/floatbar/ff_navigation_bar.dart';
import '../../util/constant.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'division',
      'Division App',
      description: "Hi This is description",
      importance: Importance.high,
      playSound: true
  );
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final NotificationDetails notificationDetails=NotificationDetails(android: AndroidNotificationDetails(
      channel.id,
      channel.name,
      importance: Importance.high,
      icon: "@mipmap/ic_launcher"
  )
  );
  flutterLocalNotificationsPlugin.show(1,"New notification from Prediction", message.data['text'], notificationDetails,payload: "");
}

class ContainerPage extends StatefulWidget {
  final String id;

  const ContainerPage({Key? key,required this.id}) : super(key: key);
  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  String _currentPage = "page0";
  int selected_index = 0;
  int userId=0;
  GlobalKey bottomNavigationKey = GlobalKey();
  List<String> pageKeys = ["page0", "page1", "page2", "page3","page4"];
  Map<String, GlobalKey<NavigatorState>> navigatorKeys = {
    "page0": GlobalKey<NavigatorState>(),
    "page1": GlobalKey<NavigatorState>(),
    "page2": GlobalKey<NavigatorState>(),
    "page3": GlobalKey<NavigatorState>(),
    "page4": GlobalKey<NavigatorState>(),
  };
  DateTime preBackPress = DateTime.now();

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        selected_index = index;
      });
    }
  }
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'prediction',
      'Prediction App',
      description: "Hi This is description",
      importance: Importance.high,
      playSound: true
  );
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String device_token="";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final langController=Get.put(LanguageController());
  final adsController=Get.put(AdsController());
  final chatController=Get.put(ChatController());
  void initFirebase() async {

    device_token = (await _firebaseMessaging.getToken())!;
    await updateDeviceToken(device_token);
  }
  checkArabic() async {
    bool isArabic= await getBooleanPref(ISARABIC);
    userId=await getIntPrefs(USER);
    if (isArabic){
      langController.getDynamicTranslatedData("ar");
    } else {
    }
    setState(() {});
  }
  @override
  void initState(){
    super.initState();
    checkArabic();
    initFirebase();
    adsController.getCountryCode();
    DynamicLinksApi.initDynamicLinks(context,widget.id);
    setNotificationPlagin();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async{

      if(message!=null){
        print(message.data);
        if(message.data['object']=="message"||message.data["object"]=="round-reminder"||message.data['object']=="round-endOfRound"){
          var tempDir = await getTemporaryDirectory();
          String fullPath = tempDir.path + "/image.png";
          Dio dio=Dio();
          final path = Directory(tempDir.path);
          if(!await path.exists()){
            path.createSync();
            print("executed");
          }
          await dio.download(message.data['image'], fullPath);
          final styleInformation=BigPictureStyleInformation(
            FilePathAndroidBitmap(fullPath),
          );
          final NotificationDetails notificationDetails=NotificationDetails(android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              importance: Importance.high,
              icon: "@mipmap/ic_launcher",
              styleInformation: styleInformation
          )
          );
          try{
            flutterLocalNotificationsPlugin.show(1,message.data['title'], message.data['body'], notificationDetails,payload: "");
          }catch(e){
            if(kDebugMode){
              print(e);
            }
          }
        }
        if(message.data['object']=="ad"){
          adsController.getCountryCode();
        }
        if(message.data['object']=="custom-football.competition.chat"){
          final NotificationDetails notificationDetails=NotificationDetails(android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.high,
            icon: "@mipmap/ic_launcher",
          )
          );
          chatController.getData(false, message.data['competition_id'].toString());
          flutterLocalNotificationsPlugin.show(1,"You have new notification", message.data['message'], notificationDetails,payload: "");

        }

      }

    });
    FirebaseMessaging.onMessage.listen((RemoteMessage? message)async {
      if(message!=null){
        print(message.data);
        if(message.data['object']=="message"||message.data["object"]=="round-reminder"||message.data['object']=="round-endOfRound"){
          var tempDir = await getTemporaryDirectory();
          String fullPath = tempDir.path + "/image.png";
          Dio dio=Dio();
          final path = Directory(tempDir.path);
          if(!await path.exists()){
            path.createSync();
            print("executed");
          }
          await dio.download(message.data['image'], fullPath);
          final styleInformation=BigPictureStyleInformation(
            FilePathAndroidBitmap(fullPath),
          );
          final NotificationDetails notificationDetails=NotificationDetails(android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              importance: Importance.high,
              icon: "@mipmap/ic_launcher",
              styleInformation: styleInformation
          )
          );
          try{
            flutterLocalNotificationsPlugin.show(1,message.data['title'], message.data['body'], notificationDetails,payload: "");
          }catch(e){
            if(kDebugMode){
              print(e);
            }
          }
        }
        if(message.data['object']=="ad"){
          adsController.getCountryCode();
        }
        if(message.data['object']=="custom-football.competition.chat"){
          final NotificationDetails notificationDetails=NotificationDetails(android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              importance: Importance.high,
              icon: "@mipmap/ic_launcher",
          )
          );
          var data=message.data;
          var user=jsonDecode(data['user']);
          String id=user['id'].toString();
          if(userId.toString()!=id){
            chatController.getData(false, message.data['competition_id'].toString());
            flutterLocalNotificationsPlugin.show(1,"You have new notification", message.data['message'], notificationDetails,payload: "");
          }

        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
       if(message.data.containsKey("competition_id")){
         Navigator.of(context,rootNavigator: true).push(PageTransition(child: MessagePage(leagueId: message.data['competition_id'].toString(), competetors: message.data['competitors'].toString(), leagueTitle: '${message.data['competition_title']}',), type: PageTransitionType.fade));
       }
    });
  }
  void setNotificationPlagin()async{
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(preBackPress);
        final cantExit = timegap >= const Duration(seconds: 2);
        preBackPress = DateTime.now();
        final isFirstRouteInCurrentTab = !await navigatorKeys[_currentPage]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "page0") {
            _selectTab("page0", 0);
            return false;
          } else {
            if (cantExit) {
              showToast(langController.press_to_exit.value);
              return false;
            } else {
              return true;
            }
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark
        ),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(children: <Widget>[
              _buildOffstageNavigator("page0"),
              _buildOffstageNavigator("page1"),
              _buildOffstageNavigator("page2"),
              _buildOffstageNavigator("page3"),
              _buildOffstageNavigator("page4"),
            ]
            ),
          bottomNavigationBar: Obx(()=>FFNavigationBar(
            theme: FFNavigationBarTheme(
              barBackgroundColor: Colors.white,
              selectedItemBorderColor: Colors.white,
              selectedItemBackgroundColor: primaryColor,
              selectedItemIconColor: Colors.white,
              selectedItemLabelColor: Colors.black,
              showSelectedItemShadow: false,
              barHeight: 69,
            ),
            selectedIndex: selected_index,
            onSelectTab: (index) {
              setState(() {
                selected_index = index;
                _selectTab(pageKeys[selected_index], selected_index);
                if(selected_index == 1 || selected_index == 2){
                  //showCustomDialog();
                }
              });
            },
            items: [
              FFNavigationBarItem(
                iconData: "assets/images/home_icon.png",
                label: langController.home.value,
              ),
              FFNavigationBarItem(
                iconData: "assets/images/rank_icon.png",
                label: langController.rank.value,
                selectedBackgroundColor: primaryColor,
              ),
              FFNavigationBarItem(
                iconData: "assets/images/league_icon.png",
                //label: 'private_league'.tr,
                label: langController.my_leagues.value,
                selectedBackgroundColor: primaryColor,
              ),
              FFNavigationBarItem(
                iconData: "assets/images/profile_icon.png",
                //label: 'profile'.tr,
                label: langController.my_profile.value,
                selectedBackgroundColor: primaryColor,
              ),
              FFNavigationBarItem(
                iconData: "assets/images/settings_icon.png",
                label: langController.settings.value,
                selectedBackgroundColor: primaryColor,
              ),
            ],
          )),



        ),
      ),
    );


  }
  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[tabItem]!,
        tabItem: tabItem,
      ),
    );
  }



}
class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});

  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;
  late Widget child;

  @override
  Widget build(BuildContext context) {
    if (tabItem == "page0") {
      child = HomePage();
    } else if (tabItem == "page1") {
      child = RankPage();
    } else if (tabItem == "page2") {
      child = LeaguePage();
    } else if (tabItem == "page3") {
      child = ProfilePage();
    } else if (tabItem == "page4") {
      child = SettingPage();
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
