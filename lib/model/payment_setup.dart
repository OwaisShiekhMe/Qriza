class PaymentSetup {
  final String paymentType;
  final String? accountNumber;
  final String? bankName;
  final String? accountTitle;
  final String? ibanNumber;

  PaymentSetup({
    required this.paymentType,
    this.accountNumber,
    this.bankName,
    this.accountTitle,
    this.ibanNumber,
  });

  factory PaymentSetup.fromMap(Map<String, dynamic> map) {
    return PaymentSetup(
      paymentType: map['paymentType'] ?? '',
      accountNumber: map['accountNumber'],
      bankName: map['bankName'],
      accountTitle: map['accountTitle'],
      ibanNumber: map['iban'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'paymentType': paymentType,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (bankName != null) 'bankName': bankName,
      if (accountTitle != null) 'accountTitle': accountTitle,
      if (ibanNumber != null) 'iban': ibanNumber,
    };
  }
}
