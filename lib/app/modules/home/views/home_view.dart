import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/business/views/business_view.dart';
import 'package:mygallerybook/app/modules/home/controllers/home_controller.dart';
import 'package:mygallerybook/app/modules/settings/views/settings_view.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            BusinessView(),
            SettingsView(),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          heroTag: null,
          elevation: 0,
          backgroundColor: AppColors.blue,
          splashColor: AppColors.darkBlue,
          onPressed: controller.pack.isEmpty ||
                  controller.subscriptionEndedDate.value! < 0
              ? () {
                  Feedback.forTap(context);
                  HapticFeedback.mediumImpact();
                  Get.toNamed(Routes.SUBSCRIPTION);
                }
              : () async {
                  Feedback.forTap(context);
                  HapticFeedback.lightImpact();
                  Get.toNamed(Routes.IMAGEPICKER);
                },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(width * .08)),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          padding: EdgeInsets.zero,
          // color: Colors.transparent,
          color: AppColors.darkBlue,
          clipBehavior: Clip.antiAlias,
          child: Obx(
            () => BottomNavigationBar(
              iconSize: 28,
              elevation: 0,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              selectedItemColor: AppColors.white,
              unselectedItemColor: Colors.white38,
              backgroundColor: Colors.transparent,
              currentIndex: controller.currentIndex.value,
              onTap: (value) =>
                  controller.currentIndex.value = value.clamp(0, 1),
              items: [
                BottomNavigationBarItem(
                  label: 'business',
                  icon: Icon(
                    Icons.business,
                    size: controller.currentIndex.value == 0 ? 38 : 24,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'work',
                  icon: Icon(
                    Icons.work,
                    size: controller.currentIndex.value == 1 ? 38 : 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
