import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/create_address/controllers/create_address_controller.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/reusable_widgets/my_textformfield.dart';

class CreateAddressView extends GetView<CreateAddressController> {
  const CreateAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: <Widget>[
          Container(
            height: height * .2,
            width: width,
            color: AppColors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.translate(
                  offset: Offset(-width * .4, -height * .005),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Center(
                  child: Text(
                    'Add Address',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w300,
                          letterSpacing: .5,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    MyTextFormField(
                      hintText: 'Door No. / House No.',
                      label: 'Enter House No.',
                      icon: const Icon(Icons.home),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter House No.';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        controller.profile.doorNo = value;
                      },
                    ),
                    MyTextFormField(
                      hintText: 'Street',
                      label: 'Enter Street',
                      icon: const Icon(Icons.local_convenience_store),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter Street Name';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        controller.profile.street = value;
                      },
                    ),
                    MyTextFormField(
                      hintText: 'LandMark',
                      label: 'Enter LandMark',
                      icon: const Icon(Icons.business),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter LandMark';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        controller.profile.landMark = value;
                      },
                    ),
                    MyTextFormField(
                      hintText: 'City',
                      label: 'Enter City Name',
                      icon: const Icon(Icons.location_city),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter City Name';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        controller.profile.city = value;
                      },
                    ),
                    MyTextFormField(
                      hintText: 'PinCode',
                      label: 'Enter PinCode',
                      isNumber: true,
                      number: 6,
                      icon: const Icon(Icons.fiber_pin),
                      validator: (String? value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Enter PinCode Number';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        controller.profile.pinCode = value;
                      },
                    ),
                    const SizedBox(height: 30),
                    MyButton(
                      onPress: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.formKey.currentState!.save();
                          controller.createAddress(context);
                          Get.back();
                        }
                      },
                      btntext: 'Continue',
                      color: AppColors.blue,
                      textcolor: AppColors.white,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
