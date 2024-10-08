import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygallerybook/app/modules/profile/controllers/profile_controller.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Obx(
          () => controller.isMetaDataLoaded.value == true
              ? FutureBuilder(
                  future: controller.getMetaDataFuture,
                  builder: (BuildContext context, AsyncSnapshot snp) {
                    return ListView(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 30),
                          height: height * .16,
                          width: width,
                          decoration: const BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'My Profile',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: AppColors.white,
                                    fontSize: width * .07,
                                    fontWeight: FontWeight.w100,
                                    letterSpacing: .5,
                                  ),
                            ),
                          ),
                        ),
                        if (controller.details.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: const LinearProgressIndicator(
                                  minHeight: 5,
                                ),
                              ),
                            ),
                          )
                        else
                          Obx(
                            () => Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 30),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: controller.isEnable.value
                                          ? Colors.blue
                                          : Colors.grey,
                                      onPressed: () {
                                        controller.isEnable.value =
                                            !controller.isEnable.value;
                                        print(controller.isEnable.value);
                                      },
                                    ),
                                  ),
                                ),
                                Form(
                                  key: controller.formData,
                                  child: Wrap(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: width * 0.15,
                                          horizontal: 8,
                                        ),
                                        child: InkWell(
                                          onTap: controller.isEnable.value
                                              ? () async {
                                                  final image =
                                                      await ImagePicker()
                                                          .pickImage(
                                                    source: ImageSource.gallery,
                                                  );
                                                  controller.image =
                                                      File(image!.path);
                                                }
                                              : () {},
                                          child: Container(
                                            width: width * 0.25,
                                            height: height * 0.18,
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              image: const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                  'assets/profile.png',
                                                ),
                                              ),
                                              border: Border.all(
                                                color: AppColors.blue,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.black
                                                      .withOpacity(.2),
                                                  offset: const Offset(5, 5),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 35,
                                        ),
                                        child: Obx(
                                          () => Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: SizedBox(
                                                  width: width * 0.6,
                                                  child: TextFormField(
                                                    enabled: controller
                                                        .isEnable.value,
                                                    initialValue: controller
                                                            .details.isNotEmpty
                                                        ? controller
                                                            .details['cFName']
                                                        : '',
                                                    validator: (value) {
                                                      if (value == '') {
                                                        return 'Please enter the first name';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      controller.profile.fName =
                                                          value;
                                                    },
                                                    decoration: InputDecoration(
                                                      border: controller
                                                              .isEnable.value
                                                          ? const OutlineInputBorder()
                                                          : InputBorder.none,
                                                      labelText: 'First Name',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: SizedBox(
                                                  width: width * 0.6,
                                                  child: TextFormField(
                                                    enabled: controller
                                                        .isEnable.value,
                                                    initialValue: controller
                                                            .details['cLName']
                                                        as String,
                                                    validator: (value) {
                                                      if (value == '') {
                                                        return 'Please enter the last name';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      controller.profile.lName =
                                                          value;
                                                    },
                                                    decoration: InputDecoration(
                                                      border: controller
                                                              .isEnable.value
                                                          ? const OutlineInputBorder()
                                                          : InputBorder.none,
                                                      labelText: 'Last Name',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: SizedBox(
                                                  width: width * 0.6,
                                                  child: TextFormField(
                                                    enabled: controller
                                                        .isEnable.value,
                                                    initialValue: controller
                                                            .details['cEmail']
                                                        as String,
                                                    validator: (value) {
                                                      if (value == '') {
                                                        return 'Please enter the email';
                                                      }
                                                      if (!(value!.isEmail)) {
                                                        return 'Please enter a valid email';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      controller.profile
                                                          .emailId = value;
                                                    },
                                                    decoration: InputDecoration(
                                                      border: controller
                                                              .isEnable.value
                                                          ? const OutlineInputBorder()
                                                          : InputBorder.none,
                                                      labelText: 'Email',
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
                                const SizedBox(height: 20),
                                if (controller.isEnable.value)
                                  SizedBox(
                                    height: 50,
                                    width: width * 0.6,
                                    child: ElevatedButton(
                                      // shape: StadiumBorder(),

                                      style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        backgroundColor: AppColors.blue,
                                      ),
                                      onPressed: () {
                                        controller.updateProfile();
                                      },
                                      child: controller.isupdating.value
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text(
                                              'Update',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                    ),
                                  )
                                else
                                  Container(),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        'My Addresses',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: ElevatedButton(
                                          // shape: StadiumBorder(),

                                          style: ElevatedButton.styleFrom(
                                            shape: const StadiumBorder(),
                                            backgroundColor: AppColors.blue,
                                          ),
                                          onPressed: () {
                                            Get.toNamed(Routes.CREATE_ADDRESS);
                                          },
                                          child: const Text(
                                            'Add Address',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: controller.getAddressListUI(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                )
              : const Center(
                  child:
                      CircularProgressIndicator(), // Show a circular progress indicator while loading
                ),
        ),
      ),
    );
  }
}
