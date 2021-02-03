//
//  AHSMTPCmd.m
//  mtp-cli
//
//  Created by sam on 2019/7/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "AHSMtpCmd.h"
#import "AHSLog.h"
@implementation AHSMtpCmd
+ (instancetype)commandForArguments:(NSDictionary <NSString *, id> *)arguments {
    if (arguments.allKeys.count == 0) return [self new];
    NSString *subCmd = arguments[@"subCmd"];
    NSDictionary *subCommnads = @{
        @"detectdevice":@"AHSMtpDetectDeviceCmd",
        @"sendfile":@"AHSMtpSendFileToDeviceCmd",
        @"createfolder":@"AHSMtpCreatFolderCmd"
    };
    NSString *clsStr = subCommnads[subCmd];
    Class cls = NSClassFromString(clsStr);
    if (!cls) return [self new];
    return [cls commandForArguments:arguments];
}

- (void)useage {
    AHSError(@"mtp-cli detectdevice [-help] 检测连接的设备");
    AHSError(@"mtp-cli sendfile [-help] 在指定设备上创建文件夹");
    AHSError(@"mtp-cli createfolder [-help] 发送文件到指定设备");
}
- (int)excute {
    [self useage];
    return -1;
}
@end
