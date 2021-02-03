//
//  AHSMtpDetectDevice.m
//  mtp-cli
//
//  Created by sam on 2019/7/15.
//  Copyright © 2019 sam. All rights reserved.
//
#include "libmtp.h"

#import "AHSMtpDetectDeviceCmd.h"
#import "AHSLog.h"
#import "AHSMtpDevice.h"
@interface AHSMtpDetectDeviceCmd()

@end
@implementation AHSMtpDetectDeviceCmd


+ (instancetype)commandForArguments:(NSDictionary <NSString *, id> *)arguments {
    AHSMtpDetectDeviceCmd *cmd = [AHSMtpDetectDeviceCmd new];
    return cmd;
}

- (int)excute {
    NSArray *devices = [AHSMtpDevice devices];
    NSString *jsonString = [devices modelToJSONString];
    AHSOut(jsonString);
    return 0;
}



@end
