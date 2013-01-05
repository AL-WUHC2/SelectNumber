//
//  NumberFormatUtils.m
//  SelectNumber
//
//  Created by Char Aznable on 12-12-28.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import "NumberFormatUtils.h"

@implementation NumberFormatUtils

+ (NSString *)initFormat344:(NSString *)number {
    NSString *first = [number substringWithRange:NSMakeRange(0, 3)];
    NSString *middle = [number substringWithRange:NSMakeRange(3, 4)];
    NSString *last = [number substringWithRange:NSMakeRange(7, 4)];
    return [[NSString alloc] initWithFormat:@"%@ %@ %@", first, middle, last];
}

@end
