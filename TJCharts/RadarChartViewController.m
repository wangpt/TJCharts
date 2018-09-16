//
//  RadarChartViewController.m
//  TJCharts
//
//  Created by 王朋涛 on 17/2/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "RadarChartViewController.h"
#import "TJCharts-Bridging-Header.h"
//#import "TJCharts-Swift.h"

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
    
    CGFloat chartW =[UIScreen mainScreen].bounds.size.width - 20;
    CGFloat chartH =[UIScreen mainScreen].bounds.size.height - 200;
    activities = @[ @"交通", @"环境", @"客流量", @"服务", @"其他" ];
    _chartView = ({
        //1、对象初始化
        RadarChartView *radarChartView = [[RadarChartView alloc] init];
        [self.view addSubview:radarChartView];
        [radarChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(chartW, chartH));
            make.center.mas_equalTo(self.view);
        }];
        //2.设置交互样式
        radarChartView.rotationEnabled = YES;//是否允许转动
        radarChartView.highlightPerTapEnabled = NO;//是否能被选中
        radarChartView.chartDescription.enabled = NO;
        radarChartView.webLineWidth = 1.0;//主干线线宽
        radarChartView.innerWebLineWidth = 1.0;//边线宽度
        radarChartView.webColor = [self colorWithHexString:@"#c2ccd0"];////主干线颜色
        radarChartView.innerWebColor =  [self colorWithHexString:@"#c2ccd0"];//边线颜色
        radarChartView.webAlpha = 1.0;//透明度
        //3.X轴label样式
        ChartXAxis *xAxis = radarChartView.xAxis;
        xAxis.labelFont = [UIFont systemFontOfSize:15];//字体
        xAxis.xOffset = 0.0;
        xAxis.yOffset = 0.0;
        xAxis.valueFormatter = self;
        xAxis.labelTextColor = [self colorWithHexString:@"#057748"];//颜色
        //4.Y轴label样式
        ChartYAxis *yAxis = radarChartView.yAxis;
        yAxis.labelFont = [UIFont systemFontOfSize:9];//字体
        yAxis.labelTextColor = [UIColor lightGrayColor];// label 颜色
        yAxis.labelCount = 5;// label 个数
        yAxis.axisMinimum = 0.0;//最小值
        yAxis.axisMaximum = 100.0;//最大值
        yAxis.drawLabelsEnabled = NO;//是否显示 label
        //5.设置标注
        radarChartView.legend.enabled = NO;
        //6.设置marker 需highlightPerTapEnabled = YES
//        RadarMarkerView *marker = (RadarMarkerView *)[RadarMarkerView viewFromXibIn:[NSBundle mainBundle]];
//        marker.chartView = radarChartView;
//        radarChartView.marker = marker;
        radarChartView;
    });

    [self updateChartData];
}

- (void)updateChartData
{
    _chartView.yAxis.axisMinimum = 0.0;//最小值
    _chartView.yAxis.axisMaximum = 100.0;//最大值
    int lineCount = 1;//几条
    double mult = 80;
    double min = 20;
    int cnt = 5;//维度的个数
    NSMutableArray *allLine_vals = @[].mutableCopy;
    for (int count = 0; count<lineCount; count++) {
        NSMutableArray *entries = [[NSMutableArray alloc] init];
        for (int i = 0; i < cnt; i++)
        {
            double randomVal =(arc4random_uniform(mult) + min); //产生 20~100随机数
            [entries addObject:[[RadarChartDataEntry alloc] initWithValue:randomVal]];
        }
        [allLine_vals addObject:entries];
    }
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [allLine_vals enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RadarChartDataSet *set = [[RadarChartDataSet alloc] initWithValues:obj label:[NSString stringWithFormat:@"第%lu条",(unsigned long)idx+1]];
        UIColor *color = TJRandomColor;
        [set setColor:color];//数据折线颜色
        set.fillColor = color;//填充颜色
        set.drawFilledEnabled = YES;
        set.fillAlpha = 0.25;//填充透明度
        set.lineWidth = 0.5;//数据折线线宽
        set.drawHighlightCircleEnabled = YES;
        [set setDrawHighlightIndicators:NO];
        set.valueFont = [UIFont systemFontOfSize:9];//字体
        set.valueTextColor = [UIColor grayColor];//颜色
        [dataSets addObject:set];
    }];
    
    RadarChartData *data = [[RadarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];
    [data setDrawValues:YES];//是否绘制显示数据
    data.valueTextColor = UIColor.blackColor;
    _chartView.data = data;
    [_chartView animateWithXAxisDuration:1.4 yAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    
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



@end
