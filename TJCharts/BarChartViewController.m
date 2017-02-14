//
//  BarChartViewController.m
//  TJCharts
//
//  Created by 王朋涛 on 17/2/9.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "BarChartViewController.h"
#import "TJCharts-Bridging-Header.h"

@interface BarChartViewController ()
@property (nonatomic, strong) BarChartView *chartView;

@end

@implementation BarChartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //初始化
    self.chartView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:self.chartView];
    CGFloat chartW =[self getScreenSize].width - 20;
    CGFloat chartH =[self getScreenSize].height - 300;
        [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(chartW, chartH));
            make.center.mas_equalTo(self.view);
        }];
    
    [self setupBarLineChartView:_chartView];
    
    //基本样式
    _chartView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
    _chartView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
    _chartView.maxVisibleCount = 60;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.granularity = 1.0; // only intervals of 1 day
    xAxis.labelCount = 7;
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumFractionDigits = 0;
    leftAxisFormatter.maximumFractionDigits = 1;
    leftAxisFormatter.negativeSuffix = @" $";
    leftAxisFormatter.positiveSuffix = @" $";
    //左边Y轴样式
    ChartYAxis *leftAxis = _chartView.leftAxis;
//    leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
    //通过labelCount属性设置Y轴要均分的数量.
    //在这里要说明一下，设置的labelCount的值不一定就是Y轴要均分的数量，这还要取决于forceLabelsEnabled属性，如果forceLabelsEnabled等于YES, 则强制绘制指定数量的label, 但是可能不是均分的leftAxis.labelCount = 5;leftAxis.forceLabelsEnabled = NO;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];//文字字体
    leftAxis.labelCount = 8;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
//    leftAxis.labelTextColor = [UIColor brownColor];//文字颜色
    leftAxis.spaceTop = 0.15;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    //设置Y轴上网格线的样式，代码如下：
    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
    leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
//
    ChartLegend *l = _chartView.legend;//
    l.enabled = NO;//不显示图例说明
//
    
    [self updateChartData];
    [_chartView animateWithYAxisDuration:1.5];



}

- (void)updateChartData
{
    
    [self setDataCount:4 range:50];
}
- (IBAction)reloadDataClick:(id)sender {
    [self updateChartData];

}

- (void)setDataCount:(int)count range:(double)range
{
    double start = 1.0;
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = start; i < start + count + 1; i++)
    {
        double mult = (range + 1);
        double val = (double) (arc4random_uniform(mult));
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:val]];
    }
    
    BarChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yVals;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@"The year 2017"];
        [set1 setColors:ChartColorTemplates.material];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        data.barWidth = 0.9f;
        _chartView.data = data;
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
