//
//  SelectNumberInfo.m
//  SelectNumber
//
//  Created by Char Aznable on 12-12-25.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import "SelectNumberInfo.h"

@implementation SelectNumberInfo

- (void)dealloc {
    [_numID release];
    [_numPreFee release];
    [_numMemo release];
    [_numLevel release];
    [_city release];
    [_niceRuleTag release];
    
    [super dealloc];
}

@end
