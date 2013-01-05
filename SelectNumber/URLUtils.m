//
//  URLUtils.m
//  SelectNumber
//
//  Created by Char Aznable on 12-12-28.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import "URLUtils.h"

@implementation URLUtils

+ (NSString *)encodeUrlString:(NSString *)sourceString {
    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)sourceString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    return encodedString;
}

@end
