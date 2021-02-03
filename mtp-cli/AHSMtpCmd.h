//
//  AHSMTPCmd.h
//  mtp-cli
//
//  Created by sam on 2019/7/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AHSMtpCmd : NSObject

+ (instancetype)commandForArguments:(NSDictionary <NSString *, id> *)arguments;
- (int)excute;
- (void)useage;
@end

NS_ASSUME_NONNULL_END
