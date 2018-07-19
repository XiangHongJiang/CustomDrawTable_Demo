//
//  XHCarInwayDataDailyInfoModel.h
//  CarInWay
//
//  Created by MrYeL on 2018/7/6.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Last3SignInInfo,MonthDailyInfoList;

@interface XHCarInwayDataDailyInfoModel : NSObject

@property (nonatomic , copy) NSString              * monthMiles;
@property (nonatomic , copy) NSString              * todayMiles;
@property (nonatomic , copy) NSString              * totalMiles;
@property (nonatomic , copy) NSString              * todaySignInInfo;

@property (nonatomic , strong) NSArray<MonthDailyInfoList *>      * monthDailyInfoList;

@property (nonatomic , strong) NSArray<Last3SignInInfo *>      * last3SignInInfo;

@end

@interface Last3SignInInfo :NSObject

@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * SignAddress;
@property (nonatomic , copy) NSString              * SignDate;

@end

@interface MonthDailyInfoList :NSObject

@property (nonatomic , copy) NSString              * RDATE;
@property (nonatomic , copy) NSString              * RUNMILES;

@end
