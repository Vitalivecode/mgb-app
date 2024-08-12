import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:mygallerybook/app/modules/business/controllers/business_controller.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderAlbumController extends GetxController {
  final addressIndex = 0.obs;
  final RxList<File> images = RxList<File>([]);
  final quantity = 1.obs;
  final notes = TextEditingController();
  final profileDetail = Rx<String?>(null);
  final count = 1.obs;
  final isAlbumPrint = false.obs;
  var files;
  final isLoading = false.obs;
  final percentage = 0.0.obs;
  final sentBytes = 0.obs;
  final totalBytes = 0.obs;
  String? aid;
  String? pid;
  String? uploadText = 'Uploading Images...';
  final selectedItem = (-1).obs;
  final details = RxList<Map<String, dynamic>>([]);
  final profile = Rx<Map<String, dynamic>>({});

  Future<List<dynamic>> getLatestAlbum() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.myOrder);
    final request = http.MultipartRequest('POST', url);
    final cid = MyGalleryBookRepository.getCId();
    request.fields['cId'] = cid;
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    final List orders = json.decode(data) as List<dynamic>;
    return orders;
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  selectItem(index) {
    selectedItem.value = index;
    aid = details[index]['aId'] as String;
    print('aid ==== $aid');
    update();
  }

  void imagegs() async {
    if (aid == null) {
      AppUtils.flushbarShow(
        AppColors.red,
        "Please Select Delivery Address",
        Get.context!,
      );
      return;
    }
    isLoading.value = true;
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://www.mygallerybook.com/order'),
      );

      request.fields.addAll({
        'cId': MyGalleryBookRepository.getCId(),
        'pId': pid!,
        'aId': aid!,
        'oQuantity': quantity.value.toString(),
        'oNote': notes.text,
      });

      for (var file in images) {
        String mimeType =
            lookupMimeType(file.path) ?? 'application/octet-stream';
        String fileName = path.basename(file.path);
        request.files.add(
          await http.MultipartFile.fromPath(
            'image[]',
            file.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      http.StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        print(value);
        if (response.statusCode == 200) {
          void updateBusinessController() {
            final businessController = Get.find<BusinessController>();
            businessController.myPack();
            businessController.orderAlbums();
            businessController.myOrders();
            businessController.listOrdersUI.refresh();
            businessController.orders.refresh();
          }

          if (value.toLowerCase().contains("next month")) {
            updateBusinessController();
            AppUtils.flushbarShow(AppColors.color3, value, Get.context!);
            isLoading.value = false;
            uploadText = value;
            Future.delayed(const Duration(milliseconds: 2500), () {
              Get.offAllNamed(Routes.HOME);
            });
          } else if (value.toLowerCase().contains("closed")) {
            updateBusinessController();
            AppUtils.flushbarShow(AppColors.color3, value, Get.context!);
            isLoading.value = false;
            uploadText = value;
            Future.delayed(const Duration(milliseconds: 2500), () {
              Get.offAllNamed(Routes.HOME);
            });
          } else if (value.contains(RegExp(r'Success', caseSensitive: false))) {
            updateBusinessController();
            AppUtils.flushbarShow(
              AppColors.green,
              "$value Images Uploaded",
              Get.context!,
            );
            isLoading.value = false;
            uploadText = value;
            Future.delayed(const Duration(milliseconds: 2000), () async {
              await _deleteAppDir();
              Get.toNamed(Routes.HOME);
            });
          } else if (RegExp(
                  r'\b(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25)\b')
              .hasMatch(value)) {
            updateBusinessController();
            AppUtils.flushbarShow(
              AppColors.green,
              "$value Images Uploaded",
              Get.context!,
            );
            isLoading.value = false;
            uploadText = value;
            Future.delayed(const Duration(milliseconds: 2000), () async {
              await _deleteAppDir();
              Get.toNamed(Routes.HOME);
            });
          } else {
            updateBusinessController();
            AppUtils.flushbarShow(
              AppColors.red,
              "Unexpected Response: $value",
              Get.context!,
            );
            uploadText = value;
            Future.delayed(const Duration(milliseconds: 2000), () async {
              await _deleteAppDir();
              Get.toNamed(Routes.HOME);
            });
          }
        } else {
          AppUtils.flushbarShow(
            AppColors.red,
            "Error: ${response.reasonPhrase}",
            Get.context!,
          );
        }
      });
    } catch (e) {
      print("Error during image upload: $e");
      AppUtils.flushbarShow(
        AppColors.red,
        "Image upload failed",
        Get.context!,
      );
    } finally {
      isLoading.value = false;
    }
  }

  getAddress() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.getAddress);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    if (data != '[]') {
      log("this is the get address details${jsonDecode(data)}");
      details.value = List<Map<String, dynamic>>.from(jsonDecode(data));
    } else {
      details.value = [];
      Get.toNamed(Routes.CREATE_ADDRESS);
    }
  }

  getsubscription() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.myPacks);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    if (data != '[]') {
      final details = jsonDecode(data);
      pid = details[details.length - 1]['pId'].toString();
    }
  }

  getProfile() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.getProfile);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    log('$data this is the profiles data');
    profile.value = jsonDecode(data);
    log("${profile.value}after jsonDecode");
    profileDetail.value =
        "${profile.value["cFName"]} ${profile.value["cLName"]},\n${MyGalleryBookRepository.getCPhone()},\n${profile.value["cEmail"]}";
  }

  @override
  void onInit() {
    print("OrderAlbum OnInit has been called");
    SharedPreferences.getInstance().then((value) {
      count.value = value.getInt('albumCount') ?? 1;
      files = Get.arguments;
      images.value = files;
      getProfile();
      getAddress();
      getsubscription();
      super.onInit();
    });
  }
}
