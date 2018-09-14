//
//  BarChartViewController.m
//  TJCharts
//
//  Created by 王朋涛 on 17/2/9.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "BarChartViewController.h"
#import "TJCharts-Bridging-Header.h"

@interface BarChartViewController ()<IChartAxisValueFormatter>
@property (nonatomic, strong) BarChartView *chartView;
@property (nonatomic, copy)NSArray *months;

@end

@implementation BarChartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _months = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七"];

    //初始化
    CGFloat chartW =[UIScreen mainScreen].bounds.size.width - 20;
    CGFloat chartH =[UIScreen mainScreen].bounds.size.height - 300;
    _chartView = ({
        BarChartView *barChartView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        [self.view addSubview:barChartView];
        [barChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(chartW, chartH));
            make.center.mas_equalTo(self.view);
        }];
        //设置基本样式
        barChartView.noDataText = @"暂无数据";//没有数据时的文字提示
        barChartView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
        barChartView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
        barChartView.rightAxis.enabled = NO;//不绘制右边轴
        barChartView.chartDescription.enabled = NO;//是否显示图标描述
        barChartView.drawGridBackgroundEnabled = NO;//是否绘制网格背景的标志

        //设置交互样式
        barChartView.scaleYEnabled = NO;//取消Y轴缩放
        barChartView.doubleTapToZoomEnabled = NO;//取消双击缩放
        barChartView.dragEnabled = NO;//启用拖拽图表
        barChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
        [barChartView setScaleEnabled:YES];//图表是否可以进行缩放
        barChartView.pinchZoomEnabled = NO;//缩放设置
        barChartView.maxVisibleCount = 60;//图标上的数字展示的最大个数,如果不想显示上面的数字，就可以把maxVisibleCount属性设置为0

        //X轴样式
        ChartXAxis *xAxis = barChartView.xAxis;
        xAxis.granularity = 1.0; //设置最小间隔,防止当放大时,出现重复标签
        xAxis.drawGridLinesEnabled = NO;//不绘制网格线
        xAxis.labelPosition = XAxisLabelPositionBottom;//x轴文字显示位置
        xAxis.valueFormatter = self;//用于设置x轴文字显示
        xAxis.axisLineColor = [UIColor blueColor];
        xAxis.axisLineWidth = 0.5;//Y轴线宽
        xAxis.labelTextColor = [UIColor blueColor];
        
        //左边Y轴样式
        ChartYAxis *leftAxis = barChartView.leftAxis;
        leftAxis.drawGridLinesEnabled = NO;//不绘制网格线
        leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
        leftAxis.labelCount = 8;//通过labelCount属性设置Y轴要均分的数量
        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];//文字字体
        leftAxis.labelTextColor = [UIColor blueColor];//文字颜色
        leftAxis.spaceTop = 0.15;//距离上方比例
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
        leftAxis.axisMinimum = 0.0;//最小值
        leftAxis.inverted = NO;//是否将Y轴进行上下翻转
        leftAxis.axisLineWidth = 0.5;//Y轴线宽
        leftAxis.axisLineColor = [UIColor blueColor];//Y轴颜色
        //设置Y轴上网格线的样式，代码如下：
//        leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
//        leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
//        leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
//        //
        ChartLegend *l = barChartView.legend;//
        l.enabled = NO;//不显示图例说明
        barChartView;
    });

    [self updateChartData];
    [_chartView animateWithYAxisDuration:1.5];



}

- (IBAction)reloadDataClick:(id)sender {
    [self updateChartData];

}

- (void)updateChartData
{
    double range = 50;
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i++)
    {
        double mult = (range + 1);
        double val = (double) (arc4random_uniform(mult));
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:val]];

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

#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    int index = (int)value;
    return _months[index];
}
@end
