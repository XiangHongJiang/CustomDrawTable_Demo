//
//  UIColor+additions.h
//  daheidou
//
//  Created by adu on 15/7/15.
//  Copyright (c) 2017年 adu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (additions)
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

+ (UIColor *)hexStringToColor:(NSString *)stringToConvert alpha:(CGFloat)alpha;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - 常用色系
/**主色 #F7F7F7 */
+ (UIColor *)mainColor;

/** 用于重要文字，标题颜色 #3B3B3B */
+ (UIColor *)t1;
/** 用于子标题等颜色: #9E9E9E  */
+ (UIColor *)t2;

/**标题颜色*/
+ (UIColor *)mainTextColor;
/**副标题颜色*/
+ (UIColor *)subTextColor;

/**线的颜色*/
+ (UIColor *)lineColor;
/**背景的颜色*/
+ (UIColor *)viewBgColor;




@end
