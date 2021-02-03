//
//  AHSMtpCliArgvParser.m
//  mtp-cli
//
//  Created by sam on 2019/7/11.
//  Copyright © 2019 sam. All rights reserved.
//

#import "AHSMtpCmdArgvParser.h"
@implementation AHSMtpCmdArgvParser
+ (NSDictionary <NSString *, id> *_Nonnull)parseArguments:(const char* _Nonnull [_Nullable])argv withArgumentCount:(int)argc {
    NSMutableDictionary *arguments = @{}.mutableCopy;
    if (argc > 1) {
        arguments[@"subCmd"] = [NSString stringWithUTF8String:argv[1]];
        NSString *preOption = nil;
        for (int i = 2; i < argc; i ++) {
            NSString *str = [[NSString alloc] initWithUTF8String:argv[i]];
            if ([str hasPrefix:@"-"]) {
                preOption = str;
                arguments[preOption] = @(YES);
            } else {
                if (preOption) {
                    arguments[preOption] = str;
                    preOption = nil;
                }
            }
        }
    }
    return arguments;
}
@end
