
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prediction/controller/introduction/introduction_controller.dart';
import 'package:prediction/package/page_transition/enum.dart';
import 'package:prediction/package/page_transition/page_transition.dart';
import 'package:prediction/pages/language/language_setting_page.dart';
import 'package:prediction/util/constant.dart';

class IntroductionPage extends StatefulWidget {
  @override
  State<IntroductionPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroductionPage> {
  var appController= Get.put(IntroController());
  String cashImage= "https://thumbs.dreamstime.com/z/prediction-icon-simple-element-data-organization-collection-filled-templates-infographics-more-172201654.jpg";

  final controller = PageController();
  int currentPage = 0;
  var imageList=[
    "assets/images/intro1.png",
    "assets/images/intro2.png",
    "assets/images/intro3.png",
  ];
  var titleList=[
    "welcome",
    "choose",
    "thereis",
  ];

  var descriptionList=[
    "intro_description",
    "intro_description",
    "intro_description",
  ];

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        color: currentPage == index ? const Color(0xFF48C4B9):const Color(0xFFDADADA),
      ),
      margin: const EdgeInsets.only(right: 10),
      height: 14,
      curve: Curves.easeIn,
      width: 14,
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
  }
  getPermission()async{
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              const SizedBox(height: 100,),

              Expanded(
                flex: 10,
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (value) => setState(() => currentPage = value),
                  itemCount: imageList.length,
                  itemBuilder: (context,index){
                    return Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Obx(() => Image.network(
                              appController.lFileName.value.toString().isEmpty ? cashImage :
                            "http://167.71.227.239${appController.lFileName.value.toString()}",
                          ),),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text(
                                titleList[index].tr,
                                style: const TextStyle(color: commonTextColor,fontWeight: FontWeight.w600,fontSize: 21),
                              ),
                              const SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  descriptionList[index].tr,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(color: Color(0xFF979797),fontSize: 15,fontWeight: FontWeight.w500),
                                  maxLines: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

              ),

              Expanded(
                flex:1,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageList.length, (int index) => _buildDots(index: index),
                ),
              ),
              ),
              Expanded(flex:1, child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed:(){
                      Navigator.of(context).push(PageTransition(child: const LanguageSettingPage(), type: PageTransitionType.rightToLeft));
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                      backgroundColor: MaterialStateProperty.all(commonTextColor)
                    ),
                    child: Text("skip".tr,style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500)),
                  ),
                  currentPage==2?ElevatedButton(
                    onPressed:(){
                      Navigator.of(context).push(PageTransition(child: const LanguageSettingPage(), type: PageTransitionType.rightToLeft));
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                        backgroundColor: MaterialStateProperty.all(primaryColor)
                    ),
                    child: Text("lets".tr,style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500))
                  ):const SizedBox(),
                ],
              )),

            ],
          ),
        )
      ),

    );
  }
}
