import 'package:get/get.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/widgets/order_card.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
class BusinessController extends GetxController {
  String? cid;
  String? date;
  String? expireDate;
  List orders = [];
  Future? getMetaData;
  Future? list;
  var packs;
  late DateTime current;

  days() {
    final date1 = DateTime.now();
    final date2 = DateTime.parse("$expireDate");
    final differenceInDays = date2.difference(date1).inDays;
    date = ((differenceInDays / 30).round()).toString();
  }

  myOrders() async {
    var url = Uri.parse(AppUrls.productionHost + AppUrls.myOrder);
    var request = http.MultipartRequest("POST", url);
    request.fields['cId'] = cid!;
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("inital", false);
    if (data != "[]") {
      try {
        orders = jsonDecode(data);
        log(orders.toString());
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        debugPrint(e.toString());
        orders = ["Error"];
      }
    } else {
      log(data.toString());
      orders = [];
    }
  }

  Future<List?> myPack() async {
    var url = Uri.parse(AppUrls.productionHost + AppUrls.myPacks);
    var request = http.MultipartRequest("POST", url);
    request.fields['cId'] = cid!;
    var response = await request.send();
    String data1 = await response.stream.transform(utf8.decoder).join();
    var data = jsonDecode(data1);
    if (data != "[]") {
      try {
        packs = data;
        expireDate = packs[packs.length - 1]["sEndDate"].split(' ')[0];
        days();
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        debugPrint(e.toString());
      }
    } else {
      packs = null;
    }
  }

  Future<bool> onBackPressed() async {
    DateTime now = DateTime.now();
    if (current == null || now.difference(current) > Duration(seconds: 3)) {
      current = now;
      Fluttertoast.showToast(
        msg: "Press Again to Exit",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: AppColors.black,
        fontSize: 14,
        textColor: AppColors.white,
      );
      return Future.value(false);
    } else {
      Fluttertoast.cancel();
      SystemNavigator.pop();
      return true;
    }
  }

  orderAlbums() {
    List<Widget> listOrdersUI = [];
    print(orders);
    for (var index = 0;
    index < (orders.length > 2 ? 2 : orders.length);
    index++) {
      listOrdersUI.add(
        OrderCard(
          album: orders[index]["albumId"],
          color: orders[index]["oStatus"] == "1"
              ? AppColors.color1
              : orders[index]["oStatus"] == "5"
              ? AppColors.green
              : AppColors.color3,
          status: orders[index]["oStatus"] == "1"
              ? "Ordered"
              : orders[index]["oStatus"] == "2"
              ? "Received"
              : orders[index]["oStatus"] == "3"
              ? "Printed"
              : orders[index]["oStatus"] == "4"
              ? "Dispatched"
              : "Delivered",
          timages: orders[index]["NofoImages"],
          onPress: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => OrderDetails(
            //             aid: orders[index]["aId"],
            //             albumId: orders[index]["albumId"],
            //             cid: cid ?? "",
            //             feedback: orders[index]["feedback"] ?? "",
            //             pid: orders[index]["pId"],
            //           )));
          },

          image1: orders[index]["UploadImages"].asMap().containsKey(0)
              ? orders[index]["UploadImages"][0]
              : "",
          //image1: orders[index]["UploadImages"][0],
          image2: orders[index]["UploadImages"].asMap().containsKey(1)
              ? orders[index]["UploadImages"][1]
              : "",
          // image2: orders[index]["UploadImages"][1],
          image3: orders[index]["UploadImages"].length > 2
              ? orders[index]["UploadImages"][2]
              : null,
        ),
      );
    }

    return listOrdersUI;
  }
}
