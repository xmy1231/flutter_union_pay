import 'dart:convert';


import 'package:union_pay/enum/union_pay_enum.dart';

// 创建时间：2021/8/24 
// 作者：jacky
// 描述：

class PaymentResult {
  int code = 0;
  PaymentStatus get status => PaymentStatus.values[code];
  PaymentResult.fromJson(String? e) {
    dynamic json = jsonDecode(e!);
    this.code = json['code'];
  }
}