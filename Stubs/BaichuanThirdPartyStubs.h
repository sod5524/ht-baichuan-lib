//
//  BaichuanThirdPartyStubs.h
//  ht-baichuan-lib
//
//  百川 SDK 5.0.2.6 精简版缺失的第三方依赖空壳实现。
//  仅提供被百川静态库引用的类符号(见 podspec 说明)，满足链接需求；
//  核心功能(登录/打开页面/授权)不依赖这些类，运行时对应代码路径不会执行。
//  - TKCpsManage / munion：被 AlibcTradeContainer(广告容器模块) 引用，仅类符号
//  - UTDevice：被 AlibabaAuthExt / UT_Core 引用，提供类符号 + 常用设备标识方法
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKCpsManage : NSObject
@end

@interface munion : NSObject
@end

@interface UTDevice : NSObject
+ (NSString *)utdid;
+ (NSString *)deviceID;
+ (NSString *)deviceIDType;
+ (void)setUTDeviceBindGlobal:(BOOL)flag;
@end

NS_ASSUME_NONNULL_END
