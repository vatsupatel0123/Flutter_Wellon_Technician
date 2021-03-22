
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/screens/bottom_navigation/navigation_bar_controller.dart';
import 'package:wellon_partner_app/screens/cart/cart_screen.dart';
import 'package:wellon_partner_app/screens/contactus/contactus.dart';
import 'package:wellon_partner_app/screens/home/loading.dart';
import 'package:wellon_partner_app/screens/home/qr_thankyou.dart';
import 'package:wellon_partner_app/screens/leads/cancel_lead_screen.dart';
import 'package:wellon_partner_app/screens/leads/com_thankyou_screen.dart';
import 'package:wellon_partner_app/screens/leads/complete_otp_screen.dart';
import 'package:wellon_partner_app/screens/leads/lead_complete_screen.dart';
import 'package:wellon_partner_app/screens/leads/lead_new_screen.dart';
import 'package:wellon_partner_app/screens/leads/lead_progress_screen.dart';
import 'package:wellon_partner_app/screens/leads/lead_screen.dart';
import 'package:wellon_partner_app/screens/leads/thanks_screen.dart';
import 'package:wellon_partner_app/screens/login/login_screen.dart';
import 'package:wellon_partner_app/screens/login/login_second_screen.dart';
import 'package:wellon_partner_app/screens/more/profile/changemobilenumber.dart';
import 'package:wellon_partner_app/screens/more/profile/changenumberotp.dart';
import 'package:wellon_partner_app/screens/more/profile/location.dart';
import 'package:wellon_partner_app/screens/more/refer_friend/refer_friend_screen.dart';
import 'package:wellon_partner_app/screens/more/support_and_care/support_and_care_screen.dart';
import 'package:wellon_partner_app/screens/more/terms_and_condition/terms_and_condition_screen.dart';
import 'package:wellon_partner_app/screens/notification/notificationlistscreen.dart';
import 'package:wellon_partner_app/screens/notification/notificationlist.dart';
import 'package:wellon_partner_app/screens/more/profile/myprofile_screen.dart';
import 'package:wellon_partner_app/screens/notification/notifiction_pending_order.dart';
import 'package:wellon_partner_app/screens/registration/registration_fourt_screen_change.dart';
import 'package:wellon_partner_app/screens/registration/registration_third_screen_change.dart';
import 'package:wellon_partner_app/screens/registration/thank_you_screen.dart';
import 'package:wellon_partner_app/screens/registration/registration_screen.dart';
import 'package:wellon_partner_app/screens/wallet/wallet_view_screen.dart';
import 'package:wellon_partner_app/screens/wallet/statement_screen.dart';
import 'package:wellon_partner_app/screens/wallet/walllet_screen.dart';
import 'package:wellon_partner_app/update_screen.dart';
import 'main.dart';
import 'screens/registration/registration_second_screen_change.dart';

final routes = {
 '/' :          (BuildContext context) => new SplashScreen(),
  //Login
  '/loginfirst':         (BuildContext context) => new LoginScreen(),
  '/loginsecond':         (BuildContext context) => new LoginSecondScreen(),
  '/load':         (BuildContext context) => new ProgressButtonWidget(),
  '/registration':         (BuildContext context) => new UserRegistrationScreen(),
  '/registrationsecondchange':         (BuildContext context) => new UserRegistrationSecondScreenchange(),
  '/registrationthird':         (BuildContext context) => new UserRegistrationThirdChangeScreen(),
  '/registrationfourt':         (BuildContext context) => new UserRegistrationFourtScreenChange(),
  '/thankyou':         (BuildContext context) => new ThankYouScreen(),
  '/bottomhome':         (BuildContext context) => new BottomNavigationBarController(),
  '/notification':         (BuildContext context) => new NotificationListScreen(),
  '/notificationcheck':         (BuildContext context) => new NotificationScreen(),
  '/notificationorderpending':         (BuildContext context) => new NotificationLeadNewScreen(),
  '/walletstatement':         (BuildContext context) => new StatementScreen(),
  '/wallet':         (BuildContext context) => new WallletScreen(),
  '/viewscreen':         (BuildContext context) => new ViewWalletScreen(),
  '/leadscreen':         (BuildContext context) => new LeadScreen(),
  '/leadnewscreen':         (BuildContext context) => new LeadNewScreen(),
  '/leadprogressscreen':         (BuildContext context) => new LeadProgressScreen(),
  '/leadcompletescreen':         (BuildContext context) => new LeadCompleteScreen(),
  '/leadcancelscreen':         (BuildContext context) => new LeadCancelScreen(),
  '/completeotp':         (BuildContext context) => new CompleteOtpScreen(),
  '/thanks':         (BuildContext context) => new AcceptScreen(),
  '/completethanks':         (BuildContext context) => new CompleteThankYou(),
  '/qrthanks':         (BuildContext context) => new QRThankYou(),
  '/location':         (BuildContext context) => new Location(),
  '/cart':         (BuildContext context) => new CartScreen(),
  '/myprofile':         (BuildContext context) => new MyProfileScreen(),
  '/referfriend':         (BuildContext context) => new ReferFriendScreen(),
  '/supportandcare':         (BuildContext context) => new SupportAndCareScreen(),
  '/termsandcondition':         (BuildContext context) => new TermsAndConditionScreen(),
  '/updateapp':         (BuildContext context) => new UpdateScreen(),
  '/contactus':         (BuildContext context) => new ContactUsScreen(),
  '/changemobilenumber':         (BuildContext context) => new ChangeMobileNumberScreen(),
  '/completeotpmobilechange':         (BuildContext context) => new ChangeNumberOtpScreen(),
  //More
};