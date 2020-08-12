import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:super_loja_virtual/models/checkout/credit_card.dart';
import 'package:super_loja_virtual/models/user/user.dart';

class CieloPayment {
  final functions = CloudFunctions.instance;

  Future<String> authorize(
      {CreditCard creditCard, num price, String orderId, User user}) async {
    try {
      final Map<String, dynamic> dataSale = {
        'merchantOrderId': orderId,
        'amount': (price * 100).toInt(),
        'softDescriptor': 'Loja Deovan',
        'installments': 1,
        'creditCard': creditCard.toJson(),
        'cpf': user.cpf,
        'paymentType': 'CreditCard',
      };

      final HttpsCallable callable =
          functions.getHttpsCallable(functionName: 'authorizeCreditCard');

      callable.timeout = const Duration(seconds: 60);
      final response = await callable.call(dataSale);

      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

      if (data['success'] as bool) {
        return data['paymentId'] as String;
      } else {
        debugPrint('${data['error']['message']}');
        return Future.error(data['error']['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
      return Future.error("Falha ao processar transação. Tente novamente.");
    }
  }

  Future<void> capture(String payId) async {
    final Map<String, dynamic> captureData = {
      'payId': payId,
    };
    final HttpsCallable callable =
        functions.getHttpsCallable(functionName: 'captureCreditCard');
    callable.timeout = const Duration(seconds: 60);
    final response = await callable.call(captureData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (!(data['success'] as bool)) {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
    debugPrint("Captura efetuada com sucesso $payId");
  }

  Future<void> cancel(String payId) async {
    final Map<String, dynamic> cancelData = {
      'payId': payId,
    };
    final HttpsCallable callable =
        functions.getHttpsCallable(functionName: 'cancelCreditCard');
    callable.timeout = const Duration(seconds: 60);
    final response = await callable.call(cancelData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (!(data['success'] as bool)) {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
    debugPrint("Cancelamento efetuado com sucesso $payId");
  }
}
