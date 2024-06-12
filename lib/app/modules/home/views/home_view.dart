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
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      extendBody: true,
      body: Obx(
            () =>
            IndexedStack(
              index: controller.currentIndex.value,
              children: const [
                BusinessView(),
                SettingsView(),
              ],
            ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        elevation: 0,
        backgroundColor: AppColors.blue,
        splashColor: AppColors.darkBlue,
        onPressed: controller.pack == '0'
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomAppBar(
      //   elevation: 0,
      //   notchMargin: 10,
      //   color: Colors.transparent,
      //   clipBehavior: Clip.antiAlias,
      //   shape: const CircularNotchedRectangle(),
      //   child: Container(
      //     height: width * .15,
      //     decoration: BoxDecoration(
      //         color: AppColors.blue,
      //         borderRadius:
      //             BorderRadius.vertical(top: Radius.circular(width * .08))),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         ClipRRect(
      //           borderRadius:
      //               BorderRadius.only(topLeft: Radius.circular(width * .08)),
      //           child: MaterialButton(
      //             minWidth: width * .5,
      //             height: width * .15,
      //             splashColor: Colors.transparent,
      //             onPressed: () => controller.currentIndex = 0,
      //             child: Icon(
      //               Icons.business,
      //               size: controller.currentIndex == 0 ? 35 : 20,
      //               color: controller.currentIndex == 0
      //                   ? AppColors.white
      //                   : AppColors.white.withOpacity(.2),
      //             ),
      //           ),
      //         ),
      //         Flexible(
      //           child: ClipRRect(
      //             borderRadius:
      //                 BorderRadius.only(topRight: Radius.circular(width * .08)),
      //             child: MaterialButton(
      //               minWidth: width * .5,
      //               height: width * .15,
      //               onPressed: () => controller.currentIndex = 1,
      //               child: Icon(
      //                 Icons.business_center,
      //                 size: controller.currentIndex == 1 ? 35 : 20,
      //                 color: controller.currentIndex == 1
      //                     ? AppColors.white
      //                     : AppColors.white.withOpacity(.2),
      //               ),
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
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
                () =>
                BottomNavigationBar(
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
                  items: const [
                    BottomNavigationBarItem(
                      label: 'Home',
                      icon: Icon(Icons.business),
                    ),
                    BottomNavigationBarItem(
                      label: '',
                      icon: LimitedBox(),
                    ),
                    BottomNavigationBarItem(
                      label: 'work',
                      icon: Icon(Icons.work),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}