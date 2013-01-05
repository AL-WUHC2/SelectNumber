//
//  SelectNumberCondition.m
//  SelectNumber
//
//  Created by Char Aznable on 12-12-27.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import "SelectNumberCondition.h"

@implementation SelectNumberCondition

- (id)initWithProvince:(NSString *)province
                  city:(NSString *)city
            numSection:(NSString *)numSection
                preFee:(NSString *)preFee
               partten:(NSString *)partten
             searchNum:(NSString *)searchNum {
    
    self = [super init];
    if (self) {
        _province = [province copy];
        _city = [city copy];
        _numSection = [numSection copy];
        _preFee = [preFee copy];
        _partten = [partten copy];
        _searchNum = [searchNum copy];
    }
    return self;
}

- (id)copy {
    return [[SelectNumberCondition alloc] initWithProvince:_province city:_city numSection:_numSection preFee:_preFee partten:_partten searchNum:_searchNum];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[SelectNumberCondition class]]) {
        if ([self.province isEqual:[object province]]
            && [self.city isEqual:[object city]]
            && [self.numSection isEqual:[object numSection]]
            && [self.preFee isEqual:[object preFee]]
            && [self.partten isEqual:[object partten]]
            && [self.searchNum isEqual:[object searchNum]]) {
            return YES;
        }
    }
    return NO;
}

- (void)dealloc {
    [_province release];
    [_city release];
    [_numSection release];
    [_preFee release];
    [_partten release];
    [_searchNum release];
    
    [super dealloc];
}

@end
