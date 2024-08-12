import 'package:another_flushbar/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_sizes.dart';

class AppUtils {
  static Future<T?> showDialog<T>({
    String? text,
    BuildContext? context,
    bool? barrierDismissible,
    AlertDialog Function(BuildContext context)? builder,
  }) =>
      Get.dialog(
        AlertDialog(
          elevation: 30,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircularProgressIndicator(
                  strokeWidth: 3,
                  backgroundColor: Colors.black12,
                ),
                const SizedBox(width: 30),
                Text(text ?? ''),
              ],
            ),
          ),
        ),
      );

  static Future<bool> checkInternet() async {
    final connectionResult = await Connectivity().checkConnectivity();
    return connectionResult != ConnectivityResult.none;
  }

  static void flushbarShow(
    Color color,
    String errorText,
    BuildContext context,
  ) =>
      Flushbar<void>(
        messageText: Text(
          errorText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(20),
        flushbarPosition: FlushbarPosition.TOP,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticInOut,
        backgroundColor: color,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
        borderColor: Colors.white70,
        borderWidth: 5,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        icon: color == AppColors.red
            ? const Icon(
                Icons.error,
                color: Colors.white70,
              )
            : const Icon(
                Icons.check_circle,
                color: Colors.white70,
              ),
        duration: const Duration(seconds: 5),
      ).show(context);

  static Future showConfirmationAlert({
    required BuildContext context,
    required String titleText,
    required String contentText,
    required Function() onCancel,
    required Function() onConfirm,
  }) {
    return Get.dialog(AlertDialog(
      title: Text(
        titleText,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(contentText),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            'No',
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('Yes'),
        ),
      ],
    ));
  }

  static Future<bool?> showConfirmationAlbumAlert(
      BuildContext context, int value) {
    return Get.dialog(
      AlertDialog(
        title: const Text(
          'Finalize Album',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure do you want finalize the album with $value images',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  static final Widget loadingOverlay = Material(
    color: Colors.white.withOpacity(0.1),
    child: Center(
      child: SizedBox.square(
        dimension: AppSizes.x8_0,
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color(0xff006DFB),
          rightDotColor: const Color(0xffF8F8F8),
          size: 80,
        ),
      ),
    ),
  );

  static Future<void> poPup(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 30,
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: <Widget>[
                Expanded(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    backgroundColor: Colors.black12,
                  ),
                ),
                SizedBox(width: 30),
                Expanded(child: Text('Please Wait.....')),
              ],
            ),
          ),
        );
      },
    );
  }
}
