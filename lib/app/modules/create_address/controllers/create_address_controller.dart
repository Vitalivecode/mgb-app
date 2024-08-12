import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/create_address/models/profile.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';

class CreateAddressController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProfileModel profile = ProfileModel();

  createAddress(BuildContext context) async {
    AppUtils.poPup(context);
    final url = Uri.parse(AppUrls.productionHost + AppUrls.createAddress);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    request.fields['cDoorNo'] = profile.doorNo!;
    request.fields['cStreet'] = profile.street!;
    request.fields['cLandMark'] = profile.landMark!;
    request.fields['cCity'] = profile.city!;
    request.fields['cPincode'] = profile.pinCode!;
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    Get.back();
  }

}
