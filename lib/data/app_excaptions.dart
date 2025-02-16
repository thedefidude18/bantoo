class AppException implements Exception{
  final _massage;
  final _prefix;

  AppException ([ this._massage,this._prefix]);

  String toString(){
    return '$_massage$_prefix';

  }
}

class FetchDataException extends AppException{

  FetchDataException ([String? massage ]):super (massage,' Error during communication');
}


class BadRequestException extends AppException{

  BadRequestException ([String? massage ]):super (massage,'Invalid request');
}

class UnauthorisedException extends AppException{

  UnauthorisedException ([String? massage ]):super (massage,'Unauthorised request');
}


class InvalidException extends AppException{

  InvalidException ([String? massage ]):super (massage,'Invalid request');
}