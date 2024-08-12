import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/modules/home/widgets/order_card.dart';
import 'package:mygallerybook/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:mygallerybook/app/modules/order_details/views/order_details_view.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:sp_util/sp_util.dart';

class BusinessController extends GetxController {
  final date = Rx<String?>(null);
  final day = Rx<String?>(null);
  final expireDate = Rx<String?>(null);
  final orders = <dynamic>[].obs;
  Rx<List<dynamic>> packs = Rx<List<dynamic>>([]);
  final subscriptionEndedDate = Rx<int?>(0);
  final current = DateTime.now().obs;
  final differenceInDays = Rx<int?>(0);
  final RxList<Widget> listOrdersUI = <Widget>[].obs;

  void days() {
    final date1 = DateTime.now();
    final date2 = DateTime.parse('${expireDate.value}');
    differenceInDays.value = date2.difference(date1).inDays;
    print("${differenceInDays.value} these are the days left");
    if (differenceInDays.value! < 30 && differenceInDays.value! > 0) {
      day.value = differenceInDays.value.toString();
      subscriptionEndedDate.value = int.tryParse(day.value ?? '0');
    } else {
      date.value = (differenceInDays / 30)?.round().toString();
      subscriptionEndedDate.value = int.tryParse(date.value ?? '0');
    }
    print("${subscriptionEndedDate.value}this is the subscription Ended month");
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
        log("${orders[0]['UploadImages'][0]}    this is for checking the first image is coming or not");
        log("${orders[0]['UploadImages'][1]}    this is for checking the second image is coming or not");
        log("${orders[0]['UploadImages'][2]}    this is for checking the third image is coming or not");
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        debugPrint(e.toString());
      }
    } else {
      orders.clear();
    }
  }

  Future<List<dynamic>?> myPack() async {
    log("Hello!!");
    final url = Uri.parse(AppUrls.productionHost + AppUrls.myPacks);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data1 = await response.stream.transform(utf8.decoder).join();
    final data = jsonDecode(data1)[0];
    log("${data}we are printing the packs data");
    log(data["pId"] + "this is the person id ");
    if (data != '[]') {
      try {
        packs.value = RxList.of(jsonDecode(data1)) as List<dynamic>;
        log("${packs.value}this is for checking");
        expireDate.value = packs.value[packs.value.length - 1]['sEndDate']
            .split(' ')[0]
            .toString();
        days();
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        debugPrint(e.toString());
      }
    } else {
      packs.value = [];
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
    debugPrint(orders.toString());
    listOrdersUI.clear();
    for (int index = 0;
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
            log("this is addressId ${orders[index]["aId"]} for reference");
            log("this is the loggedIn person Id ${MyGalleryBookRepository.getaId()}");
            log("this is albumId ${orders[index]["albumId"]} for reference");
            log("this is feedback ${orders[index]["feedback"]} for reference");
            Get.lazyPut(() => OrderDetailsController());
            Get.to(
              const OrderDetailsView(),
              arguments: {
                "aid": orders[index]["aId"],
                "albumId": orders[index]["albumId"],
                "cid": orders[index]["cId"],
                "feedback": orders[index]["feedback"],
                "pid": orders[index]["pId"],
                "photos": orders[index]["UploadImages"],
              },
              transition: Transition.downToUp,
              duration: 300.milliseconds,
            );
            // Get.toNamed(Routes.ORDER_DETAILS, arguments: {
            //   "aid": orders[index]["aId"],
            //   "albumId": orders[index]["albumId"],
            //   "cid": orders[index]["cId"],
            //   "feedback": orders[index]["feedback"],
            //   "pid": orders[index]["pId"],
            //   "photos": orders[index]["UploadImages"],
            // });
          },
          image1: orders[index]["UploadImages"].asMap().containsKey(0)
              ? orders[index]["UploadImages"][0]
              : "",
          image2: orders[index]["UploadImages"].asMap().containsKey(1)
              ? orders[index]["UploadImages"][1]
              : "",
          image3: orders[index]["UploadImages"].length > 2
              ? orders[index]["UploadImages"][2]
              : null,
          image4: orders[index]["UploadImages"].length > 3
              ? orders[index]["UploadImages"][3]
              : null,
        ),
      );
    }
    return listOrdersUI;
  }

  @override
  void onInit() {
    log("onInitCalled");
    myPack();
    myOrders();
    orderAlbums();
    log("${packs.toString()} this is after call the myPack");
    super.onInit();
  }
}
