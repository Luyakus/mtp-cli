//
//  AHSLog.c
//  mtp-cli
//
//  Created by sam on 2019/7/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "AHSLog.h"
#include <stdio.h>

void AHSError(NSString *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    NSString *log = [[[NSString alloc] initWithFormat:fmt arguments:args] stringByAppendingString:@"\n"];
    fprintf(stderr, "%s", (char *)log.UTF8String);
    va_end(args);
}

void AHSOut(NSString *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    NSString *log = [[[NSString alloc] initWithFormat:fmt arguments:args] stringByAppendingString:@"\n"];
    fprintf(stdout, "--------------------------\n");
    fprintf(stdout, "%s", (char *)log.UTF8String);
    fprintf(stdout, "--------------------------\n");
    va_end(args);
}
