import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/modules/home/widgets/order_card.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:sp_util/sp_util.dart';

class BusinessController extends GetxController {
  final date = Rx<String?>(null);
  final expireDate = Rx<String?>(null);
  final orders = <dynamic>[].obs;
  dynamic packs;
  final current = DateTime.now().obs;

  void days() {
    final date1 = DateTime.now();
    final date2 = DateTime.parse('${expireDate.value}');
    final differenceInDays = date2.difference(date1).inDays;
    date.value = (differenceInDays / 30).round().toString();
  }

  Future<void> myOrders() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.myOrder);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    await SpUtil.putBool('inital', false);
    if (data != '[]') {
      try {
        orders
          ..clear()
          ..addAll(jsonDecode(data) as List);
        log(orders.toString());
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        debugPrint(e.toString());
      }
    } else {
      orders.clear();
    }
  }

  Future<List<dynamic>?> myPack() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.myPacks);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data1 = await response.stream.transform(utf8.decoder).join();
    final data = jsonDecode(data1);
    if (data != '[]') {
      try {
        packs = data;
        expireDate.value =
            packs[packs.length - 1]['sEndDate'].split(' ')[0].toString();
        days();
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        debugPrint(e.toString());
      }
    } else {
      packs = null;
    }
    return null;
  }

  Future<bool> onBackPressed() async {
    final now = DateTime.now();
    if (now.difference(current.value) > const Duration(seconds: 3)) {
      current.value = now;
      await Fluttertoast.showToast(
        msg: 'Press Again to Exit',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: AppColors.black,
        fontSize: 14,
        textColor: AppColors.white,
      );
      return Future.value(false);
    } else {
      await Fluttertoast.cancel();
      await SystemNavigator.pop();
      return true;
    }
  }

  List<Widget> orderAlbums() {
    final listOrdersUI = <Widget>[];
    debugPrint(orders.toString());
    for (var index = 0;
        index < (orders.length > 2 ? 2 : orders.length);
        index++) {
      listOrdersUI.add(
        OrderCard(
          album: orders[index]['albumId']?.toString() ?? '',
          color: orders[index]['oStatus'] == '1'
              ? AppColors.color1
              : orders[index]['oStatus'] == '5'
                  ? AppColors.green
                  : AppColors.color3,
          status: orders[index]['oStatus'] == '1'
              ? 'Ordered'
              : orders[index]['oStatus'] == '2'
                  ? 'Received'
                  : orders[index]['oStatus'] == '3'
                      ? 'Printed'
                      : orders[index]['oStatus'] == '4'
                          ? 'Dispatched'
                          : 'Delivered',
          timages: orders[index]['NofoImages'] as int,
          onPress: () {
            Get.toNamed(Routes.ORDER_DETAILS, arguments: {
              "aid": orders[index]["aId"],
              "albumId": orders[index]["albumId"],
              "cid": MyGalleryBookRepository.getCId,
              "feedback": orders[index]["feedback"],
              "pid": orders[index]["pId"],
            });
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

          image1: (orders[index]['UploadImages'] as Map).containsKey(0)
              ? orders[index]['UploadImages'][0].toString()
              : '',
          //image1: orders[index]["UploadImages"][0],
          image2: (orders[index]['UploadImages'] as Map).containsKey(1)
              ? orders[index]['UploadImages'][1].toString()
              : '',
          // image2: orders[index]["UploadImages"][1],
          image3: (orders[index]['UploadImages'] as List).length > 2
              ? orders[index]['UploadImages'][2].toString()
              : null,
        ),
      );
    }

    return listOrdersUI;
  }

  @override
  void onInit() {
    myPack();
    myOrders();
    log("These are the packs data $packs");
    super.onInit();
  }
}
