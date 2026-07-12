import 'package:qriza/model/payment_setup.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final bool isSignupComplete;
  final String? qrUrl;
  final PaymentSetup? paymentSetup;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    this.isSignupComplete = false,
    this.qrUrl,
    this.paymentSetup,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final userMap =
        map.containsKey('user') ? Map<String, dynamic>.from(map['user']) : map;

    return UserModel(
      id: userMap['userId'] ?? userMap['_id'].toString(),
      fullName: userMap['fullName'] ?? '',
      email: userMap['email'] ?? '',
      isSignupComplete: userMap['isSignupComplete'] ?? false,
      qrUrl: map['qrUrl'] ?? userMap['qrUrl'],
      paymentSetup:
          userMap['paymentSetup'] != null
              ? PaymentSetup.fromMap(
                Map<String, dynamic>.from(userMap['paymentSetup']),
              )
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': id,
      'fullName': fullName,
      'email': email,
      'isSignupComplete': isSignupComplete,
      'qrUrl': qrUrl,
      'paymentSetup': paymentSetup?.toMap(),
    };
  }
}
