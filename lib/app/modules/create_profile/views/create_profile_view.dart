import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/create_profile/controllers/create_profile_controller.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:mygallerybook/core/reusable_widgets/my_textformfield.dart';

class CreateProfileView extends GetView<CreateProfileController> {
  const CreateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: <Widget>[
            Container(
              height: height * .25,
              width: width,
              color: AppColors.blue,
              child: Center(
                child: Text(
                  'Create Profile',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: .5,
                      ),
                ),
              ),
            ),
            Expanded(
              child: Form(
                key: controller.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: controller.getImage,
                        child: Container(
                          padding: const EdgeInsets.all(05),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColors.blue, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(.2),
                                offset: const Offset(5, 5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: controller.image == null
                              ? Image.asset(
                                  'assets/profile.png',
                                  width: 80,
                                  fit: BoxFit.cover,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    controller.image!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Upload Profile Picture',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      MyTextFormField(
                        hintText: 'First Name',
                        label: 'First Name',
                        icon: const Icon(Icons.account_circle),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter First Name';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          controller.profile.fName = value;
                        },
                      ),
                      MyTextFormField(
                        hintText: 'Last Name',
                        label: 'Last Name',
                        icon: const Icon(Icons.account_circle),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Enter Last Name';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          controller.profile.lName = value;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 06,
                          horizontal: 10,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: controller.genderSelected,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    letterSpacing: .8,
                                    color: Colors.black,
                                  ),
                          decoration: InputDecoration(
                            errorStyle:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.red,
                                    ),
                            prefixIcon: const Icon(Icons.person_pin),
                            hintText: 'Select Gender',
                            hintStyle:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 14,
                                      letterSpacing: .8,
                                      color: Colors.black.withOpacity(.4),
                                    ),
                            contentPadding: const EdgeInsets.all(20),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: AppColors.blue.withOpacity(.1),
                          ),
                          items: [
                            'Male',
                            'Female',
                            'Other',
                          ]
                              .map(
                                (label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(label),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            controller.genderSelected = value;
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please Select your Gender';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            controller.profile.gender = value;
                          },
                        ),
                      ),
                      MyTextFormField(
                        hintText: 'Email',
                        label: 'Email',
                        icon: const Icon(Icons.mail),
                        validator: controller.validateEmail,
                        onSaved: (String? value) {
                          if (value != null) {
                            controller.profile.emailId = value.trim();
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      MyButton(
                        onPress: () {
                          if (controller.image == null) {
                            AppUtils.flushbarShow(
                              AppColors.red,
                              'Please Select Proile Image',
                              context,
                            );
                          } else if (controller.formKey.currentState!
                              .validate()) {
                            controller.formKey.currentState!.save();
                            controller.createProfile();
                          }
                        },
                        btntext: 'Continue',
                        color: AppColors.blue,
                        textcolor: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultipartRequest extends http.MultipartRequest {
  MultipartRequest(
    super.method,
    super.url, {
    required this.onProgress,
  });

  final void Function(int bytes, int totalBytes) onProgress;

  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();

    final total = contentLength;
    var bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
