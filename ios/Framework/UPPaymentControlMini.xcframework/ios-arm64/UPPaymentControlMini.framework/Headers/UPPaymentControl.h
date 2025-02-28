//
//  PaymentControl.h
//  PaymentControl
//
//  Created by qcao on 15/10/20.
//  Copyright © 2015年 China Unionpay Co.,Ltd. All rights reserved.
//  v3.6.2 build0(mini)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^UPPaymentResultBlock)(NSString* code, NSDictionary* data);
typedef void (^UPPaymentDirectAppSucc)(NSArray* directApps);
typedef void (^UPPaymentDirectAppFail)(NSString* code,NSString* msg);

@interface UPPaymentControl : NSObject


/**
 *  创建支付单例服务
 *
 *  @return 返回单例对象
 */

+ (UPPaymentControl *)defaultControl;


/**
 *  支付接口
 *
 *  @param tn             订单信息
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param mode           支付环境
 *  @param viewController 启动支付控件的viewController
 *  @return 返回成功失败
 */
- (BOOL)startPay:(NSString*)tn
      fromScheme:(NSString *)schemeStr
            mode:(NSString*)mode
  viewController:(UIViewController*)viewController;



/// APP是否已安装检测接口，通过该接口得知用户是否安装银联支付的APP。
/// @param mode 支付环境
/// @param merchantInfo  商户标识
- (BOOL)isPaymentAppInstalled:(NSString*)mode withMerchantInfo:(NSString *)merchantInfo;


/**
 * 接口非线程安全，通过主线程回调异步返回直通可用app列表
 * @param mode 支付环境
 * @param merchantInfo  商户标识
 * @param succBlock  主线程成功回调，回调参数directApps，表示直通可用app列表，如无可用App则directApps为空数组@[]
 * @param succBlock  主线程成功回调，回调参数一code，表示错误码（参数错误 : 01，网络错误 : 02，其它 : 03）
 *                          回调参数二msg，表示错误信息（参数错误 : parameter error，网络错误 : network error，其它 : unknown error）
 */
- (void)getDirectApps:(NSString*)mode
     withMerchantInfo:(NSString*)merchantInfo
            succBlock:(UPPaymentDirectAppSucc)succBlock
            failBlock:(UPPaymentDirectAppFail)failBlock;



/**
 *  处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
 *
 *  @param url              支付结果url，传入后由SDK解析
 *  @param completionBlock  结果回调，保证跳转钱包支付过程中，即使调用方app被系统kill时，能通过这个回调取到支付结果。
 */
- (void)handlePaymentResult:(NSURL*)url completeBlock:(UPPaymentResultBlock)completionBlock;

@end
