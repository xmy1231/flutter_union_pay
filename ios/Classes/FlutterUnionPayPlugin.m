#import "FlutterUnionPayPlugin.h"
#if __has_include(<union_pay/union_pay-Swift.h>)
#import <union_pay/union_pay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "union_pay-Swift.h"
#endif
#import <UPPaymentControl.h>

@implementation FlutterUnionPayPlugin
- (instancetype)initWithViewController:(UIViewController *)viewController{
    self = [super init];
    if(self){
        self.viewController = viewController;
    }
    return self;
}

//@implementation FlutterUnionPayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  //[SwiftFlutterUnionPayPlugin registerWithRegistrar:registrar];
  FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"flutter_union_pay"
              binaryMessenger:[registrar messenger]];
      messageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"flutter_union_pay.message" binaryMessenger:[registrar messenger] codec: [FlutterStringCodec sharedInstance]];
      UIViewController *viewController  = [UIApplication sharedApplication].delegate.window.rootViewController;
      FlutterUnionPayPlugin* instance = [[FlutterUnionPayPlugin alloc] initWithViewController:viewController];
        [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"version" isEqualToString:call.method]) {
    result(@"Not Support iOS");
  }else if([@"installed" isEqualToString:call.method]){
      NSString *mode = call.arguments[@"mode"];
      NSString *merchantInfo = call.arguments[@"merchantInfo"];
      Boolean ret = [[UPPaymentControl defaultControl] isPaymentAppInstalled:mode withMerchantInfo:merchantInfo];
      result([NSNumber numberWithBool:ret]);
  }else if([@"pay" isEqualToString:call.method]){
      NSString *tn = call.arguments[@"tn"];
      NSString *mode = call.arguments[@"env"];
      NSString *scheme = call.arguments[@"scheme"];
      Boolean ret = [[UPPaymentControl defaultControl] startPay:tn fromScheme:scheme mode:mode viewController:self.viewController];
      result([NSNumber numberWithBool:ret]);

  }else {
    result(FlutterMethodNotImplemented);
  }
}

- (BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        printf("TEST PRINT");
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        if([code isEqualToString:@"success"]) {
            //交易成功
            [payload setValue:[NSNumber numberWithInt:1] forKey:@"code"];
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
            [payload setValue:[NSNumber numberWithInt:2] forKey:@"code"];
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
            [payload setValue:[NSNumber numberWithInt:0] forKey:@"code"];
        }
        NSData *payloadData = [NSJSONSerialization dataWithJSONObject:payload
                                                              options:0
                                                                error:nil];
        NSString *payloadMsg = [[NSString alloc] initWithData:payloadData encoding:NSUTF8StringEncoding];
        [messageChannel sendMessage:payloadMsg reply:^(id  _Nullable reply) {
            NSLog(@"%@", reply);
        }];
    }];

    return YES;
}

- (BOOL)handleOpenURL:(NSURL*)url{
    NSString *str=[url absoluteString];
    NSLog(@"string :: %@",str);
    return NO;
}

@end
