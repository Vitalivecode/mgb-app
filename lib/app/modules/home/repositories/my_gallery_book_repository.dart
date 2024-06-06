import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyGalleryBookRepository extends GetxController {
  static Future<String> getCId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = prefs.getString('cid');
    return cid ?? "";
  }

  static Future<String> getCPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cPhone = prefs.getString('cPhone');
    return cPhone ?? "";
  }

  static Future<String> getCEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cEmail = prefs.getString('eMail');
    return cEmail ?? "";
  }

  static Future<String> getpId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pId = prefs.getString('pId');
    return pId ?? "";
  }

  static Future<String> getaId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? aId = prefs.getString('aId');
    return aId ?? "";
  }

  static Future<String> getpayId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? payment = prefs.getString('payment');
    return payment ?? "";
  }

  static setUserName(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("firstName", data["cFName"]);
    prefs.setString("lastName", data["cLName"]);
  }
}
