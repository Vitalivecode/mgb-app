import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/create_address/models/profile.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:http/http.dart'as http;

class CreateAddressController extends GetxController {
  get context => BuildContext;



  updateid(String? id) {
      cid = id;
      print(cid);
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProfileModel profile = ProfileModel();
  String? cid;

  createAddress() async {
    AppUtils.poPup(context);
    var url = Uri.parse(AppUrls.productionHost + AppUrls.createAddress);
    var request = http.MultipartRequest("POST", url);
    request.fields['cId'] = cid!;
    request.fields['cDoorNo'] = profile.doorNo!;
    request.fields['cStreet'] = profile.street!;
    request.fields['cLandMark'] = profile.landMark!;
    request.fields['cCity'] = profile.city!;
    request.fields['cPincode'] = profile.pinCode!;
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    Get.back();
    // Navigator.of(context).pop(true);
    // Navigator.pop(context, () {
    //   setState(() {});
    // });
  }
  @override
  void onInit() {
    MyGalleryBookRepository.getCId().then(updateid);
    super.onInit();
  }
}
