import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mygallerybook/core/app_theme.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getMyGalleryBookTheme(),
    ),
  );
}
