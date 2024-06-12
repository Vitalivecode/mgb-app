import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/settings/controllers/settings_controller.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:share/share.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: controller.onBackPressed,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 30),
                height: height * .16,
                width: width,
                decoration: const BoxDecoration(
                  color: AppColors.blue,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Center(
                  child: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                          fontSize: width * .07,
                          fontWeight: FontWeight.w100,
                          letterSpacing: .5,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Container(
                    child: Text(
                      'Welcome ${controller.name}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.PROFILE);
                        },
                        child: const Card(
                          elevation: 6,
                          color: AppColors.blue,
                          shape: StadiumBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: ListTile(
                              leading: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 40,
                              ),
                              title: Text(
                                'Profile',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.PAYMENT_HISTORY);
                        },
                        child: const Card(
                          elevation: 6,
                          color: AppColors.blue,
                          shape: StadiumBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: ListTile(
                              leading: Icon(
                                Icons.account_balance_wallet,
                                color: Colors.white,
                                size: 40,
                              ),
                              title: Text(
                                'Payments',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.ALL_ORDERS);
                        },
                        child: const Card(
                          elevation: 6,
                          color: AppColors.blue,
                          shape: StadiumBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: ListTile(
                              leading: Icon(
                                Icons.subscriptions,
                                color: Colors.white,
                                size: 40,
                              ),
                              title: Text(
                                'Orders',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.SUBSCRIPTION);
                        },
                        child: const Card(
                          elevation: 6,
                          color: AppColors.blue,
                          shape: StadiumBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: ListTile(
                              leading: Icon(
                                Icons.account_balance_wallet,
                                color: Colors.white,
                                size: 40,
                              ),
                              title: Text(
                                'Subscriptions',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.CONTACT_SUPPORT);
                        },
                        child: const Card(
                          elevation: 6,
                          color: AppColors.blue,
                          shape: StadiumBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: ListTile(
                              leading: Icon(
                                Icons.help,
                                color: Colors.white,
                                size: 40,
                              ),
                              title: Text(
                                'Contact Support',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          const invitationText =
                              'Hey,\n\nMygallerbook is a fast and secure app that I use to order photobook which has beautiful photobook designs and premium quality products.\n\nGet it for free at\n';

                          if (Platform.isIOS) {
                            Share.share(
                              '${invitationText}https://apps.apple.com/us/app/id1528348936',
                            );
                          } else {
                            Share.share(
                              '${invitationText}https://play.google.com/store/apps/details?id=com.vitasoft.Mygallerybook',
                            );
                          }
                        },
                        child: const Card(
                          elevation: 6,
                          color: AppColors.blue,
                          shape: StadiumBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: ListTile(
                              leading: Icon(
                                Icons.person_add,
                                color: Colors.white,
                                size: 40,
                              ),
                              title: Text(
                                'Invite a friend',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          controller.logOut();
                        },
                        child: const Card(
                          elevation: 6,
                          color: AppColors.blue,
                          shape: StadiumBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: ListTile(
                              leading: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                                size: 40,
                              ),
                              title: Text(
                                'Logout',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
