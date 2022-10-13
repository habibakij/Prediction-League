import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prediction/api_request/api_call.dart';
import 'package:prediction/controller/chat/chat_controller.dart';

import '../../common/connectivity_checker.dart';
import '../../util/constant.dart';
import '../../widget/empty_failure_no_internet_view.dart';
import 'package:timeago/timeago.dart' as timeago;
class MessagePage extends StatefulWidget {
  final String competetors;
  final String leagueTitle;
  final String leagueId;
  const MessagePage({Key? key,required this.competetors,required this.leagueTitle,required this.leagueId}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final controller=Get.put(ChatController());
  final internetController=Get.put(ConnectivityCheckerController());
  final messageController=TextEditingController();
  final replyController=TextEditingController();

  @override
  void initState(){
    super.initState();
    internetController.startMonitoring();
    controller.getData(true,widget.leagueId);
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back,color: primaryColor,),
          ),
          title: Text("Chat",style: toolbarTitleStyle,),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            children: [
              Container(
               child: Row(
                 children: [
                   Image.asset("assets/images/logo.png",height: 80,width: 80,fit: BoxFit.scaleDown,),
                   Expanded(child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(widget.leagueTitle),
                       Text("Anything you post can be seen by all ${widget.competetors} members of the pool.")
                     ],
                   )),


                 ],
               ),
              ),
              Expanded(
                  child: Obx((){
                    if(controller.loading.value==true){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                          Center(child: Text("Please wait..."),)
                        ],
                      );
                    }
                    else if (internetController.isOnline.value == false) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/no_internet_lottie.json',
                          title: 'Internet Error',
                          description: 'Internet not found',
                          buttonText: "Retry",
                          onPressed: () {
                            controller.getData(true,widget.leagueId);
                          },
                          status: 1,
                        ),
                      );
                    } else if (controller.internetError.value == true) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/no_internet_lottie.json',
                          title: 'Internet Error',
                          description: 'Internet not found',
                          buttonText: "Retry",
                          onPressed: () {
                            controller.getData(true,widget.leagueId);
                          },
                          status: 1,
                        ),
                      );
                    } else if (controller.serverError.value == true) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'Server error'.tr,
                          description: 'Please try again later',
                          buttonText: "Retry",
                          onPressed: () {
                            controller.getData(true,widget.leagueId);
                          },
                          status: 1,
                        ),
                      );
                    } else if (controller.somethingWrong.value == true) {
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'Something went wrong',
                          description: 'Please try again later',
                          buttonText: "Retry",
                          onPressed: () {
                            controller.getData(true,widget.leagueId);
                          },
                          status: 1,
                        ),
                      );
                    }else  if(controller.timeoutError.value==true){
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/failure_lottie.json',
                          title: 'Timeout',
                          description: 'Please try again',
                          buttonText: "Retry",
                          onPressed: () {
                            controller.getData(true,widget.leagueId);
                          },
                          status: 1,
                        ),
                      );
                    }
                    else  if(controller.loading.value==false&&controller.list.isEmpty){
                      return Center(
                        child: EmptyFailureNoInternetView(
                          image: 'assets/lottie/empty_lottie.json',
                          title: 'No Data',
                          description: 'Start chatting now',
                          buttonText: "Retry",
                          onPressed: () {
                            controller.getData(true,widget.leagueId);
                          },
                          status: 0,
                        ),
                      );
                    }
                    else{
                      return RefreshIndicator(
                        onRefresh: ()async{
                          controller.getData(false, widget.leagueId);
                        },
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 10),
                            itemBuilder: (context,index){
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius:30,
                                    backgroundColor: Colors.transparent,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      height: 60,
                                      width: 60,
                                      imageUrl: "$imageBaseUrl${controller.list[index].user!.profilePicture}",
                                      placeholder: (context, url) => Container(
                                          height: 32,
                                          width: 60,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image,)),
                                      errorWidget: (context, url, error) => Container(
                                          height: 32,
                                          width: 60,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image,)),
                              ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(TextSpan(
                                          text: "${controller.list[index].user!.username} ",
                                          style: TextStyle(fontSize: 13,color: Colors.pink),
                                          children: [
                                           TextSpan(
                                             text: "${getTimeAgo(controller.list[index].createdAt!)}",
                                             style: TextStyle(color: Colors.grey)
                                           )
                                          ]
                                        )),
                                        Text(controller.list[index].chat!=null?"@${controller.list[index].chat!.user!.username} ${controller.list[index].comment}":"${controller.list[index].comment}")
                                      ],
                                    ),
                                  ),
                                  IconButton(onPressed: (){
                                    showDialog(context: context, builder: (context){
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),

                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Reply to @${controller.list[index].user!.username}"),
                                              SizedBox(height: 10,),
                                              TextFormField(
                                                controller: replyController,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "Write a comment"
                                                ),
                                              ),
                                              SizedBox(height: 30,),
                                              Row(
                                                children: [
                                                  Expanded(child: ElevatedButton(

                                                    onPressed: (){
                                                      Navigator.of(context,rootNavigator: true).pop();
                                                    },
                                                    child: Text("Cancel",style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white,fontSize: 14),)),
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Color(0xFF262324)
                                                    ),
                                                  )),
                                                  SizedBox(width: 10,),
                                                  Expanded(child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Color(0xFF77CEDA)
                                                    ),
                                                    onPressed: ()async{
                                                      if(replyController.text.isEmpty){
                                                        showToast("Please enter comment");
                                                      }
                                                      showLoaderDialog(context, "Please wait...");
                                                      var response=await sendReply(replyController.text, widget.leagueId, controller.list[index].id.toString());
                                                      Navigator.of(context).pop();
                                                      if(response.statusCode==201){
                                                        controller.getData(false, widget.leagueId);
                                                        Navigator.of(context).pop();

                                                      }else{
                                                        var data=jsonDecode(response.body);
                                                        showToast("${data['message']}");
                                                      }
                                                    },
                                                    child: Text("Yes",style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white,fontSize: 14),)),
                                                  )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  }, icon: Icon(Icons.reply))



                                ],
                              );
                            }, separatorBuilder: (context,index){
                          return SizedBox(height: 10,);
                        }, itemCount: controller.list.length),
                      );
                    }
                  })),
              Row(
                children: [
                  Expanded(child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write a comment"
                      ),
                  )),
                  SizedBox(width: 10,),
                  Container(
                    height: 50,
                    width: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFF48C4B9)
                    ),
                    child: IconButton(
                      onPressed: ()async{
                          if(messageController.text.isEmpty){
                            showToast("Please enter message");
                            return;
                          }
                           showLoaderDialog(context, "Sending post...");
                           var response=await sendMessage(messageController.text, widget.leagueId);
                           Navigator.of(context).pop();
                           messageController.text="";
                          if(response.statusCode==201){
                            controller.getData(false, widget.leagueId);
                          }else{
                            var data=jsonDecode(response.body);

                            showToast("${data['message']}");
                          }

                      },
                      icon: Icon(Icons.send,color: Colors.white,),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }

}
