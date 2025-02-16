import 'package:flexx_bet/ui/auth/checking_account_ui.dart';
import 'package:flexx_bet/ui/auth/choose_profile_picture_ui.dart';
import 'package:flexx_bet/ui/auth/create_pin_ui.dart';
import 'package:flexx_bet/ui/auth/identity_verfication_ui.dart';
import 'package:flexx_bet/ui/auth/residency_proof_ui.dart';
import 'package:flexx_bet/ui/auth/signup_singin_choice_ui.dart';
import 'package:flexx_bet/ui/auth/success_screen_ui.dart';
import 'package:flexx_bet/ui/auth/widgets/enter_pin_screen.dart';
import 'package:flexx_bet/ui/auth/widgets/forget_pin_screen.dart';
import 'package:flexx_bet/ui/auth/widgets/reset_pin_screen.dart';
import 'package:flexx_bet/ui/banter/banter_old.dart';
import 'package:flexx_bet/ui/events/all_upcoming_events.dart';
import 'package:flexx_bet/ui/events/detailed_event_screen.dart';
import 'package:flexx_bet/ui/home/landing_page_ui.dart';
import 'package:flexx_bet/ui/onboarding/onboarding_ui.dart';
import 'package:flexx_bet/ui/profile/change_email_ui.dart';
import 'package:flexx_bet/ui/profile/change_password_ui.dart';
import 'package:flexx_bet/ui/test/test_screen.dart';
import 'package:get/get.dart';
import 'package:flexx_bet/ui/ui.dart';
import 'package:flexx_bet/ui/auth/auth.dart';

import '../ui/events/all_featured_events.dart';
import '../ui/events/all_live_events.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: '/', page: () => const LoadingSplashUI()),
    GetPage(name: '/test-screen', page: () => const TestScreen()),
    GetPage(name: '/enter_pin', page: () =>  EnterPinScreen("")),
    GetPage(name: '/forget_pin', page: () => const ForgetPinScreen()),
    GetPage(name: '/reset_pin', page: () => const ResetPinScreen()),
    GetPage(name: '/signin', page: () => const SignInScreen()),
    GetPage(
        name: '/signup-signin-choice',
        page: () => const SignupSignInChoiceScreen()),
    GetPage(name: '/signup', page: () => const SignUpScreen()),
    GetPage(name: '/change-password', page: () => const ChangePasswordScreen()),
    GetPage(name: '/change-email', page: () => const ChangeEmailScreen()),
    GetPage(name: '/onboarding', page: () =>  OnboardingScreen()),
    GetPage(name: '/check-account', page: () => const AccountCheckingScreen()),
    GetPage(name: '/success-account', page: () => const AccountSuccessScreen()),
    GetPage(name: '/create-pin', page: () => const CreatePinScreen()),
    GetPage(name: "/detailed-event", page: () => DetailedEventScreen("")),
    GetPage(name: "/landing-page", page: () => LandingPage()),
    GetPage(
        name: '/identity-verification',
        page: () => const IdentityVerficationScreen()),
    GetPage(name: '/residency-proof', page: () => ResidencyProofScreen()),
    GetPage(name: '/all-live-events', page: () => const AllLiveEventsScreen()),
    GetPage(
        name: '/all-featured-events',
        page: () => const AllFeaturedEventsScreen()),
    GetPage(
        name: '/all-upcoming-events',
        page: () => const AllUpcomingEventsScreen()),
    GetPage(name: '/profile-picture', page: () => ChooseProfilePictureScreen()),
    GetPage(name: '/banter-screen', page: () => BanterScreenOld()),
  ];
}
