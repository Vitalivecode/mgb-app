import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

class PaymentController extends GetxController {
  int totalamount = 0;
  Razorpay? _razorpay;
  var selectedpack, pack;


  String? phone, email, cid, btntext = "Pay Securly";
  Color? mycolor;

  get context => BuildContext;

  updatecid(String? id) {
      cid = id;
  }

  updatecphone(String? phone) {
      phone = phone;
  }

  updatecemail(String? email) {
      email = email;
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  void openCheckout(amount) async {
    var options = {
      'key': 'rzp_live_auFW5yy8TzDkPk',
      'amount': amount * 100,
      'name': 'My Gallerybook!',
      'description': 'My Gallerybook Subscription',
      'prefill': {'contact': phone, 'email': email},
      'extrenal': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay?.open(options);
    } catch (e) {
      // debugPrint(e);
    }
  }

  bool pay = false;

  buySubscription(String payid) async {
    print(payid);
    var url = Uri.parse(AppUrls.productionHost + AppUrls.payment);
    print(url);

    var request = http.MultipartRequest("POST", url);
    request.fields['cId'] = cid!;
    request.fields['sId'] = selectedpack[pack]["sId"];
    request.fields['sMonths'] = selectedpack[pack]["sMonths"];
    request.fields['sRemainAlbums'] = selectedpack[pack]["sAlbums"];
    request.fields['amountPaid'] =
    int.parse(selectedpack[pack]["sOfferCost"]) > 0
        ? selectedpack[pack]["sOfferCost"]
        : selectedpack[pack]["sCost"];
    request.fields['transactionID'] = payid;
    print(request.fields.toString());
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    print(data);
    print("StatusCode:${response.statusCode}");
    if (response.statusCode == 200) {
      var details;
        details = jsonDecode(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("payment", details["payment"]["pId"]);
    } else {
        var datai = jsonDecode(data);
        print(datai);
      print(response.statusCode);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response.paymentId);
    buySubscription(response.paymentId!);
    AppUtils.flushBarshow("Success:${response.paymentId!}", context, AppColors.green);
      mycolor = AppColors.green;
      btntext = "Please Wait";
      pay = true;
    Future.delayed(const Duration(milliseconds: 5000), () {
      Get.toNamed(Routes.HOME);
      // Navigator.of(context).pushReplacement(homepageroute());
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    AppUtils.flushBarshow("ERROR:${response.code}-${response.message!}",
        context, AppColors.red);
      mycolor = AppColors.red;
      btntext = "Try Again";
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    AppUtils.flushBarshow("External Wallet${response.walletName!}", context, AppColors.color3);
  }
  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      // selectedpack = data;
      // pack = index;
      // mycolor = color;
      print(pack);
      print(selectedpack[pack]["sId"]);
    MyGalleryBookRepository.getCPhone().then(updatecphone);
    MyGalleryBookRepository.getCEmail().then(updatecemail);
    MyGalleryBookRepository.getCId().then(updatecid);
    }
}
