import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/app/modules/templates/controllers/templates_controller.dart';
import 'package:mygallerybook/app/modules/templates/widgets/spinner_widget.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TemplatesView extends GetView<TemplatesController> {
  const TemplatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(),
      body: Stack(
        children: [
          Center(
            child: controller.isLoading
                ? const CircularProgressIndicator()
                : controller.getdata > 200
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/soon.png',
                            width: width * .5,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Coming Soon',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: AppColors.blue, fontSize: 23),
                          ),
                          const SizedBox(height: 20),
                          MyButton(
                            btntext: 'Go Back',
                            color: AppColors.blue,
                            textcolor: AppColors.white,
                            onPress: () {
                              Get.back();
                            },
                          ),
                        ],
                      )
                    : Column(
                        children: [Expanded(child: getWebViewWidget())],
                      ),
          ),
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: controller.isSpinnerLoading,
            child: SpinnerWidget.getSpinnerWidget(),
          ),
        ],
      ),
    );
  }

  Widget getWebViewWidget() {
    return Stack(
      children: <Widget>[
        if (controller.webController != null)
          WebViewWidget(
            controller: controller.webController!,
            // Added gestureReconizers on 25th May, 2023 to fix scroll issue.
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                EagerGestureRecognizer.new,
              ),
            },
          )
        else
          Container(),
      ],
    );
  }
}
