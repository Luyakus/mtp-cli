//
//  AHSMtpSendFileToDeviceCmd.m
//  mtp-cli
//
//  Created by sam on 2019/7/15.
//  Copyright © 2019 sam. All rights reserved.
//
#import "AHSLog.h"
#import "AHSMtpSendFileToDeviceCmd.h"
#import "AHSMtpDetectDeviceCmd.h"
#import "AHSMtpCreatFolderCmd.h"
@interface AHSMtpSendFileToDeviceCmd()
@property (nonatomic, copy) NSString *sourcePath;
@property (nonatomic, copy) NSString *serialNo;
@property (nonatomic, copy) NSString *folderPath;


@property (nonatomic, assign) BOOL batchExcute;
@property (nonatomic, assign) BOOL getHelp;
@property (nonatomic, assign) BOOL createDefault;

@end
@implementation AHSMtpSendFileToDeviceCmd



+ (instancetype)commandForArguments:(NSDictionary<NSString *,id> *)arguments {
    AHSMtpSendFileToDeviceCmd *cmd = [[self alloc] init];
    cmd.createDefault = [arguments[@"-default"] boolValue];
    cmd.folderPath  = cmd.createDefault ? @"/000" : arguments[@"-targetfolder"];
    cmd.serialNo    = arguments[@"-device"];
    cmd.sourcePath  = arguments[@"-path"];
    cmd.batchExcute = [arguments[@"-batch"] boolValue];
    cmd.getHelp     = [arguments[@"-help"] boolValue];
    return cmd;
}

- (void)useage {
    AHSError(@"mtp-cli sendfile -path <source_file_path> -device <device_serialno> -targetfolder <target_folder_path> [-batch] [-help] [-default]");
    AHSError(@"如果加了 -batch, -device 参数会被忽略");
    AHSError(@"如果加了 -default, -target_folder_path 参数会被忽略, 会在根目录下创建一个 000 文件夹");
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
        NSArray <AHSMtpDevice *> *successDevices = [self batchSendFile:self.sourcePath underFolder:self.folderPath];
        NSString *json = [successDevices modelToJSONString];
        AHSOut(json);
        return 0;
    } else {
        NSArray <AHSMtpDevice *> *devices = [AHSMtpDevice devices];
        for (AHSMtpDevice *device in devices) {
            if ([device.serialNo isEqualToString:self.serialNo] &&
                ![device sendFile:self.sourcePath  underFolder:self.folderPath]) {
                AHSError(@"在设备 %@ 上创建文件夹失败", self.batchExcute ? device.serialNo : self.serialNo);
                [self useage];
                return -1;
            }
        }
    }
    return 0;
}



- (NSArray <AHSMtpDevice *> *)batchSendFile:(NSString *)sourcePath underFolder:(NSString *)folderPath {
    NSArray <AHSMtpDevice *> *devices = [AHSMtpDevice devices];
    NSMutableArray *successDevices = @[].mutableCopy;
    for (AHSMtpDevice *device in devices) {
        if ([device sendFile:self.sourcePath underFolder:folderPath]) {
            [successDevices addObject:device];
        }
    }
    return devices;
}

@end
