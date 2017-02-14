//
//  ChartsViewController.m
//  TJCharts
//
//  Created by 王朋涛 on 17/2/7.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "ChartsViewController.h"
#import "PNLineChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "PNColor.h"
@interface ChartsViewController ()
@property (nonatomic,strong) PNLineChart * lineChart;

@end
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)

@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.title isEqualToString:@"Line Chart"]) {

//        self.titleLabel.text = @"景区客流统计";
        
        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        self.lineChart.yLabelFormat = @"%1.1f";
        self.lineChart.backgroundColor = [UIColor clearColor];
        [self.lineChart setXLabels:@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月"]];
        self.lineChart.showCoordinateAxis = YES;
        
        self.lineChart.yGridLinesColor = [UIColor clearColor];
        self.lineChart.showYGridLines = YES;
        
        
        self.lineChart.yFixedValueMax = 7000;
        self.lineChart.yFixedValueMin = 0.0;
        
        [self.lineChart setYLabels:@[
                                     @"0",
                                     @"1000",
                                     @"2000",
                                     @"3000",
                                     @"4000",
                                     @"5000",
                                     @"6000",
                                     @"7000",
                                     ]
         ];
        
        // Line Chart #1
        NSArray * data01Array = @[@2000, @4000, @1500, @1600, @4000, @6000, @7000];
        
        PNLineChartData *data01 = [PNLineChartData new];
        data01.dataTitle = @"今年";
        data01.color = PNFreshGreen;
        data01.alpha = 0.3f;
        
        data01.itemCount = data01Array.count;
        data01.inflexionPointColor = PNRed;
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        // Line Chart #2
        //        NSArray * data02Array = @[@0.0, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
        NSArray * data02Array =  @[@1000, @3000, @2000, @2500, @6000, @3000, @5000];
        PNLineChartData *data02 = [PNLineChartData new];
        data02.dataTitle = @"去年";
        data02.color = PNTwitterColor;
        data02.alpha = 0.5f;
        data02.itemCount = data02Array.count;
        data02.inflexionPointStyle = PNLineChartPointStyleCircle;
        data02.getData = ^(NSUInteger index) {
            CGFloat yValue = [data02Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        self.lineChart.chartData = @[data01, data02];
        [self.lineChart strokeChart];
//        self.lineChart.delegate = self;
        
        
        [self.view addSubview:self.lineChart];
        
        self.lineChart.legendStyle = PNLegendItemStyleStacked;
        self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        self.lineChart.legendFontColor = [UIColor redColor];
        
        UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
        [legend setFrame:CGRectMake(30, 340, legend.frame.size.width, legend.frame.size.height)];
        
        [self.view addSubview:legend];

        
    }
}
- (IBAction)reloadDataClick:(id)sender {
    if ([self.title isEqualToString:@"Line Chart"]) {
        
        // Line Chart #1
        NSArray * data01Array = @[@(arc4random() % 7000), @(arc4random() % 7000), @(arc4random() % 7000), @(arc4random() % 7000), @(arc4random() % 7000), @(arc4random() % 7000), @(arc4random() % 7000)];
        PNLineChartData *data01 = [PNLineChartData new];
        data01.color = PNFreshGreen;
        data01.itemCount = data01Array.count;
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        // Line Chart #2
        NSArray * data02Array = @[@(arc4random() % 7000), @(arc4random() % 7000), @(arc4random() % 7000), @(arc4random() % 7000), @(arc4random() % 7000), @(arc4random() % 7000), @(arc4random() % 7000)];
        PNLineChartData *data02 = [PNLineChartData new];
        data02.color = PNTwitterColor;
        data02.itemCount = data02Array.count;
        data02.inflexionPointStyle = PNLineChartPointStyleSquare;
        data02.getData = ^(NSUInteger index) {
            CGFloat yValue = [data02Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        [self.lineChart setXLabels:@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月"]];
        [self.lineChart updateChartData:@[data01, data02]];
        
    }

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
