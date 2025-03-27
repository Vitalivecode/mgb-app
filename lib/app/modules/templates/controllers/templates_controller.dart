import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class TemplatesController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  WebViewController? webController;
  var getdata;
  String url = 'http://mygallerybook.com/templates';

  bool isLoading = true;

  hey() async {
    final response = await http.head(Uri.parse(url));
    print(response.statusCode);
    getdata = response.statusCode;
    isLoading = false;
  }

  bool isSpinnerLoading = false;

  void loadCircularProgressIndicator() {
    if (isSpinnerLoading == true) {
      isSpinnerLoading = false;
    } else {
      isSpinnerLoading = true;
    }
  }

  @override
  void onInit() {
    hey();
    super.onInit();
  }
}
