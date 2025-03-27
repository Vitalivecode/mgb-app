import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as MyDio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/modules/order_details/widgets/flutter_counter.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:mygallerybook/core/reusable_widgets/shimmer_image.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsController extends GetxController {
  var cid;
  var aid;
  var albumId;
  var feedback;
  var pid;
  var count = 1;
  var phone = MyGalleryBookRepository.getCPhone();
  late List images;

  String? oStatus;
  String? bFinal;

  var orders;
  var address;
  var profile;
  late int length;
  var quantity = 1;
  final String url =
      Uri.parse(AppUrls.productionHost + AppUrls.orderimages).toString();
  var photos = [];
  Future? orderDetailsFuture;
  Future? profileDetailsFuture;
  Future? deliveryDetailsFuture;

  getImages() {
    String html = """
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <div style="display:flex;flex-direction:row;flex-wrap:wrap;justify-content:space-evenly;">
    """;
    for (var i = 0; i < images.length; i++) {
      html =
          "$html<img src='$url/${images[i]}' height='120' width='120' style='padding:3px'/>";
    }
    html = '$html</div>';
    return html;
  }

  Widget buildGridView() {
    return InAppWebView(
      initialData:
          InAppWebViewInitialData(data: images.isEmpty ? '' : getImages()),
    );
  }

  showWidgets(height, width, context, status, album) {
    Widget widget = const LimitedBox();
    if (status == "Delivered") {
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Quantity"),
                  Counter(
                    initialValue: quantity,
                    minValue: 1,
                    maxValue: count,
                    color: AppColors.blue,
                    step: 1,
                    onChanged: (value) {
                      quantity = value.toInt();
                      (context as Element).markNeedsBuild();
                    },
                    decimalPlaces: 0,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: width * 0.28,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                  backgroundColor: AppColors.blue,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Reorder",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  var pid = MyGalleryBookRepository.getpId();
                  var formData = MyDio.FormData.fromMap({
                    "pId": pid,
                    "oReorder": quantity,
                    "albumId": album,
                  });
                  try {
                    final dio = Dio();
                    var response = await dio.post(
                        AppUrls.productionHost + AppUrls.reOrder,
                        data: formData);
                    if (response.data.toString().trim() == "Reorder Success") {
                      AppUtils.flushbarShow(AppColors.green,
                          "Photobook reorder is successfull", context);
                    } else {
                      AppUtils.flushbarShow(
                          AppColors.red,
                          "Photobook reorder is failed because your leftover albums are low",
                          context);
                    }
                  } catch (e) {
                    AppUtils.flushbarShow(
                        AppColors.red,
                        "Something went wrong while reordering the photobook",
                        context);
                  }
                },
              ),
            ),
          ),
        ],
      );
    } else if (status == "Ordered") {
      widget = Column(
        children: [
          bFinal == "Yes"
              ? const LimitedBox()
              : images.length < 100
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                            backgroundColor: AppColors.blue,
                          ),
                          child: const Text(
                            "Add More Images",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          onPressed: () {
                            Get.toNamed(Routes.REUPLOAD_IMAGES, arguments: {
                              'aid': aid,
                              'imagesLength': images.length,
                              'albumId': album,
                              'pid': pid,
                              'cid': cid,
                            });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                            backgroundColor: AppColors.green,
                          ),
                          child: const Text(
                            "Finalize Album",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          onPressed: () {
                            bFinalized(bFinalize: "Yes");
                            orderDetails();
                          },
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                            backgroundColor: AppColors.green,
                          ),
                          child: const Text(
                            "Finalize Album",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          onPressed: () {
                            bFinalized(bFinalize: "Yes");
                            orderDetails();
                          },
                        )
                      ],
                    ),
          const SizedBox(height: 12),
          SizedBox(
            height: MediaQuery.of(context).size.height /
                3, // Adjust the height as needed
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final imageUrl = '$url/${images[index]}';
                return Stack(
                  children: [
                    const Positioned.fill(
                      child: ShimmerImage(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned.fill(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const ShimmerImage(
                              width: double.infinity,
                              height: double.infinity,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      );
    } else if (status == "Dispatched") {
      widget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 6,
              backgroundColor: AppColors.blue,
            ),
            child: const Text(
              "Track Order",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            onPressed: () async {
              try {
                final dio = Dio();
                var formdata = MyDio.FormData.fromMap({"albumId": album});
                var response = await dio.post(
                    AppUrls.productionHost + AppUrls.orderTracking,
                    data: formdata);
                var data = jsonDecode(response.toString());
                print(data.toString());
                if (await canLaunch(AppUrls.courierUrl + data["courierTI"])) {
                  await launch(AppUrls.courierUrl + data["courierTI"]);
                } else {
                  AppUtils.flushbarShow(
                    AppColors.red,
                    "Cannot able to launch the browser please try again later",
                    context,
                  );
                }
              } catch (e) {
                print(e);
                AppUtils.flushbarShow(
                  AppColors.red,
                  "Cannot able to track the order try again later",
                  context,
                );
              }
            },
          ),
        ),
      );
    }
    return widget;
  }

  orderDetails() async {
    try {
      print("orderdetails Method got called");
      var url = Uri.parse(AppUrls.productionHost + AppUrls.myOrderDetails);
      var request = http.MultipartRequest("POST", url);
      request.fields['cId'] = MyGalleryBookRepository.getCId();
      request.fields['albumId'] = albumId;
      var response = await request.send();
      var data = await response.stream.transform(utf8.decoder).join();
      orders = jsonDecode(data);
      log("this is orderDetails response:$orders");
      oStatus = orders["oStatus"];
      images = orders["UploadImages"];
      bFinal = orders["bFinal"];
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
    }
  }

  selectItem(index) {}

  getStatus(String? status) {
    print(status);
    if (status != null) {
      switch (status) {
        case "1":
          return "Ordered";
        case "2":
          return "Received";
        case "3":
          return "Printed";
        case "4":
          return "Dispatched";
        case "5":
          return "Delivered";
        default:
          return "Ordered";
      }
    } else {
      return "";
    }
  }

  deliveryDetails() async {
    var url = Uri.parse(AppUrls.productionHost + AppUrls.addressdetail);
    var request = http.MultipartRequest("POST", url);
    request.fields['aId'] = MyGalleryBookRepository.getaId();
    request.fields['aId'] = aid;
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    address = jsonDecode(data);
  }

  profileDetails() async {
    var url = Uri.parse(AppUrls.productionHost + AppUrls.getProfile);
    var request = http.MultipartRequest("POST", url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    profile = jsonDecode(data);
  }

  bFinalized({required String bFinalize}) async {
    print("beFinalized Called");
    print("${bFinalize}this is the bFinalize value");
    print(albumId.toString());
    var url = Uri.parse(AppUrls.productionHost + AppUrls.finalizedAlbum);
    var request = http.MultipartRequest("POST", url);
    request.fields['albumId'] = albumId;
    request.fields['bFinal'] = bFinalize;
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    print("${data}Albums");
  }

  @override
  void onInit() {
    final args = Get.arguments;
    aid = args['aid'];
    print("$aid for reference");
    albumId = args['albumId'];
    cid = args['cid'];
    print("$cid this is the customer id");
    feedback = args['feedback'];
    pid = args['pid'];
    photos = args["photos"];
    log("${photos}these are the photos");
    print("onInit method has been called");
    orderDetailsFuture = orderDetails();
    deliveryDetailsFuture = deliveryDetails();
    profileDetailsFuture = profileDetails();
    super.onInit();
  }
}
