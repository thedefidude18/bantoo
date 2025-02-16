

import 'package:flexx_bet/data/response/status.dart';

class ApiResponse<T> {

  Status? status;
  T? data;
  String? massage;

  ApiResponse(this.status,this.data,this.massage);

  ApiResponse.loading(): status = Status.LOADING;

  ApiResponse.completed(): status = Status.COMPLETED;

  ApiResponse.error(): status = Status.ERROR;


  @override
  String toString() {
    // TODO: implement toString
    return "Status: $status \n Massage: $massage \n Data: $data";

  }







}