import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/core/app_urls.dart';

class PaymentHistoryController extends GetxController {
  late Future<List> paymentHistoryFuture;
  List paymentHistory = [];

  Future<List> getPaymentHistoryDetails() async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(AppUrls.productionHost + AppUrls.myPacks),
    );
    request.fields['cId'] = MyGalleryBookRepository.getCId() ?? '';
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    print(data);
    paymentHistory = jsonDecode(data) as List;
    return paymentHistory;
  }

  @override
  void onInit() {
    paymentHistoryFuture = getPaymentHistoryDetails();
    super.onInit();
  }
}
