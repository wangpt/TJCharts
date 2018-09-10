//
//  LineChartViewController.m
//  TJCharts
//
//  Created by 王朋涛 on 17/2/13.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "LineChartViewController.h"
#import "TJCharts-Bridging-Header.h"

@interface LineChartViewController ()
@property (nonatomic,strong)LineChartView *chartView;

@end

@implementation LineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化对象
    self.chartView = [[LineChartView alloc] init];
    [self.view addSubview:self.chartView];
    CGFloat chartW =[self getScreenSize].width - 20;
    CGFloat chartH =[self getScreenSize].height - 300;
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(chartW, chartH));
        make.center.mas_equalTo(self.view);
    }];
    
    [super setupBarLineChartView:self.chartView];
    
    //设置y轴的样式
    ChartYAxis *leftAxis = self.chartView.leftAxis;//获取左边Y轴
    leftAxis.drawGridLinesEnabled = YES;//不绘制网格线
    leftAxis.axisLineWidth = 1.0/[UIScreen mainScreen].scale;//Y轴线宽
    leftAxis.axisMaximum = 150.0;//设置Y轴的最大值
    leftAxis.axisMinimum = 0.0;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];//设置虚线样式的网格线
    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    leftAxis.labelTextColor = [self colorWithHexString:@"#057748"];//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
    //设置x轴的样式
    ChartXAxis *xAxis = self.chartView.xAxis;
    xAxis.gridLineDashLengths = @[@5.0, @5.0];//虚线
    xAxis.gridLineDashPhase = 0.f;
    xAxis.drawGridLinesEnabled = YES;//不绘制网格线

    [self updateChartData];
    
    [_chartView animateWithXAxisDuration:1.5];
}
- (IBAction)reloadDataClick:(id)sender {
    [self updateChartData];
}

- (void)updateChartData
{
    [self setLineDataCount:12 range:100];
}

- (void)setLineDataCount:(int)count range:(double)range
{
    count = 12;//总个数
    range = 100;//数量
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double val = arc4random_uniform(range) + 3;
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }

    LineChartDataSet *set1 = nil;
    
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yVals1;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        
        set1 = [[LineChartDataSet alloc] initWithValues:yVals1 label:@"DataSet"];
//        [set1 setColor:UIColor.redColor];
//        [set1 setCircleColor:UIColor.redColor];//拐点颜色
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
//        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        set1.drawCircleHoleEnabled = NO;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];

        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.blackColor];
        [data setValueFont:[UIFont systemFontOfSize:9.f]];

        _chartView.data = data;

    }
}


- (void)setFillDataCount:(int)count range:(double)range
{
    int xVals_count = 12;//X轴上要显示多少条数据
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < xVals_count; i++)
    {
        double val = arc4random_uniform(range) + 3;
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = values;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:values label:@"lineName"];
        //点击选中拐点的交互样式
        set1.highlightLineDashLengths = @[@5.f, @2.5f];//十字线的虚线样式
        [set1 setColor:[self colorWithHexString:@"#007FFF"]];//折线颜色
        set1.lineWidth = 1.0;//折线宽度
        set1.drawValuesEnabled = YES;//是否在拐点处显示数据
        //折线拐点样式
        set1.drawCirclesEnabled = NO;//是否绘制拐点
        set1.circleRadius = 3.0;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.formLineDashLengths = @[@5.f, @2.5f];
        set1.formLineWidth = 1.0;
        set1.formSize = 15.0;
        
        NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        set1.fillAlpha = 0.3f;//透明度
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];//赋值填充颜色对象
        set1.drawFilledEnabled = YES;//是否填充颜色
        CGGradientRelease(gradient);
        //将 LineChartDataSet 对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [_chartView zoomWithScaleX:5.f scaleY:1.f x:0.f y:0.f];

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
