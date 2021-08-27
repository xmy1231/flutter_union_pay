# Flutter UnionPay
  银联支付SDK Flutter版插件，支持iOS，Android平台。

## 开始
 在使用前强烈阅读[银联官方接入指南](https://open.unionpay.com/tjweb/acproduct/list?apiSvcId=3021&index=2)。 例如，在iOS上你还要设置URL Scheme。

## android
```
# 混淆目前暂时关闭了。
```

## iOS
在工程`info.plist` 设置中添加一个 URL Types，否则无法返回你的app.

在`info.plist`文件中添加白名单:
```
<key>LSApplicationQueriesSchemes</key>
<array>
   	<string>uppaysdk</string>
   	<string>uppaywallet</string>
   	<string>uppayx1</string>
   	<string>uppayx2</string>
   	<string>uppayx3</string>
</array>
```

## 获取云闪付SDK版本号(iOS暂不支持)
```
  var version = await UnionPay.uPayVersion();
```

## 检查云闪付App是否安装
```
  var result = await UnionPay.isInstalled();
```

## 支付
 只需设置支付环境和交易流水号即可。
 ```
  var result = await UnionPay.pay(
                mode: PaymentEnv.DEVELOPMENT,
                tn: "",
                scheme: "UnionPayTest",
              );
```
mode分为测试环境和生产环境，scheme只对iOS有效

## Flutter
 支持Flutter 空安全
 example
[示例](./example/lib/main.dart)

