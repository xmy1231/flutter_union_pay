
import 'dart:async';


import 'package:flutter/services.dart';
import 'package:union_pay/enum/union_pay_enum.dart';
import 'package:union_pay/model/payment_result_model.dart';

class UnionPay {
  static const _PACKAGE_NAME = 'flutter_union_pay';
  static const _MESSAGE_CHANNEL_NAME = 'flutter_union_pay.message';

  static const MethodChannel _channel =
      const MethodChannel(_PACKAGE_NAME);


  ///## 获取云闪付控件版本号
  static Future<String> uPayVersion() async {
    final String version = await _channel.invokeMethod('version');
    return version;
  }

  ///## 判断是否安装云闪付App
  static Future<bool> isInstalled({required PaymentEnv mode, required String merchantInfo}) async {
    return await _channel.invokeMethod('installed', {
      'mode': _getEnvString(mode),
      'merchantInfo': merchantInfo,
    });
  }


  static Future<bool> pay(
      {required String tn,required PaymentEnv mode, required String scheme}) async {
    return await _channel.invokeMethod('pay', {
      'tn': tn,
      'env': _getEnvString(mode),
      'scheme': scheme,
    });
  }

  static String _getEnvString(PaymentEnv env) {
    switch (env) {
      case PaymentEnv.PRODUCT:
        return "00";
      case PaymentEnv.DEVELOPMENT:
        return "01";
    }
  }

  /// ## 监听支付结果
  static payListener(Function(PaymentResult result) onListener) async{
    var channel = BasicMessageChannel(_MESSAGE_CHANNEL_NAME, StringCodec());
    channel.setMessageHandler((message)  async{
       return await onListener(PaymentResult.fromJson(message!)) ?? '';
     });

  }
}
