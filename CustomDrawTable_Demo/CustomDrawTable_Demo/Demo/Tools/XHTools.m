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
+ (NSInteger)getMounthCountWithYearStr:(NSString *)yearStr andMounth:(NSString *)mounthStr{
    
    NSInteger count = 0;
    
    NSInteger yearValue = yearStr.integerValue;
    BOOL isRunYear = NO;
    
    if ((yearValue % 400 == 0) || (yearValue % 4 == 0 && yearValue % 100)) {
        isRunYear = YES;
    }
    
    switch (mounthStr.integerValue) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            count = 31;
            break;
        case 2:
            count = isRunYear? 29:28;
            break;
            
        default:
            count = 30;
            break;
    }
    
    return count;
}
@end
