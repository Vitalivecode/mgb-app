import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mygallerybook/app/modules/create_address/models/profile.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/modules/order_album/views/order_album_view.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateProfileController extends GetxController {
  File? image;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProfileModel profile = ProfileModel();
  String? genderSelected;

  addImage() async {
    image = await getImageFileFromAssets('profile.png');
  }

  final picker = ImagePicker();

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  Future getImage() async {
    image = null;

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    image = File(pickedFile!.path);
  }

  createProfile(BuildContext context) async {
    AppUtils.poPup(context);
    final url = Uri.parse(AppUrls.productionHost + AppUrls.createProfile);
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    request.fields['cFName'] = profile.fName!;
    request.fields['cLName'] = profile.lName!;
    request.fields['cGender'] = profile.gender!;
    request.fields['cEmail'] = profile.emailId!;
    image ??= await getImageFileFromAssets('profile.png');
    request.files.add(
      await http.MultipartFile.fromPath(
        'cPicture',
        image!.path,
      ),
    );
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    print(data);
    var details;
    details = jsonDecode(data);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('pId', details['pId'].toString());
    prefs.setString('eMail', details['cEmail'].toString());
    Get.toNamed(Routes.SUBSCRIPTION);
  }

  String? validateEmail(String? value) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[  0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value!.trim())) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  @override
  void onInit() {
    addImage();
    super.onInit();
  }
}
