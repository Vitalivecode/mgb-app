import 'package:get/get.dart';

import '../modules/all_orders/bindings/all_orders_binding.dart';
import '../modules/all_orders/views/all_orders_view.dart';
import '../modules/business/bindings/business_binding.dart';
import '../modules/business/views/business_view.dart';
import '../modules/contact_support/bindings/contact_support_binding.dart';
import '../modules/contact_support/views/contact_support_view.dart';
import '../modules/create_address/bindings/create_address_binding.dart';
import '../modules/create_address/views/create_address_view.dart';
import '../modules/create_profile/bindings/create_profile_binding.dart';
import '../modules/create_profile/views/create_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/imagepicker/bindings/imagepicker_binding.dart';
import '../modules/imagepicker/views/imagepicker_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/order_album/bindings/order_album_binding.dart';
import '../modules/order_album/views/order_album_view.dart';
import '../modules/order_details/bindings/order_details_binding.dart';
import '../modules/order_details/views/order_details_view.dart';
import '../modules/otp_verification/bindings/otp_verification_binding.dart';
import '../modules/otp_verification/views/otp_verification_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/payment_history/bindings/payment_history_binding.dart';
import '../modules/payment_history/views/payment_history_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/subscription/bindings/subscription_binding.dart';
import '../modules/subscription/views/subscription_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const Splash(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: _Paths.BUSINESS,
      page: () => const BusinessView(),
      binding: BusinessBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTION,
      page: () => const SubscriptionView(),
      binding: SubscriptionBinding(),
    ),
    GetPage(
      name: _Paths.IMAGEPICKER,
      page: () => const ImagepickerView(),
      binding: ImagepickerBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_ALBUM,
      page: () => const OrderAlbumView(),
      binding: OrderAlbumBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_ADDRESS,
      page: () => const CreateAddressView(),
      binding: CreateAddressBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_PROFILE,
      page: () => const CreateProfileView(),
      binding: CreateProfileBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_HISTORY,
      page: () => const PaymentHistoryView(),
      binding: PaymentHistoryBinding(),
    ),
    GetPage(
      name: _Paths.ALL_ORDERS,
      page: () => const AllOrdersView(),
      binding: AllOrdersBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAILS,
      page: () => const OrderDetailsView(),
      binding: OrderDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT_SUPPORT,
      page: () => const ContactSupportView(),
      binding: ContactSupportBinding(),
    ),
  ];
}
