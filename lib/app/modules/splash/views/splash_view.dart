import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/modules/splash/widgets/no_connection.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<bool> isInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  }

  Future<Timer> startTime() async {
    const duration = Duration(seconds: 3);
    return Timer(duration, checkFirstSeen);
  }

  Future checkFirstSeen() async {
    _fetchSessionAndNavigate();
  }

  _fetchSessionAndNavigate() async {
    if (kIsWeb) {
      if (MyGalleryBookRepository.getCId().isEmpty) {
        Get.toNamed(Routes.LOGIN);
      } else if (MyGalleryBookRepository.getCEmail().isEmpty) {
        Get.toNamed(Routes.OTP_VERIFICATION);
      } else {
        getMyPack();
      }
    } else {
      final isInternetEnable = await isInternet();
      if (isInternetEnable) {
        if (MyGalleryBookRepository.getCId().isEmpty) {
          Get.toNamed(Routes.LOGIN);
        } else if (MyGalleryBookRepository.getCEmail().isEmpty) {
          Get.toNamed(Routes.OTP_VERIFICATION);
        } else {
          getMyPack();
        }
      } else {
        Get.to(const NoConnection());
      }
    }
  }

  void getMyPack() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.myPacks);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    if (MyGalleryBookRepository.getpId().isEmpty) {
      Get.toNamed(Routes.CREATE_PROFILE);
    } else if (data != '[]') {
      final details = jsonDecode(data);
      if (details[0]['pStatus'] == '1') {
        Get.toNamed(Routes.HOME);
      } else {
        Get.toNamed(Routes.SUBSCRIPTION);
      }
    } else {
      Get.toNamed(Routes.SUBSCRIPTION);
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.blue.withOpacity(.8),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              AppColors.blue.withOpacity(.9),
              BlendMode.srcOver,
            ),
            image: const AssetImage('assets/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            const Spacer(),
            Image.asset(
              'assets/App_Icon.png',
              width: width * .6,
            ),
            const SizedBox(
              height: 10,
            ),
            const Spacer(),
            const Text(
              'Powered by Mygallerybook',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
