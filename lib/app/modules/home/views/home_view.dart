import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/controllers/home_controller.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: controller.currentIndex,
        children: controller.screens,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        elevation: 0,
        backgroundColor: AppColors.blue,
        splashColor: AppColors.darkBlue,
        onPressed: controller.pack == "0"
            ? () {
          Feedback.forTap(context);
          HapticFeedback.mediumImpact();
          Get.toNamed(Routes.SUBSCRIPTION);
        }
            : () async {
          Feedback.forTap(context);
          HapticFeedback.lightImpact();
          // Navigator.of(context).push(pickimages());
          Get.toNamed(Routes.IMAGEPICKER);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          height: width * .15,
          decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(width * .08))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipRRect(
                borderRadius:
                BorderRadius.only(topLeft: Radius.circular(width * .08)),
                child: MaterialButton(
                  minWidth: width * .5,
                  height: width * .15,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    // setState(() {
                    //   currentScreen = Home();
                    //   currentIndex = 0;
                    // });
                  },
                  child: Icon(
                    Icons.business,
                    size: controller.currentIndex == 0 ? 35 : 20,
                    color: controller.currentIndex == 0 ? AppColors.white : AppColors.white.withOpacity(.2),
                  ),
                ),
              ),
              Flexible(
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.only(topRight: Radius.circular(width * .08)),
                  child: MaterialButton(
                    minWidth: width * .5,
                    height: width * .15,
                    onPressed: () {
                      // setState(() {
                      //   currentScreen = Settings();
                      //   currentIndex = 1;
                      // });
                    },
                    child: Icon(
                      Icons.business_center,
                      size: controller.currentIndex == 1 ? 35 : 20,
                      color: controller.currentIndex == 1 ? AppColors.white : AppColors.white.withOpacity(.2),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  }
