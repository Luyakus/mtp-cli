//
//  AHSMtpDevice.h
//  mtp-cli
//
//  Created by sam on 2019/7/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"
#include "include/libmtp.h"
NS_ASSUME_NONNULL_BEGIN

@interface AHSMtpDevice : NSObject <YYModel>
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *model;
//@property (nonatomic, assign) int busno;
//@property (nonatomic, assign) int deviceno;
@property (nonatomic, copy) NSString *serialNo;
@property (nonatomic, assign) LIBMTP_mtpdevice_t *mtp_device;
@property (nonatomic, assign) BOOL avaliable;

+ (NSArray <AHSMtpDevice *> *)devices;
- (uint32_t)createFolder:(NSString *)folderPath;
- (uint32_t)createFolder:(NSString *)folderName underParent:(uint32_t)parentFolder;
- (BOOL)sendFile:(NSString *)sourcePath underFolder:(NSString *)folderPath;

@end

NS_ASSUME_NONNULL_END
