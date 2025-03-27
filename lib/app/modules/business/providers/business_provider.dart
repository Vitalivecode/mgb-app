import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';

class BusinessProvider {
  static Future<List<Map<dynamic, dynamic>>> myOrders() async {
    try {
      final isInternetAvaliable = await AppUtils.checkInternet();
      if (isInternetAvaliable) {
        final url = Uri.parse(AppUrls.productionHost + AppUrls.myOrder);
        final request = http.MultipartRequest('POST', url);
        request.fields['cId'] = MyGalleryBookRepository.getCId();
        final response = await request.send();
        final data =
            jsonDecode(await response.stream.transform(utf8.decoder).join());
        return data as List<Map>;
      } else {
        throw 'No Internet Connection';
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw e.toString();
    }
  }

  static Future<List<Map<dynamic, dynamic>>> myPack() async {
    try {
      final isInternetAvaliable = await AppUtils.checkInternet();
      if (isInternetAvaliable) {
        final url = Uri.parse(AppUrls.productionHost + AppUrls.myPacks);
        final request = http.MultipartRequest('POST', url);
        request.fields['cId'] = MyGalleryBookRepository.getCId();
        final response = await request.send();
        final data =
            jsonDecode(await response.stream.transform(utf8.decoder).join());
        return data as List<Map>;
      } else {
        throw 'No Internet Connection';
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw e.toString();
    }
  }
}
