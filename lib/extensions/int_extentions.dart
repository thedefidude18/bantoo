import 'package:intl/intl.dart';

extension IntExtention on int? {
  String? commaSeparated(){

    if(this == null){
      return null;
    }
    try{
      return NumberFormat('#,##0', 'en_US').format(this);
    }catch(e){
      return null;
    }
  }


  String getOrdinal() {
    if(this == null) return "";
    var number = this!;
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '$number' 'th';
    }
    switch (number % 10) {
      case 1:
        return '$number' 'st';
      case 2:
        return '$number' 'nd';
      case 3:
        return '$number' 'rd';
      default:
        return '$number' 'th';
    }
  }
}