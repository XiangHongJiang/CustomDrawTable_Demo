//
//  XHCarInwayDataDailyInfoModel.m
//  CarInWay
//
//  Created by MrYeL on 2018/7/6.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "XHCarInwayDataDailyInfoModel.h"

@implementation XHCarInwayDataDailyInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"last3SignInInfo" : [Last3SignInInfo class],
             @"monthDailyInfoList" : [MonthDailyInfoList class],
             };
}

@end

@implementation Last3SignInInfo

@end

@implementation MonthDailyInfoList

@end


