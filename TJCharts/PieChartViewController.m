//
//  PieChartViewController.m
//  TJCharts
//
//  Created by 王朋涛 on 17/2/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "PieChartViewController.h"
#import "TJCharts-Bridging-Header.h"
@interface PieChartViewController ()<ChartViewDelegate>
@property (nonatomic, strong) PieChartView *chartView;
@property (nonatomic, assign) BOOL isSimple;

@end

@implementation PieChartViewController


- (PieChartView *)chartView{
    if (!_chartView) {
        _chartView = [PieChartView new];
    }
    return _chartView;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建饼状图
    [self.view addSubview:self.chartView];
    CGFloat width =[UIScreen mainScreen].bounds.size.width - 20;
    CGFloat height =[UIScreen mainScreen].bounds.size.height - 250;
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, height));
        make.center.mas_equalTo(self.view);
    }];

    _chartView.legend.enabled = YES;
    _chartView.delegate = self;
    [self setupPieChartView:_chartView];
    [self updateChartData];
    [_chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];

}

- (void)updateChartData
{
    if (self.isSimple) {
//        self.isSimple = NO;
        [self setDataCountSimple:5 range:100];

    }else{
//        self.isSimple = YES;

        [self setDataCountLine:5 range:100];

    }

}
- (void)setDataCountLine:(int)count range:(double)range
{
    double mult = range;
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    NSArray *parties;
    parties = @[
                @"丽江", @"贵阳", @"北京", @"上海", @"广州", @"深圳",
                @"香港", @"澳门", @"天津", @"重庆", @"成都", @"杭州",
                @"武汉", @"南京", @"西安", @"长沙", @"青岛", @"沈阳",
                @"大连", @"厦门", @"苏州", @"宁波", @"无锡"
                ];
    
    for (int i = 0; i < count; i++)
    {
        
        double randomVal = arc4random_uniform(mult) + mult / 2;//产生 50~150 的随机数
        [entries addObject:[[PieChartDataEntry alloc] initWithValue:randomVal label:parties[i % parties.count]]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:entries label:@"Election Results"];
    dataSet.sliceSpace = 2.0;//相邻区块之间的间距
    
    dataSet.drawValuesEnabled = YES;//是否绘制显示数据
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;//区块颜色
    dataSet.valueLinePart1OffsetPercentage = 0.8;//折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
    dataSet.valueLinePart1Length = 0.2;//折线中第一段长度占比
    dataSet.valueLinePart2Length = 0.4;//折线中第二段长度最大占比
    dataSet.valueLineWidth = 1;//折线的粗细
    dataSet.valueLineColor = [UIColor brownColor];//折线颜色

//    dataSet.xValuePosition = PieChartValuePositionOutsideSlice;//名称位置
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;//数据位置
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.blackColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}

- (void)setDataCountSimple:(int)count range:(double)range
{
    double mult = range;
    NSArray *parties = @[
                @"丽江", @"贵阳", @"北京", @"上海", @"广州", @"深圳",
                @"香港", @"澳门", @"天津", @"重庆", @"成都", @"杭州",
                @"武汉", @"南京", @"西安", @"长沙", @"青岛", @"沈阳",
                @"大连", @"厦门", @"苏州", @"宁波", @"无锡"
                ];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) label:parties[i % parties.count]]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    dataSet.sliceSpace = 2.0;
    
    // add a lot of colors
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];

    _chartView.data = data;
    [_chartView highlightValues:nil];
}




#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

- (IBAction)reloadDataClick:(id)sender {
    [self updateChartData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
