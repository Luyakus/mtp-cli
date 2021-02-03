//
//  main.m
//  mtp-cli
//
//  Created by sam on 2019/7/11.
//  Copyright © 2019 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "libmtp.h"
#include <sys/stat.h>
#include <stdio.h>
#include <string.h>
#import "AHSMtpCmd.h"
#import "AHSMtpCmdArgvParser.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        return [[AHSMtpCmd commandForArguments:[AHSMtpCmdArgvParser parseArguments:argv withArgumentCount:argc]] excute];
    }
    
}
