
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../repository/auth_repository.dart';

class AuthViewModel {

  final _myRepo = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;



  Future<void> pushNotification(dynamic data) async{
    _myRepo.pushNotificationApi(data).then((value) {
      if(kDebugMode){
        print(value.toString());
      }
    }).onError((error, stackTrace) {
      if(kDebugMode){
        print(error.toString());
      }
    });

  }
}