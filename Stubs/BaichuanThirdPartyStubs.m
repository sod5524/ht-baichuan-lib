//
//  BaichuanThirdPartyStubs.m
//  ht-baichuan-lib
//
//  空壳实现：见 BaichuanThirdPartyStubs.h 说明。
//

#import "BaichuanThirdPartyStubs.h"

@implementation TKCpsManage
@end

@implementation munion
@end

@implementation UTDevice

+ (NSString *)utdid {
    // 空壳：百川启动时会调用 +[UTDevice utdid] 获取设备标识。
    // 返回空串可避免 unrecognized selector 崩溃；若安全模块强制校验真实 UTDID，
    // 需引入完整 UTDevice.framework(阿里 UTDID SDK)。
    return @"";
}

+ (NSString *)deviceID {
    // 空壳：返回空设备标识。如安全模块强制要求真实 UTDID，需引入完整 UTDevice.framework
    return @"";
}

+ (NSString *)deviceIDType {
    return @"UTDID";
}

+ (void)setUTDeviceBindGlobal:(BOOL)flag {
    // 空实现
}

@end
