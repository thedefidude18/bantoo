// ignore_for_file: constant_identifier_names

class TransactionModel {
  // "to" is to bank or user proper name
  static const String CONCERNED = "concerned";
  // "account" is account number or user unique name
  static const String ACCOUNT = "account";
  static const String ACTION = "action";
  static const String DATE_AND_TIME = "dateAndTime";
  static const String AMOUNT = "amount";
  // unique reference with some details
  static const String REFERENCE = "reference";
  // narration means a short description of this history
  static const String NARRATION = "narration";

  static const String CURRENCY = "currency";

  final String concerned;
  final String account;
  final String action;
  final String dateAndTime;
  final String amount;
  final String reference;
  final String narration;
  final String currency;

  TransactionModel({
    required this.concerned,
    required this.account,
    required this.action,
    required this.dateAndTime,
    required this.amount,
    required this.reference,
    required this.narration,
    required this.currency,
  });

  factory TransactionModel.fromMap(Map data) {
    return TransactionModel(
        concerned: data[CONCERNED],
        account: data[ACCOUNT],
        action: data[ACTION],
        dateAndTime: data[DATE_AND_TIME],
        amount: data[AMOUNT],
        narration: data[NARRATION],
        reference: data[REFERENCE],
        currency: data[CURRENCY]);
  }

  factory TransactionModel.fromFlutterWaveMap(
      Map data, String from, String action, String dateAndTime) {
    return TransactionModel(
        concerned: data["account_bank"],
        action: action,
        dateAndTime: dateAndTime,
        account: data["account_number"],
        amount: data["amount"],
        narration: data["narration"],
        reference: data["reference"],
        currency: data["currency"]);
  }

  Map<String, dynamic> toJsonForFlutterWave() => {
        "account_bank": concerned,
        "account_number": account,
        "amount": amount,
        "narration": narration,
        "currency": currency,
        "callback_url": "https://www.flutterwave.com/ng/",
        "reference": reference,
        "debit_currency": currency
      };

  Map<String, dynamic> toJson() => {
        CONCERNED: concerned,
        ACTION: action,
        DATE_AND_TIME: dateAndTime,
        ACCOUNT: account,
        AMOUNT: amount,
        NARRATION: narration,
        REFERENCE: reference,
        CURRENCY: currency
      };
}
