import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';

class OrdersProvider {
  static Future<List<Map<dynamic, dynamic>>> getOrders(
    String customerId,
  ) async {
    try {
      final isInternetAvailable = await AppUtils.checkInternet();
      if (isInternetAvailable) {
        final url = Uri.parse(AppUrls.productionHost + AppUrls.myOrder);
        final request = http.MultipartRequest('POST', url);
        request.fields['cId'] = customerId;

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
