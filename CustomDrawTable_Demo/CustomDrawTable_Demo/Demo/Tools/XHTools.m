//
//  XHTools.m
//  CustomDrawTable_Demo
//
//  Created by MrYeL on 2018/7/19.
//  Copyright © 2018年 MrYeL. All rights reserved.
//

#import "XHTools.h"

@implementation XHTools

+ (UILabel *)getUILabelWithFrame:(CGRect)frame withTitle:(NSString *)title withFont:(CGFloat)fontSize withTextColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    return label;
}
+ (UIView *)getUIViewWithFrame:(CGRect)frame withBackgroundColor:(UIColor *)backgroundColor {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    return view;
}

+ (NSDate *)chageStringToDate:(NSString *)dateStr withFormatStr:(NSString *)format{
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = format.length? format:@"YYYY-MM-dd";
    NSDate *date = dateStr.length? [dateFormater dateFromString:dateStr]:[NSDate date];
    
    return date;
}

+ (NSString *)changeDateToString:(NSDate *)date withFormatStr:(NSString *)format{
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = format.length? format:@"YYYY-MM-dd";
    NSString *dateString = [dateFormater stringFromDate:date];
    
    if (dateString) {
        return dateString;
    }
    return @"";
}
@end
