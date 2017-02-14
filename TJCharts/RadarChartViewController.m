//
//  RadarChartViewController.m
//  TJCharts
//
//  Created by 王朋涛 on 17/2/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "RadarChartViewController.h"
#import "TJCharts-Bridging-Header.h"
#import "PNColor.h"

@interface RadarChartViewController ()<IChartAxisValueFormatter>
{
    NSArray<NSString *> *activities;

}
@property (nonatomic, assign) BOOL isSimple;

@property (nonatomic, strong) RadarChartView *chartView;

@end

@implementation RadarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //一、创建雷达图对象
    self.chartView = [[RadarChartView alloc] init];
    [self.view addSubview:self.chartView];
    CGFloat chartW =[self getScreenSize].width - 20;
    CGFloat chartH =[self getScreenSize].height - 200;
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(chartW, chartH));
        make.center.mas_equalTo(self.view);
    }];
//    self.chartView.delegate = self;
    self.chartView.descriptionText = @"";//描述
    self.chartView.rotationEnabled = YES;//是否允许转动
    self.chartView.highlightPerTapEnabled = NO;//是否能被选中
    
    
    activities = @[ @"交通", @"环境", @"客流量", @"服务", @"其他" ];
    
//    _chartView.delegate = self;
    //1. 设置雷达图线条样式
    _chartView.chartDescription.enabled = NO;
    _chartView.webLineWidth = 1.0;//主干线线宽
    _chartView.innerWebLineWidth = 1.0;//边线宽度
    _chartView.webColor = [self colorWithHexString:@"#c2ccd0"];////主干线颜色
    _chartView.innerWebColor =  [self colorWithHexString:@"#c2ccd0"];//边线颜色
    _chartView.webAlpha = 1.0;//透明度
    
    
    //X轴label样式
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:15];//字体
    
    xAxis.xOffset = 0.0;
    xAxis.yOffset = 0.0;
    xAxis.valueFormatter = self;
    xAxis.labelTextColor = [self colorWithHexString:@"#057748"];//颜色
    
    //Y轴label样式
    ChartYAxis *yAxis = _chartView.yAxis;
    yAxis.labelFont = [UIFont systemFontOfSize:9];//字体
    yAxis.labelTextColor = [UIColor lightGrayColor];// label 颜色
    yAxis.labelCount = 5;// label 个数
    yAxis.axisMinimum = 0.0;//最小值
    yAxis.axisMaximum = 80.0;//最大值
    yAxis.drawLabelsEnabled = NO;//是否显示 label

    
    _chartView.legend.enabled = NO;

    
    [self updateChartData];


    [_chartView animateWithXAxisDuration:1.4 yAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}
- (void)updateChartData
{

    _chartView.data = nil;

    [self setChartData];
}
- (void)setChartData
{
    double mult = 80;
    double min = 20;
    int cnt = 5;//维度的个数
    
    NSMutableArray *entries1 = [[NSMutableArray alloc] init];
    NSMutableArray *entries2 = [[NSMutableArray alloc] init];
    
    // NOTE: The order of the entries when being added to the entries array determines their position around the center of the chart.
    for (int i = 0; i < cnt; i++)
    {
        double randomVal =(arc4random_uniform(mult) + min); //产生 20~100随机数
        double randomVa2 =(arc4random_uniform(mult) + min); //产生 20~100随机数

        [entries1 addObject:[[RadarChartDataEntry alloc] initWithValue:randomVal]];
        [entries2 addObject:[[RadarChartDataEntry alloc] initWithValue:randomVa2]];
    }

    RadarChartDataSet *set1 = [[RadarChartDataSet alloc] initWithValues:entries1 label:@"贵阳"];
    [set1 setColor:[self colorWithHexString:@"#ff8936"]];//数据折线颜色
    set1.fillColor = [self colorWithHexString:@"#ff8936"];//填充颜色

    set1.drawFilledEnabled = YES;
    set1.fillAlpha = 0.25;//填充透明度
    set1.lineWidth = 0.5;//数据折线线宽
    set1.drawHighlightCircleEnabled = YES;
    [set1 setDrawHighlightIndicators:NO];
    set1.drawValuesEnabled = NO;//是否绘制显示数据
    set1.valueFont = [UIFont systemFontOfSize:9];//字体
    set1.valueTextColor = [UIColor grayColor];//颜色

    RadarChartDataSet *set2 = [[RadarChartDataSet alloc] initWithValues:entries2 label:@"北京"];
    [set2 setColor:[self colorWithHexString:@"#ff2d51"]];
    set2.fillColor = [self colorWithHexString:@"#ff2d51"];
    set2.drawFilledEnabled = YES;
    set2.fillAlpha = 0.25;
    set2.lineWidth = 0.5;//数据折线线宽
    set2.drawValuesEnabled = YES;//是否绘制显示数据

    set2.drawHighlightCircleEnabled = YES;
    [set2 setDrawHighlightIndicators:NO];
    
    RadarChartData *data = [[RadarChartData alloc] initWithDataSets:@[set1]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];
    [data setDrawValues:NO];//是否绘制显示数据
    data.valueTextColor = UIColor.blackColor;


    if (_isSimple) {
        _chartView.yAxis.axisMinimum = 0.0;//最小值
        _chartView.yAxis.axisMaximum = 100.0;//最大值
    }else{
        _isSimple = YES;
    }
    
    _chartView.data = data;



}
- (IBAction)reloadDataClick:(id)sender {

    [self updateChartData];
}

#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    return activities[(int) value % activities.count];
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
