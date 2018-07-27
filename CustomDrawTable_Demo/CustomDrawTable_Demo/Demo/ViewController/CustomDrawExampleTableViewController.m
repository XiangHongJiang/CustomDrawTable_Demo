//
//  CustomDrawExampleTableViewController.m
//  CustomDrawTable_Demo
//
//  Created by MrYeL on 2018/7/19.
//  Copyright © 2018年 MrYeL. All rights reserved.
//

#import "CustomDrawExampleTableViewController.h"
#import "XHCarInWayDataTableView.h"//表图
#import "XHTools.h"
#import "XHCarInwayDataDailyInfoModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface CustomDrawExampleTableViewController ()
/** footerView*/
@property (nonatomic, strong) XHCarInWayDataTableView *footerView;

/** actionArray*/
@property (nonatomic, copy) NSArray * dataArray;

@end

@implementation CustomDrawExampleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [self footer];

    self.dataArray = @[@"重绘类型为：固定横轴数量，增加单位长度",@"测试模型",@"重绘类型为：固定单位长度，增加横轴数量",@"重绘类型为：整月"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    [self transData];

}
- (UIView *)footer {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    self.footerView = [XHCarInWayDataTableView initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 220)];
    [contentView addSubview:self.footerView];
    return contentView;
    
}
- (void)transData {
    
    // 默认横轴数量固定（5个），根据最大值增加单位长度
    [self.footerView configData:nil withDate:[XHTools changeDateToString:[NSDate date] withFormatStr:@"yyyy-MM-dd"]];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            [self transData];
            break;
        case 1:
        {
            [self.footerView configData:[self testModel] withDate:[XHTools changeDateToString:[NSDate date] withFormatStr:@"yyyy-MM-dd"]];
        }
            break;
        case 2:
            [self.footerView configData:nil withDate:[XHTools changeDateToString:[NSDate date] withFormatStr:@"yyyy-MM-dd"] andValueType:Value_Type_YUnitValue];

            break;
        case 3:
            [self.footerView configData:nil withDate:[XHTools changeDateToString:[NSDate date] withFormatStr:@"yyyy-MM-dd"] andValueType:self.footerView.valueType andKeepXcount:YES];

            break;
        default:
            break;
    }
    
}
- (XHCarInwayDataDailyInfoModel *)testModel {
    XHCarInwayDataDailyInfoModel *model = [XHCarInwayDataDailyInfoModel new];
    
    NSMutableArray *dataArray = [NSMutableArray new];
    for (int i = 0; i < 10; i ++) {
        MonthDailyInfoList *listModel = [MonthDailyInfoList new];
        listModel.RUNMILES = [NSString stringWithFormat:@"%u",arc4random()%150];//里程
        listModel.RDATE = @"";//日期
        [dataArray addObject:listModel];
    }
    model.monthDailyInfoList = dataArray;
    return model;
}

- (void)dealloc {
    
    NSLog(@"deallocd:customDrawVC");
}

@end
