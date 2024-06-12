import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/modules/order_album/widgets/address_card.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderAlbumController extends GetxController {
  late final List<File> images;
  int quantity = 1;
  TextEditingController notes = TextEditingController();
  int count = 1;
  var files;
  bool isLoading = false;
  double percentage = 0;
  int sentbytes = 0;
  int totalbytes = 0;
  String? aid;
  String? pid;
  String? profileDetail;
  String? uploadtext = 'Uploading Images...';

  int? _selectedItem;

  Future<List<dynamic>> getLatestAlbum() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.myOrder);
    final request = http.MultipartRequest('POST', url);
    final cid = await MyGalleryBookRepository.getCId();
    request.fields['cId'] = cid;
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    final List orders = json.decode(data) as List<dynamic>;
    return orders;
  }

  selectItem(index) {
    _selectedItem = index as int;
    aid = details[index]['aId'] as String;
    print('aid ==== $aid');
  }

  // imagegs(context) async {
  //   if (aid == null) {
  //     AppUtils.flushBarshow(
  //         "Please Select Delivery Address", context, AppColors.red);
  //   } else {
  //     _isLoading = true;
  //     var url =
  //         Uri.parse(AppUrls.productionHost + AppUrls.albumOrder).toString();
  //
  //     // Dio dio = Dio();
  //     List<myDio.MultipartFile> filesarray = [];
  //     for (var i = 0; i < files.length; i++) {
  //       filesarray.add(myDio.MultipartFile.fromFileSync(files[i].path,
  //           filename: files[i].path.split('/').last,
  //           contentType: MediaType(
  //               "image", files[i].path.split('/').last.split(".")[1])));
  //       print(files[i].path.split('/').last);
  //       print(files[i].path.split('/').last.split(".")[1]);
  //     }
  //     var formData = myDio.FormData.fromMap({
  //       "cId": cid,
  //       "aId": aid,
  //       "pId": pid,
  //       "image": filesarray,
  //       "oQuantity": quantity,
  //       "oNote": notes.text == null ? "" : notes.text
  //     });
  //     var response = await myDio.Dio().post(url, data: formData,
  //         onSendProgress: (int sent, int total) {
  //       final progress = sent / total;
  //       sentbytes = sent;
  //       totalbytes = total;
  //       percentage = progress;
  //       percentage == 1.0
  //           ? uploadtext = "Please Wait, Accepting Order..."
  //           : uploadtext = "Uploading Images...";
  //       print(progress);
  //     });
  //     print(response.data);
  //     if ((response.data)
  //         .toString()
  //         .toLowerCase()
  //         .contains("next month".toLowerCase())) {
  //       AppUtils.flushBarshow(response.data, context, AppColors.color3);
  //       _isLoading = false;
  //       uploadtext = response.data;
  //       Future.delayed(const Duration(milliseconds: 2500), () {
  //         Get.toNamed(Routes.HOME);
  //       });
  //     } else if ((response.data)
  //         .toString()
  //         .toLowerCase()
  //         .contains("closed".toLowerCase())) {
  //       AppUtils.flushBarshow(response.data, context, AppColors.color3);
  //       _isLoading = false;
  //       uploadtext = response.data;
  //       Future.delayed(const Duration(milliseconds: 2500), () {
  //         Get.toNamed(Routes.HOME);
  //       });
  //     } else if ((response.data)
  //         .toString()
  //         .contains(new RegExp(r'Success', caseSensitive: false))) {
  //       AppUtils.flushBarshow(response.data.toString() + "Images Uploaded",
  //           context, AppColors.green);
  //       _isLoading = false;
  //       uploadtext = response.data;
  //       Future.delayed(const Duration(milliseconds: 2000), () async {
  //         await _deleteAppDir();
  //         await _deleteCacheDir();
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (context) => BottomBar()),
  //             (route) => route.settings.name == 'BottomBar');
  //       });
  //     } else {
  //       print(response.data);
  //       AppUtils.flushBarshow("Something Went Wrong", context, AppColors.red);
  //       uploadtext = response.data;
  //     }
  //   }
  // }

  Future<void> _deleteCacheDir() async {
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

  List details = [];
  var profile;

  getAddress() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.getAddress);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    if (data != '[]') {
      details = jsonDecode(data) as List;
    } else {
      details = [];
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
    profile = jsonDecode(data);
    profileDetail =
        "${profile["cFName"]} ${profile["cLName"]},\n${MyGalleryBookRepository.getCPhone()},\n${profile["cEmail"]}";
  }

  List<Widget> getAddressListUI() {
    final listUI = <Widget>[];
    for (var index = 0; index < details.length; index++) {
      listUI.add(
        CustomItem(
          selectItem: selectItem,
          // callback function, setstate for parent
          index: index,
          profileDetail: profileDetail ?? '',
          address:
              "${details[index]["cDoorNo"]},\n${details[index]["cStreet"]},\n${details[index]["cLandMark"]},\n${details[index]["cCity"]},\n${details[index]["cPincode"]} ",
          isSelected: _selectedItem == index ? true : false,
        ),
      );
    }
    return listUI;
  }

  @override
  void onInit() {
    SharedPreferences.getInstance().then((value) {
      count = value.getInt('albumCount') ?? 1;
      files = images;
      print('fileimage array is $files');
      getProfile();
      getAddress();
      getsubscription();
      super.onInit();
    });
  }
}
