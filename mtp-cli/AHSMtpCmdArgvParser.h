//
//  AHSMtpCliArgvParser.h
//  mtp-cli
//
//  Created by sam on 2019/7/11.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN



@interface AHSMtpCmdArgvParser : NSObject
+ (NSDictionary <NSString *, id> *_Nonnull)parseArguments:(const char* _Nonnull [_Nullable])argv withArgumentCount:(int)argc;
@end

NS_ASSUME_NONNULL_END
