import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';

class AppUtils {
  static Future<T?> showDialog<T>(
          { String? text,
           context,
           AlertDialog Function(BuildContext context)? builder,  bool? barrierDismissible}) =>
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
                Text(text??"")
              ],
            ),
          ),
        ),
      );

  static flushBarshow(String _errorText, context, Color color) {
    Flushbar(
      messageText: Text(
        _errorText,
        style: const TextStyle(
            fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(20),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticInOut,
      backgroundColor: color,
      boxShadows: [
        BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: const Offset(0.0, 2.0),
            blurRadius: 6.0)
      ],
      borderColor: Colors.white70,
      borderWidth: 5,
      isDismissible: true,
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
  }

 static showConfirmationAlert(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm Upload"),
            content: const Text(
                "Are you sure do you want to continue to upload the images?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.ORDER_ALBUM);
                    // Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => OrderAlbum(
                    //           images: fileImageArray,
                    //         )));
                  },
                  child: const Text("Confirm")),
              TextButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Get.back();
                  },
                  child: const Text("Cancel"))
            ],
          );
        },
    );
  }
 static poPup(context) {
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
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const Row(
                children: <Widget>[
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    backgroundColor: Colors.black12,
                  ),
                  SizedBox(width: 30),
                  Text('Please Wait.....')
                ],
              ),
            ),
          );
        });
  }
}
