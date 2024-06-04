import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';

class NoConnection extends StatefulWidget {
  const NoConnection({super.key});

  @override
  _NoConnectionState createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 100, color: AppColors.red),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "No Internet Connection",
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              btntext: "Retry",
              textcolor: AppColors.white,
              color: AppColors.red,
              border: true,
              onPress: () {
                Get.toNamed(Routes.SPLASH);
              },
            )
          ],
        ),
      )),
    );
  }
}
