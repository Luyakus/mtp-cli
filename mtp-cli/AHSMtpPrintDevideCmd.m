//
//  AHSMtpPrintDevideCmd.m
//  mtp-cli
//
//  Created by sam on 2019/7/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "AHSMtpPrintDevideCmd.h"

@implementation AHSMtpPrintDevideCmd
+ (instancetype)commandForArguments:(NSDictionary <NSString *, id> *)arguments {
    return [[self alloc] init];
}

- (int)excute {
    fprintf(stdout, "--------------------------\n");
    return 0;
}
@end
