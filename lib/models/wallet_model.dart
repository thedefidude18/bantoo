// ignore_for_file: constant_identifier_names

class WalletModel {
  static const String USER_ID = "userId";
  static const String TRANSACTIONS = "transactions";
  static const String CURRENT_AMOUNT = "currentAmount";
  static const String ONLY_IN_APP_USABLE_AMOUNT = "onlyInAppUseableAmount";
  static const String CURRENCY = "currency";

  final String userId;
  final List transactions;
  final String currency;
  final num currentAmount;
  final num onlyInAppUseableAmount;

  WalletModel({
    required this.userId,
    required this.transactions,
    required this.onlyInAppUseableAmount,
    required this.currency,
    required this.currentAmount,
  });

  factory WalletModel.fromMap(Map<String, dynamic> data) {
    return WalletModel(
      userId: data[USER_ID],
      currency: data[CURRENCY],
      transactions: data[TRANSACTIONS],
      currentAmount: data[CURRENT_AMOUNT],
      onlyInAppUseableAmount: data[ONLY_IN_APP_USABLE_AMOUNT],
    );
  }

  Map<String, dynamic> toJson() => {
        USER_ID: userId,
        CURRENCY: currency,
        TRANSACTIONS: transactions,
        CURRENT_AMOUNT: currentAmount,
        ONLY_IN_APP_USABLE_AMOUNT: onlyInAppUseableAmount,
      };
}
