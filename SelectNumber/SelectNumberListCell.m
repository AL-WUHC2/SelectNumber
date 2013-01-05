//
//  SelectNumberCell.m
//  SelectNumber
//
//  Created by Char Aznable on 12-12-25.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import "SelectNumberListCell.h"

@implementation SelectNumberListCell

- (void)dealloc {
    [_number release];
    [_preFee release];
    [super dealloc];
}

@end
