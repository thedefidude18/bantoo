

import '../data/app_url.dart';
import '../data/network/base_api_services.dart';
import '../data/network/network_api_services.dart';

class AuthRepository{
   final BaseApiServices _apiServices = NetworkApiServices();

Future<dynamic>pushNotificationApi(dynamic data)async{

  try{
    dynamic response = await _apiServices.getPostApiResponse(AppUrl.pushNotificationUrl,data);
    return response;
  }catch(e){
    throw e;
  }

}

}