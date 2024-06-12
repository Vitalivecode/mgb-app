import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/create_address/models/profile.dart';
import 'package:mygallerybook/app/modules/create_profile/views/create_profile_view.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';

class ProfileController extends GetxController {
  Future? getMetaDataFuture;
  String? cid;
  String? phone;
  var details;
  var address;
  bool isEnable = false;
  File? image;
  ProfileModel profile = ProfileModel();

  getProfile() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.getProfile);
    final request = http.MultipartRequest('POST', url);
    print('for name we are printing the request $request');
    request.fields['cId'] = cid!;
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    details = jsonDecode(data);
    MyGalleryBookRepository.setUserName(details as Map<String, String>);
  }

  getAddress() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.getAddress);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = cid!;
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    if (data != '[]') {
      address = jsonDecode(data);
    } else {
      details = null;
    }
  }

  getMetaData() async {
    cid = await MyGalleryBookRepository.getCId();
    phone = await MyGalleryBookRepository.getCPhone();
    await getProfile();
    await getAddress();
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
            child: Container(
              child: ListTile(
                leading: const Icon(Icons.location_city,
                    size: 30, color: AppColors.white),
                title: Text(
                  "${address[index]["cDoorNo"]}, ${address[index]["cStreet"]}, ${address[index]["cLandMark"]
                      .trim()}, ${address[index]["cCity"]},${address[index]["cPincode"]} ",
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
      request.fields['cId'] = await MyGalleryBookRepository.getCId() ?? '';
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
    }
  }

  @override
  void onInit() {
    getMetaDataFuture = getMetaData();
    super.onInit();
  }
}
