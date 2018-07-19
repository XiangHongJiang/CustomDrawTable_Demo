//
//  XHCarInWayDataTableView.m
//  CarInWay
//
//  Created by MrYeL on 2018/7/2.
//  Copyright © 2018年 MrYeL. All rights reserved.
//

#import "XHCarInWayDataTableView.h"
#import "XHCarInwayDataDailyInfoModel.h"
#import "XHTools.h"
#import "UIColor+additions.h"
#import "NSObject+Extension.h"


@interface XHCarInWayDataTableView ()
{
    NSString * _currentYear;
}

@property (strong, nonatomic) NSArray *xTitleArray;//X轴
@property (strong, nonatomic) NSArray *yValueArray;//Y轴
@property (assign, nonatomic) CGFloat yMax;//Y的最大值
@property (assign, nonatomic) CGFloat yCount;//个数
@property (assign, nonatomic) CGFloat defaultXSpace;//X间距 = 绘图宽度/个数
@property (assign, nonatomic) CGFloat defaultYSpace;//Y间距 = 绘图高度/个数
@property (nonatomic, assign) NSInteger yUinitValue;//Y轴单位长度
@property (nonatomic, assign) LineType lineType;//类型
@property (nonatomic, strong) NSMutableArray * allPointArray;//所有Value的坐标点
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 值*/
@property (nonatomic, strong) UILabel * contentLabel;
/** 点的信息*/
@property (nonatomic, strong) UIView * pointContentView;
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, strong) UIView * lineView;

@end

@implementation XHCarInWayDataTableView

#pragma mark - lazyLoad
- (NSMutableArray *)allPointArray {
    if (_allPointArray == nil) {
        _allPointArray = [NSMutableArray new];
    }
    return _allPointArray;
}
- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        _titleLabel = [XHTools getUILabelWithFrame:CGRectMake(MARGIN, 0, 100, Top_Title_Height) withTitle:@"每日里程" withFont:15 withTextColor:[UIColor t1]];
    }
    return _titleLabel;
}
- (UILabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel = [XHTools getUILabelWithFrame:CGRectMake(self.frame.size.width - MARGIN - 100, 0, 100, Top_Title_Height) withTitle:@"0 km" withFont:13 withTextColor:[UIColor t2]];
        _contentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _contentLabel;
}
- (UIView *)pointContentView {
    if (_pointContentView == nil) {
        
        CGPoint point = [self.allPointArray.lastObject CGPointValue];
        _pointContentView = [XHTools getUIViewWithFrame:CGRectMake(point.x-80, point.y - 40, 80, 40) withBackgroundColor:nil];
  
        //label
        NSString *title = _currentYear.length? [NSString stringWithFormat:@"%@-%@",_currentYear,self.xTitleArray.lastObject]: self.xTitleArray.lastObject;
        self.infoLabel = [XHTools getUILabelWithFrame:CGRectMake(-2, 5, 80, 30) withTitle:title withFont:10 withTextColor:[UIColor whiteColor]];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        
        //bg
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 8, 73, 30)];
        imageView.image = [UIImage imageNamed:@"data_red_bg"];
        [_pointContentView addSubview:imageView];
        [_pointContentView addSubview:self.infoLabel];

        YHBorderRadius(self.infoLabel, 5, 0, [UIColor whiteColor]);
        //cicle
        UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(_pointContentView.frame.size.width-4.5, _pointContentView.frame.size.height-3, 7, 7)];
        cicleView.backgroundColor = [UIColor whiteColor];
        YHBorderRadius(cicleView, 3.5, 1.5, [UIColor hexStringToColor:@"#FF5555"]);
        [_pointContentView addSubview:cicleView];
        
        //line
        self.lineView = [XHTools getUIViewWithFrame:CGRectMake(point.x - 1.5, Top_Title_Height, 1.5, self.frame.size.height - Top_Title_Height - Bottom_Title_Height) withBackgroundColor:[UIColor hexStringToColor:@"#979797"]];;
        [self addSubview:self.lineView];
//        self.lineView.hidden = YES;
        
   
//        self.infoLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"data_red_bg"]];

    }
    return _pointContentView;
    
}

//初始化画布
+(instancetype)initWithFrame:(CGRect)frame{
    //整个视图
    XHCarInWayDataTableView *bezierCurveView = [[XHCarInWayDataTableView alloc] initWithFrame:frame];
//    self.frame = frame;
    
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:bezierCurveView action:@selector(event_longPressAction:)];
    longPress.minimumPressDuration = 1.0;
    [bezierCurveView addGestureRecognizer:longPress];
    
    //点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:bezierCurveView action:@selector(event_TapAction:)];
    [bezierCurveView addGestureRecognizer:tapGR];
    
    return bezierCurveView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configSubViews];
    }
    return self;
}
- (void)configSubViews {
    
    //背景
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.layer.cornerRadius = 5;
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    backView.layer.shadowPath =[[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
    backView.layer.shadowOpacity = 0.5;
    
    //基本添加
    [self addSubview:self.contentLabel];
    [self addSubview:self.titleLabel];
    self.contentLabel.text = @"0.00 km";
    
}
/**
 *  画坐标轴
 */
-(void)drawXYLine:(NSMutableArray *)x_names{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //1.Y轴、X轴的直线
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(self.frame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN, MARGIN)];
    
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(self.frame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(self.frame)-2*MARGIN, CGRectGetHeight(self.frame)-MARGIN)];
    
    //2.添加箭头
    [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN-5, MARGIN+5)];
    [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+5, MARGIN+5)];
    
    //3.添加索引格
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = MARGIN + MARGIN*(i+1);
        CGPoint point = CGPointMake(X,CGRectGetHeight(self.frame)-MARGIN);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x, point.y-3)];
    }
    //Y轴（实际长度为200,此处比例缩小一倍使用）
    for (int i=0; i<11; i++) {
        CGFloat Y = CGRectGetHeight(self.frame)-MARGIN-MARGIN*i;
        CGPoint point = CGPointMake(MARGIN,Y);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x+3, point.y)];
    }
    
    //4.添加索引格文字
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = MARGIN + 15 + MARGIN*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetHeight(self.frame)-MARGIN, MARGIN, 20)];
        textLabel.text = x_names[i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor blueColor];
        [self addSubview:textLabel];
    }
    //Y轴
    for (int i=0; i<11; i++) {
        CGFloat Y = CGRectGetHeight(self.frame)-MARGIN-MARGIN*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y-5, MARGIN, 10)];
        textLabel.text = [NSString stringWithFormat:@"%d",10*i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor redColor];
        [self addSubview:textLabel];
    }
    
    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
}
/**
 *  画折线图
 */
-(void)drawLineChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType{
    
    //1.画坐标轴
//    [self drawXYLine:x_names];
    
    //2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    for (int i=0; i<targetValues.count; i++) {
        CGFloat doubleValue = 2*[targetValues[i] floatValue]; //目标值放大两倍
        CGFloat X = MARGIN + MARGIN*(i+1);
        CGFloat Y = CGRectGetHeight(self.frame)-MARGIN-doubleValue;
        CGPoint point = CGPointMake(X,Y);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-1, point.y-1, 2.5, 2.5) cornerRadius:2.5];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor purpleColor].CGColor;
        layer.fillColor = [UIColor purpleColor].CGColor;
        layer.path = path.CGPath;
        [self.subviews[0].layer addSublayer:layer];
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    //3.坐标连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[allPoints[0] CGPointValue]];
    CGPoint PrePonit;
    switch (lineType) {
        case LineType_Straight: //直线
            for (int i =1; i<allPoints.count; i++) {
                CGPoint point = [allPoints[i] CGPointValue];
                [path addLineToPoint:point];
            }
            break;
        case LineType_Curve:   //曲线
            for (int i =0; i<allPoints.count; i++) {
                if (i==0) {
                    PrePonit = [allPoints[0] CGPointValue];
                }else{
                    CGPoint NowPoint = [allPoints[i] CGPointValue];
                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
                    PrePonit = NowPoint;
                }
            }
            break;
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
    
    //4.添加目标值文字
    for (int i =0; i<allPoints.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self.subviews[0] addSubview:label];
        
        if (i==0) {
            CGPoint NowPoint = [allPoints[0] CGPointValue];
            label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(self.frame)-NowPoint.y-MARGIN)/2];
            label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y-20, MARGIN, 20);
            PrePonit = NowPoint;
        }else{
            CGPoint NowPoint = [allPoints[i] CGPointValue];
            if (NowPoint.y<PrePonit.y) {  //文字置于点上方
                label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y-20, MARGIN, 20);
            }else{ //文字置于点下方
                label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y, MARGIN, 20);
            }
            label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(self.frame)-NowPoint.y-MARGIN)/2];
            PrePonit = NowPoint;
        }
    }
}
-(void)drawLineChartViewWithX_Value_Names:(NSArray *)x_names TargetValues:(NSArray *)targetValues LineType:(LineType) lineType ValueType:(Value_Type)valueType yMax:(CGFloat)yMax yMin:(CGFloat)yMin {
    
    self.contentLabel.text = [NSString stringWithFormat:@"%.2f km",[isNotEmptyValue_Custom(targetValues.lastObject, targetValues.lastObject, @"0") floatValue]];
    
    //0.存值
    self.xTitleArray = x_names;
    self.yValueArray = targetValues;
    self.yMax = yMax;
    self.lineType = lineType;
    self.yUinitValue = Default_YUinitValue;//固定单位长度40
    self.yCount = Default_YCount;//固定5条
    
    BOOL regular_XCount = (valueType==Value_Type_Xcount)? YES : NO;
    //固定X轴数量，增加Y轴的单位长度
    int count = [self isPureFloat:yMax / Default_YUinitValue] ? (yMax/Default_YUinitValue +1) :yMax/Default_YUinitValue;
    if ((count + 1) > Default_YCount && regular_XCount) {//大于5个 且 类型为增加单位长度
        
        while (self.yUinitValue * (Default_YCount - 1)< yMax) {
            
            self.yUinitValue += 10;
        }
        
    }else {
        //固定Y轴单位长度,增加X轴的数量
        self.yCount = (count + 1) < Default_YCount ? Default_YCount: (count + 1);//需要绘制的X轴数量
    }
    
    
    self.defaultXSpace = x_names.count?(self.frame.size.width - MARGIN * 2 - Y_Title_Width)/(x_names.count - 1) : (self.frame.size.width - MARGIN * 2 - Y_Title_Width);//X轴间距
    self.defaultYSpace = (self.frame.size.height - Bottom_Title_Height - Top_Title_Height)/ (self.yCount - 1);//Y轴间距
    
    //1.绘制坐标轴
    [self drawXYLine];
    
    //2.绘制点 添加渐变填充
    [self drawPoint];
    
    //3.添加最终显示
    [self addSubview:self.pointContentView];
    
}
#pragma mark - 绘制相关
-(void)drawLineChartViewWithX_Value_Names:(NSArray *)x_names TargetValues:(NSArray *)targetValues LineType:(LineType) lineType yMax:(CGFloat)yMax yMin:(CGFloat)yMin {
  
    [self drawLineChartViewWithX_Value_Names:x_names TargetValues:targetValues LineType:lineType ValueType:Value_Type_Xcount yMax:yMax yMin:yMin];
    
}
//1.绘制坐标轴
- (void)drawXYLine{
    
    UIBezierPath *path_X = [UIBezierPath bezierPath];
    UIBezierPath *path_Y = [UIBezierPath bezierPath];

//    1.Y轴、X轴的直线
    //X轴
    for (int i =0 ; i <  self.yCount; i ++) {
        CGFloat Y = Top_Title_Height + self.defaultYSpace * i;
        [path_X moveToPoint:CGPointMake(MARGIN + Y_Title_Width, Y)];
        [path_X addLineToPoint:CGPointMake(self.frame.size.width - MARGIN,Y)];
    }
//    //Y轴
//    [path_Y moveToPoint:CGPointMake(CGRectGetWidth(self.frame)-MARGIN,Top_Title_Height) ];
//    [path_Y addLineToPoint:CGPointMake(CGRectGetWidth(self.frame)-MARGIN, CGRectGetHeight(self.frame)-Bottom_Title_Height)];


    //2.Y轴、X轴的坐标文字
    //X轴
    for (int i=0; i<self.xTitleArray.count; i++) {
        CGFloat X = MARGIN + Y_Title_Width + self.defaultXSpace * i;
        if (i == 0 || (i == self.xTitleArray.count - 1)) {
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X - Y_Title_Width * 0.5, CGRectGetHeight(self.frame)-Bottom_Title_Height, Y_Title_Width, Bottom_Title_Height)];
            
            textLabel.text = self.xTitleArray[i];
            textLabel.font = [UIFont systemFontOfSize:10];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.textColor = [UIColor t2];
            [self addSubview:textLabel];
        }
    }
    //Y轴
    for (int i=0; i<self.yCount; i++) {
        CGFloat Y = CGRectGetHeight(self.frame)-Bottom_Title_Height- self.defaultYSpace * i;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN - 5, Y-10, Y_Title_Width, 20)];
        textLabel.text = [NSString stringWithFormat:@"%.2f",self.yUinitValue*i*1.0];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.textColor = [UIColor t2];
        [self addSubview:textLabel];
    }
    
    //3.渲染X路径
    CAShapeLayer *shapeLayer_X = [CAShapeLayer layer];
    shapeLayer_X.path = path_X.CGPath;
    shapeLayer_X.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer_X.fillColor = [UIColor clearColor].CGColor;
    shapeLayer_X.borderWidth = 0.5;
    [self.layer addSublayer:shapeLayer_X];
    
    //4.渲染Y路径
    CAShapeLayer *shapeLayer_Y = [CAShapeLayer layer];
    shapeLayer_Y.path = path_Y.CGPath;
    shapeLayer_Y.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer_Y.fillColor = [UIColor clearColor].CGColor;
    shapeLayer_Y.borderWidth = 2.0;
    [self.layer addSublayer:shapeLayer_Y];
    
}

/** 2.画点*/
- (void)drawPoint {
    
    //0.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    [self.allPointArray removeAllObjects];
    
    for (int i=0; i<self.yValueArray.count; i++) {
        
        CGFloat doubleValue = [self.yValueArray[i] floatValue]; //目标值放大两倍
        CGFloat X = MARGIN + Y_Title_Width + self.defaultXSpace*(i);
        CGFloat Y = CGRectGetHeight(self.frame)- Bottom_Title_Height - (doubleValue / self.yUinitValue * 1.0 * self.defaultYSpace);//
        CGPoint point = CGPointMake(X,Y);
        
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-1, point.y-1, 2.5, 2.5) cornerRadius:2.5];
//        CAShapeLayer *layer = [CAShapeLayer layer];
//        layer.strokeColor = [UIColor purpleColor].CGColor;
//        layer.fillColor = [UIColor purpleColor].CGColor;
//        layer.path = path.CGPath;
//        [self.layer addSublayer:layer];
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
        [self.allPointArray addObject:[NSValue valueWithCGPoint:point]];
    }
    
    //2.坐标连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[allPoints[0] CGPointValue]];
    CGPoint PrePonit;
    switch (self.lineType) {
        case LineType_Straight: //直线
            for (int i =1; i<allPoints.count; i++) {
                CGPoint point = [allPoints[i] CGPointValue];
                [path addLineToPoint:point];
            }
            break;
        case LineType_Curve:   //曲线
            for (int i =0; i<allPoints.count; i++) {
                if (i==0) {
                    PrePonit = [allPoints[0] CGPointValue];
                }else{
                    CGPoint NowPoint = [allPoints[i] CGPointValue];
                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
                    PrePonit = NowPoint;
                }
            }
            break;
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 5.0;
    [self.layer addSublayer:shapeLayer];
   
    //添加边界
    [path addLineToPoint:CGPointMake(PrePonit.x, PrePonit.y)];
    [path addLineToPoint:CGPointMake(PrePonit.x,self.frame.size.height - Bottom_Title_Height)];
    [path addLineToPoint:CGPointMake(MARGIN + Y_Title_Width,self.frame.size.height - Bottom_Title_Height)];
    [path addLineToPoint:[allPoints[0] CGPointValue]];
    
    [self drawColorWithPath:path];

}
/** 添加渐变填充*/
- (void)drawColorWithPath:(UIBezierPath *)path {
    
    CAShapeLayer *spLayer = [CAShapeLayer layer];
    spLayer.path = path.CGPath;
    spLayer.borderWidth = 0.0;
    CAGradientLayer *grLayer = [[CAGradientLayer alloc] init];
    UIColor *color1 =  [UIColor colorWithRed:255/255.0 green:85/255.0 blue:85/255.0 alpha:0.8];
    UIColor *color2 =  [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
    grLayer.colors = @[(id)color1.CGColor, (id)color2.CGColor];
    grLayer.frame = self.bounds;
    
    grLayer.mask = spLayer;
    [self.layer addSublayer:grLayer];
    
}
// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)value {
    int i = value;
    CGFloat result = value - i;
    // 当不等于0时，是小数
    return result != 0;
}
#pragma mark - action
- (void)event_TapAction:(UITapGestureRecognizer *)tapAction {
    
    CGPoint location = [tapAction locationInView:self];

    //当前点，在第几个下标
    NSInteger count = self.allPointArray.count;
    NSInteger index = (location.x - MARGIN - Y_Title_Width + self.defaultXSpace *0.5)/self.defaultXSpace ;
    index = index <0? 0 :index;
    if (count > index) {
        NSLog(@"Tap index: %ld, point: %@ \n",index,self.allPointArray[index]);
        [self showPointDataWithPointIndex:index andEnd:NO];
    }else{
        NSLog(@"Tap index: %ld, \n",index);
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf showPointDataWithPointIndex:self.allPointArray.count-1 andEnd:YES];

    });
 
    
}
- (void)event_longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        
        CGPoint location = [longPress locationInView:self];
        static CGFloat moveDistance = 0;
        //当前点，在第几个下标
        NSInteger count = self.allPointArray.count;
        NSInteger index = (location.x - MARGIN - Y_Title_Width + self.defaultXSpace *0.5)/self.defaultXSpace;
        index = index <0 ? 0 :index;

        if (ABS(location.x - moveDistance) > self.defaultXSpace) { //不能长按移动一点点就重新绘图  要让定位的点改变了再重新绘图
            
            moveDistance = location.x;

            if (count > index) {
                NSLog(@"index: %ld, point: %@ \n",index,self.allPointArray[index]);
                [self showPointDataWithPointIndex:index andEnd:NO];
            }else{
                NSLog(@"index: %ld, \n",index);
            }
       
            
        }
    }
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        //恢复
        [self showPointDataWithPointIndex:self.allPointArray.count-1 andEnd:YES];

    }
}
- (void)showPointDataWithPointIndex:(NSInteger)index andEnd:(BOOL)end{
    
    //0.改变frame
    CGRect newFrame = self.pointContentView.frame;
    
    if (index < self.allPointArray.count && index > -1) {
        CGPoint point = [self.allPointArray[index] CGPointValue];
        newFrame.origin.y = point.y - newFrame.size.height;
        newFrame.origin.x = point.x - newFrame.size.width;
        self.pointContentView.frame = newFrame;
        
        CGRect lineViewNewFrame = self.lineView.frame;
        lineViewNewFrame.origin.x = point.x - 1.5;
        self.lineView.frame = lineViewNewFrame;
    }
    
    //1.赋值显示
    if (index < self.yValueArray.count && index > -1) {
        self.contentLabel.text = [NSString stringWithFormat:@"%.2f km",[isNotEmptyValue_Custom(self.yValueArray[index], self.yValueArray[index], @"0") floatValue]];
    }

    if (index < self.xTitleArray.count && index > -1) {
        self.infoLabel.text = _currentYear.length? [NSString stringWithFormat:@"%@-%@",_currentYear,self.xTitleArray[index]]: self.xTitleArray[index];

    }
    
    //2.控制线是否显示
//    if (end) {//隐藏线    //若是停止手势则恢复
//        self.lineView.hidden = YES;
//    }else {
//        self.lineView.hidden = NO;
//    }
}
#pragma mark - Setter and Getter
- (void)configData:(XHCarInwayDataDailyInfoModel *)data withDate:(NSString *)dateStr {
   
    [self configData:data withDate:dateStr andValueType:Value_Type_Xcount];
}
- (void)configData:(XHCarInwayDataDailyInfoModel *)data withDate:(NSString *)dateStr andValueType:(Value_Type)valueType {
    
    NSDate *currentDate = [XHTools chageStringToDate:dateStr withFormatStr:@"yyyy-MM-dd"];
    NSString *currentDateStr = [XHTools changeDateToString:currentDate withFormatStr:@"yyyy-MM-dd"];
    
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    NSString *currentYearStr = dateArray.firstObject;
    NSString *currentMounthStr = dateArray[1];
    NSString *currentDayStr = dateArray.lastObject;
    
    _currentYear = currentYearStr;
    
    NSMutableArray *xValueArray = [NSMutableArray new];//x轴
    NSMutableArray *yValueArray = [NSMutableArray new];//y轴
    CGFloat maxValue = 0;
    
    for (NSInteger i = 0; i < currentDayStr.integerValue; i ++) {//日期数组 MM-dd
        [xValueArray addObject:[NSString stringWithFormat:@"%@-%02ld",currentMounthStr,i + 1]];
    }
    
    if ([data isKindOfClass:[XHCarInwayDataDailyInfoModel class]]) {
        
        for (NSInteger i = 0; i < currentDayStr.integerValue; i ++) {
            MonthDailyInfoList *dailyInfo = nil;
            if (i < data.monthDailyInfoList.count) {
                dailyInfo = data.monthDailyInfoList[i];
                [yValueArray addObject:isNotEmptyValue_Custom(dailyInfo.RUNMILES, dailyInfo.RUNMILES, @"0")];
                maxValue = dailyInfo.RUNMILES.floatValue >maxValue? dailyInfo.RUNMILES.floatValue:maxValue;
            }else {
                [yValueArray addObject:@"0"];
            }
        }
        
    }else{//测试
        for (NSInteger i = 0; i < currentDayStr.integerValue; i ++) {//
#ifdef DEBUG
            [yValueArray addObject:[NSString stringWithFormat:@"%ld",arc4random()%300 + i]];
#else
            [yValueArray addObject:@"0"];
#endif
            maxValue = [yValueArray[i] floatValue] > maxValue? [yValueArray[i] floatValue] : maxValue;
            
        }
    }
    
    //防止重绘
    [self removeAllSubviews];
    [self configSubViews];

    //绘制
    [self drawLineChartViewWithX_Value_Names:xValueArray TargetValues:yValueArray LineType:LineType_Curve ValueType:valueType yMax:maxValue yMin:0];
    
    //重置位置
    [self showPointDataWithPointIndex:self.allPointArray.count - 1 andEnd:YES];
    [self insertSubview:self.lineView belowSubview:self.pointContentView];

}
- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

@end
