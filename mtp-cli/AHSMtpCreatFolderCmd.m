//
//  AHSMtpCreatFolderCmd.m
//  mtp-cli
//
//  Created by sam on 2019/7/15.
//  Copyright © 2019 sam. All rights reserved.
//
#import "AHSLog.h"
#import "AHSMtpCreatFolderCmd.h"
@interface AHSMtpCreatFolderCmd()
@property (nonatomic, copy) NSString *folderPath;
@property (nonatomic, copy) NSString *serialNo;
@property (nonatomic, assign) BOOL batchExcute;
@property (nonatomic, assign) BOOL getHelp;
@property (nonatomic, assign) BOOL createDefault;

@end
@implementation AHSMtpCreatFolderCmd

// -path folderPath -device serialno
+ (instancetype)commandForArguments:(NSDictionary <NSString *, id> *)arguments {
    AHSMtpCreatFolderCmd *cmd = [AHSMtpCreatFolderCmd new];
    cmd.createDefault = [arguments[@"-default"] boolValue];;
    cmd.folderPath  = cmd.createDefault ? @"/000" : arguments[@"-path"];
    cmd.serialNo    = arguments[@"-device"];
    cmd.batchExcute = [arguments[@"-batch"] boolValue];
    cmd.getHelp     = [arguments[@"-help"] boolValue];
    return cmd;
}

- (void)useage {
    AHSError(@"mtp-cli createfolder -path <target_folder_path> -device <device_serialno> [-batch] [-help] [-default]");
    AHSError(@"如果加了 -batch, -device 参数会被忽略");
    AHSError(@"如果加了 -default, -path 参数会被忽略, 会在根目录下创建一个 000 文件夹");
    AHSError(@"不要用单个数字当文件名, etc /0/1/2/3");
}

- (int)excute {
    if (self.getHelp) {
        [self useage];
        return 0;
    }
   if (!self.createDefault && !self.folderPath) {
        [self useage];
        return -1;
    }
   
    if (self.batchExcute) {
        NSArray <AHSMtpDevice *> *successDevices = [self batchCreateFolder:self.folderPath];
        NSString *json = [successDevices modelToJSONString];
        AHSOut(json);
        return 0;
    } else {
        NSArray <AHSMtpDevice *> *devices = [AHSMtpDevice devices];
        for (AHSMtpDevice *device in devices) {
            if ([device.serialNo isEqualToString:self.serialNo] &&
                ([device createFolder:self.folderPath] == 0)) {
                AHSError(@"在设备 %@ 上创建文件夹失败", self.batchExcute ? device.serialNo : self.serialNo);
                [self useage];
                return -1;
            }
        }
    }
    return 0;
}



- (NSArray <AHSMtpDevice *> *)batchCreateFolder:(NSString *)folderPath {
    NSArray <AHSMtpDevice *> *devices = [AHSMtpDevice devices];
    NSMutableArray *successDevices = @[].mutableCopy;
    for (AHSMtpDevice *device in devices) {
        if ([device createFolder:folderPath] == 0) {
            AHSError(@"在设备 %@ 上创建文件夹失败", self.batchExcute ? device.serialNo : self.serialNo);
            [self useage];
        } else {
            [successDevices addObject:device];
        }
    }
    return devices;
}


@end
