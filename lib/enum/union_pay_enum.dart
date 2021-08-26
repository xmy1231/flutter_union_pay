import 'package:flutter/material.dart';

// 创建时间：2021/8/24 
// 作者：jacky
// 描述：

///支付结果状态
enum PaymentStatus {
  ///支付取消
  CANCEL,
  ///支付成功
  SUCCESS,
  ///支付失败
  FAIL,
}

///支付环境
enum PaymentEnv {
  ///生产环境
  PRODUCT,
  ///测试环境
  DEVELOPMENT,
}
