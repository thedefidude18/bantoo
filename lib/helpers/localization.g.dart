import 'package:get/get.dart';

class Localization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'auth.signInButton': 'Sign In',
          'auth.signUpButton': 'Sign Up',
          'auth.resetPasswordButton': 'Send Password Reset',
          'auth.emailFormField': 'Email',
          'auth.passwordFormField': 'Password',
          'auth.oldPasswordFormField': 'Old Password',
          'auth.nameFormField': 'Name',
          'auth.referralCodeField': 'Referral Code',
          'auth.usernameFormField': 'Username',
          'auth.confirmPasswordFormField': 'Confirm Password',
          'auth.signInErrorTitle': 'Sign In Error',
          'auth.signInErrorGoogle': 'Login failed: aborted.',
          'auth.signInError': 'Login failed: email or password incorrect.',
          'auth.signInWithPhoneError': 'Login failed: phone or otp incorrect.',
          'auth.resetPasswordLabelButton': 'Forgot password?',
          'auth.signUpLabelButton': 'Create an Account',
          'auth.signUpErrorTitle': 'Sign Up Failed.',
          'auth.signUpError':
              'There was a problem signing up.  Please try again later.',
          'auth.signInLabelButton': 'Have an Account? Sign In.',
          'auth.resetPasswordNoticeTitle': 'Password Reset Email Sent',
          'auth.resetPasswordNotice':
              'Check your email and follow the instructions to reset your password.',
          'auth.resetPasswordFailed': 'Password Reset Email Failed',
          'auth.signInonResetPasswordLabelButton': 'Sign In',
          'auth.updateUser': 'Update Profile',
          'auth.updateUserSuccessNoticeTitle': 'User Updated',
          'auth.updateUserSuccessNotice':
              'User information successfully updated.',
          'auth.updateUserEmailInUse':
              'That email address already has an account.',
          'auth.updateUserFailNotice': 'Failed to update user',
          'auth.enterPassword': 'Enter your password',
          'auth.cancel': 'Cancel',
          'auth.submit': 'Submit',
          'auth.changePasswordLabelButton': 'Change Password',
          'auth.resetPasswordTitle': 'Reset Password',
          'auth.updateProfileTitle': 'Update Profile',
          'auth.wrongPasswordNoticeTitle': 'Login Failed',
          'auth.wrongPasswordNotice':
              'The password does not match our records.',
          'auth.wrongOldPasswordNotice':
              'The old password does not match our records.',
          'auth.unknownError': 'Unknown Error',
          'settings.title': 'Settings',
          'settings.language': 'Language',
          'settings.theme': 'Theme',
          'settings.signOut': 'Sign Out',
          'settings.dark': 'Dark',
          'settings.light': 'Light',
          'settings.system': 'System',
          'settings.updateProfile': 'Update Profile',
          'home.title': 'Home',
          'home.nameLabel': 'Name',
          'home.uidLabel': 'UID',
          'home.emailLabel': 'Email',
          'home.adminUserLabel': 'Admin User',
          'app.title': 'Flutter Starter Project',
          'validator.email': 'Please enter a valid email address.',
          'validator.password': 'Password must be at least 6 characters.',
          'validator.name': 'Please enter a valid a name.',
          'validator.username': 'Please enter a valid  username.',
          'validator.confirmEmail': 'Email does not match.',
          'validator.confirmPassword': 'Password does not match.',
          'validator.number': 'Please enter a valid number.',
          'validator.notEmpty': 'This is a required field.',
          'validator.amount':
              'Please enter a number i.e. 250 - no dollar symbol and no cents',
          'validator.referralCode': 'Please enter correct code',
          'auth.phoneFormField': "Enter Phone Number",
          'auth.otp': "Fill the code",
          "phone": "Your Phone Number",
          "auth.termError": "Please accept Privacy Policy and Terms of Use",
          "auth.resendOtp": "Didn't get the code?",
          "auth.termsError": "Please accept terms and condition",
          "auth.term1": "I have read and accept the",
          " auth.term2 ": " Privacy Policy ",
          "auth.term3":
              "and agree that my personal data will be \nprocessed by you",
          "auth.term4": "I have read and accept the",
          " auth.term5 ": " Terms of Use ",
          "auth.otpText": "   Code is sent...\n"
              "   If you still didn't get the code, please \n"
              "   make sure you've filled your phone\n"
              "   number correctly"
        },
      };
}
