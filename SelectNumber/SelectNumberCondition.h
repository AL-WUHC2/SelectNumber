//
//  SelectNumberCondition.h
//  SelectNumber
//
//  Created by Char Aznable on 12-12-27.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectNumberCondition : NSObject

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *numSection;
@property (nonatomic, copy) NSString *preFee;
@property (nonatomic, copy) NSString *partten;
@property (nonatomic, copy) NSString *searchNum;

- (id)initWithProvince:(NSString *)province
                  city:(NSString *)city
            numSection:(NSString *)numSection
                preFee:(NSString *)preFee
               partten:(NSString *)partten
             searchNum:(NSString *)searchNum;

@end
