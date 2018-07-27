//
//  XHCarInWayDataTableView.h
//  CarInWay
//
//  Created by MrYeL on 2018/7/2.
//  Copyright © 2018年 MrYeL. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MARGIN     15       // 间距
#define Y_Title_Width         45   // Y轴title 宽度

#define Top_Title_Height           50   // 顶部高度
#define Bottom_Title_Height            30   // 底部高度

#define Default_YCount 5//默认横轴个数
#define Default_YUinitValue 40 //Y轴单位长度



// 线条类型
typedef NS_ENUM(NSInteger, LineType) {
    LineType_Straight, // 折线
    LineType_Curve     // 曲线
};

// 固定类型
typedef NS_ENUM(NSInteger, Value_Type) {
    Value_Type_Xcount, // 横轴数量固定（5个），根据最大值增加单位长度
    Value_Type_YUnitValue,    // Y轴单位长度固定（40），增加横轴
};

/** 数据表格视图*/
@interface XHCarInWayDataTableView : UIView


/** valueType*/
@property (nonatomic, assign, readonly) Value_Type valueType;
/** isKeepXcount*/
@property (nonatomic, assign, readonly) BOOL isKeepXcount;

//初始化画布
+(instancetype)initWithFrame:(CGRect)frame;

/**
 *  画折线图
 *  @param x_names      x轴值的所有值名称
 *  @param targetValues 所有目标值
 *  @param lineType     直线类型
 */
-(void)drawLineChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType;

/**
 *  画折线图
 *  @param x_names      x轴值的所有值名称
 *  @param targetValues 所有目标值
 *  @param lineType     直线类型
 *  @param yMax     y的最大值
 *  @param yMin     y的最小值
 */
-(void)drawLineChartViewWithX_Value_Names:(NSArray *)x_names TargetValues:(NSArray *)targetValues LineType:(LineType) lineType yMax:(CGFloat)yMax yMin:(CGFloat)yMin;

/** 赋值数据: dateStr：yyyy-MM-dd 默认固定 个数5*/
- (void)configData:(id)data withDate:(NSString *)dateStr;

/** 赋值数据: dateStr：yyyy-MM-dd  valueType: 固定单位长度 还是固定数量*/
- (void)configData:(id)data withDate:(NSString *)dateStr andValueType:(Value_Type)valueType;

/** 赋值数据: dateStr：yyyy-MM-dd  valueType: 固定单位长度 还是固定数量 keepXcount:固定X个数，还是根据时间变*/
- (void)configData:(id)data withDate:(NSString *)dateStr andValueType:(Value_Type)valueType andKeepXcount:(BOOL)keepXcount;

@end
