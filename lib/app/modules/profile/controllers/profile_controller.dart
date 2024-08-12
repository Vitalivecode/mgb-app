import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/create_address/models/profile.dart';
import 'package:mygallerybook/app/modules/create_profile/views/create_profile_view.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/modules/settings/controllers/settings_controller.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  Future? getMetaDataFuture;
  RxBool isMetaDataLoaded = false.obs;
  String? cid;
  String? phone;
  final isupdating = false.obs;
  final settingsController = Get.find<SettingsController>();

  // var details;
  final RxMap details = RxMap();
  var address;
  final isEnable = false.obs;

  File? image;
  ProfileModel profile = ProfileModel();

  getProfile() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.getProfile);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();

    if (data.isEmpty) {
      details.value = {};
      print("there is no data for the get profile");
      return;
    }
    details.value = jsonDecode(data);
    // MyGalleryBookRepository.setUserName(details);
    log("${details}user first name and last name");
  }

  getAddress() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.getAddress);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    if (data != '[]') {
      address = jsonDecode(data);
      log("$address this is the user address");
    } else {
      print("there is no data for the getAddress");
      address = [];
    }
  }

  getMetaData() async {
    cid = MyGalleryBookRepository.getCId();
    phone = MyGalleryBookRepository.getCPhone();
    await getProfile();
    await getAddress();
    isMetaDataLoaded.value = true;
  }

  final GlobalKey<FormState> formData = GlobalKey<FormState>();

  List<Widget> getAddressListUI() {
    final addresses = <Widget>[];
    print(address);
    for (var index = 0; index < address.length; index++) {
      addresses.add(
        Card(
          elevation: 6,
          color: AppColors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              child: ListTile(
                leading: const Icon(Icons.location_city,
                    size: 30, color: AppColors.white),
                title: Text(
                  "${address[index]["cDoorNo"]}, ${address[index]["cStreet"]}, ${address[index]["cLandMark"].trim()}, ${address[index]["cCity"]},${address[index]["cPincode"]} ",
                  style: const TextStyle(fontSize: 17, color: AppColors.white),
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (addresses.isEmpty) {
      addresses.add(Container());
    }
    return addresses;
  }

  updateProfile() async {
    if (formData.currentState!.validate()) {
      isupdating.value = true;
      Future.delayed(const Duration(seconds: 2)).whenComplete(() {
        isupdating.value = false;
        isEnable.value = false;
      });
      formData.currentState!.save();
      final url = Uri.parse(AppUrls.productionHost + AppUrls.createProfile);
      final request = MultipartRequest(
        'POST',
        url,
        onProgress: (int bytes, int totalBytes) {
          final progress = bytes / totalBytes;
          print('progress: $progress ($bytes/$totalBytes)');
        },
      );
      request.fields['cId'] = MyGalleryBookRepository.getCId() ?? '';
      request.fields['cFName'] = profile.fName!;
      request.fields['cLName'] = profile.lName!;
      request.fields['cGender'] = details['cGender'] as String;
      request.fields['cEmail'] = profile.emailId!;
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'cPicture',
            image!.path,
          ),
        );
      }
      var response = await request.send();
      var data = await response.stream.transform(utf8.decoder).join();
      print(data);
      if (data.isNotEmpty) {
        details.value = jsonDecode(data);
        settingsController.getProfile();
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("pId", details["pId"]);
      prefs.setString("eMail", details['cEmail']);
    }
  }

  @override
  void onInit() {
    getMetaData();
    super.onInit();
  }
}
