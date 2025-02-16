import 'package:intl/intl.dart';

extension DoubleExtention on double? {
  double? roundWithDigits({int digits = 2}){

    if(this == null){
      return null;
    }
    try{
      return double.parse(this!.toStringAsFixed(2));
    }catch(e){
      return null;
    }
  }

  String? removeTrailingZero() {
    String stringValue = toString();
    stringValue = stringValue.replaceAll(RegExp(r'\.0+$'), '');
    // String formattedValue = NumberFormat.decimalPattern().format(double.parse(stringValue));
    return stringValue;
  }

  String? commaSeparated(){

    if(this == null){
      return null;
    }
    try{
      return NumberFormat('#,##0.00', 'en_US').format(this);
    }catch(e){
      return null;
    }
  }


}