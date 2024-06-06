import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  var name;

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var cid = await MyGalleryBookRepository.getCId();
    print(cid);
      name = "${pref.getString("firstName")} ${pref.getString("lastName")!}";
  }
  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("cid");
    prefs.remove("eMail");
    prefs.remove('cPhone');
    Get.offAndToNamed(Routes.LOGIN);
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (BuildContext context) => const Login()),
    //   ModalRoute.withName('/'),
    // );
  }
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? cid;

  DateTime? current;
  Future<bool> onBackPressed() async {
    DateTime now = DateTime.now();
    if (current == null || now.difference(current!) > const Duration(seconds: 3)) {
      current = now;
      Fluttertoast.showToast(
        msg: "Press Again to Exit",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: AppColors.black,
        fontSize: 14,
        textColor: Colors.white,
      );
      return Future.value(false);
    } else {
      Fluttertoast.cancel();
      SystemNavigator.pop();
      return true;
    }
  }
}
