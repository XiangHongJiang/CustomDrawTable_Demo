//
//  XHTools.h
//  CustomDrawTable_Demo
//
//  Created by MrYeL on 2018/7/19.
//  Copyright © 2018年 MrYeL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define YHBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


@interface XHTools : NSObject
+ (UILabel *)getUILabelWithFrame:(CGRect)frame withTitle:(NSString *)title withFont:(CGFloat)fontSize withTextColor:(UIColor *)textColor;

+ (UIView *)getUIViewWithFrame:(CGRect)frame withBackgroundColor:(UIColor *)backgroundColor;

+ (NSDate *)chageStringToDate:(NSString *)dateStr withFormatStr:(NSString *)format;

+ (NSString *)changeDateToString:(NSDate *)date withFormatStr:(NSString *)format;

+ (NSInteger)getMounthCountWithYearStr:(NSString *)yearStr andMounth:(NSString *)mounthStr;

@end
