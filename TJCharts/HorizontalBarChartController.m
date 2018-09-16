//
//  HorizontalBarChartController.m
//  TJCharts
//
//  Created by tao on 2018/9/14.
//  Copyright © 2018年 tao. All rights reserved.
//

#import "HorizontalBarChartController.h"
#import "TJCharts-Bridging-Header.h"
#import "TJBarValueFormatter.h"
@interface HorizontalBarChartController ()
@property (nonatomic, strong) HorizontalBarChartView *chartView;
@property (nonatomic, copy)NSArray *months;

@end

@implementation HorizontalBarChartController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _months = @[@"第一资源数据",@"第二资源数据",@"第三资源数据",@"第四资源数据",@"第五资源数据",@"第六",@"第七"];

    CGFloat chartW =[UIScreen mainScreen].bounds.size.width - 20;
    CGFloat chartH =[UIScreen mainScreen].bounds.size.height - 300;
    //初始化
    _chartView = ({
        HorizontalBarChartView *barChartView = [[HorizontalBarChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        [self.view addSubview:barChartView];
        [barChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(chartW, chartH));
            make.center.mas_equalTo(self.view);
        }];
        //设置基本样式
        barChartView.noDataText = @"";//没有数据时的文字提示
        barChartView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
        barChartView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
        barChartView.chartDescription.enabled = NO;//是否显示图标描述
        barChartView.drawGridBackgroundEnabled = NO;//是否绘制网格背景的标志
        barChartView.leftAxis.enabled = NO;//不绘制左边Y轴样式
        barChartView.fitBars = YES;
        barChartView.extraBottomOffset = 20;//视图向上偏移20像素

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
        xAxis.drawAxisLineEnabled = YES;
        xAxis.labelPosition = XAxisLabelPositionBottom;//x轴文字显示位置
        xAxis.axisLineColor = [UIColor blueColor];
        xAxis.axisLineWidth = 0.5;//Y轴线宽
        xAxis.labelTextColor = [UIColor blueColor];
        xAxis.valueFormatter = [[TJBarValueFormatter alloc]init];
        
        //左侧Y轴
        ChartYAxis *leftAxis = barChartView.leftAxis;
        leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
        
        //右侧Y轴样式
        ChartYAxis *rightAxis = barChartView.rightAxis;
        rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
        rightAxis.labelPosition = XAxisLabelPositionBottom;//x轴文字显示位置
        rightAxis.drawAxisLineEnabled = YES;//绘制线条
        rightAxis.drawGridLinesEnabled = NO;//不绘制网格线
        rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
        rightAxis.axisLineColor = [UIColor blueColor];//Y轴颜色
        rightAxis.yOffset = 3;
        ChartLegend *l = barChartView.legend;//
        l.enabled = NO;//不显示图例说明

        barChartView;
    });
    
#define IS_MultipleChartData 1
    ChartXAxis *xAxis = _chartView.xAxis;
#if IS_MultipleChartData
    xAxis.centerAxisLabelsEnabled = YES;//文字显示在中心
    [self updateMultipleChartData];
#else
    xAxis.centerAxisLabelsEnabled = NO;//文字不显示在中心
    [self updateChartData];
#endif
    
    
}

- (void)updateChartData
{
    
    NSInteger count = 5;
    double range = 100;
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double val = arc4random_uniform(range) + 10;
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
    [_chartView animateWithYAxisDuration:1.5];

}

#pragma mark - 多组数据
- (void)updateMultipleChartData{
    
    double range = 100;//最大随机数
    NSInteger lineCount = 2;//条数
    NSInteger groupCount = 5;//多少组
    int startX = 0;
    float groupSpace = 0.2f;
    float barSpace = 0.03f;
    float barWidth = ( 1- groupSpace)/lineCount -barSpace;// (barWidth +barSpace)*lineCount+groupSpace = 1
    //添加随机数据
    NSMutableArray *all_vals = @[].mutableCopy;
    for (int count = 0; count < lineCount; count++) {
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < groupCount; i++)
        {
            double val = arc4random_uniform(range) + 10;
            [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:val]];

        }
        [all_vals addObject:yVals];
    }
    
    if (_chartView.data.dataSetCount > 0)
    {
        [all_vals enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BarChartDataSet *set = (BarChartDataSet *)_chartView.data.dataSets[idx];
            set.values = obj;
        }];
        BarChartData *data = _chartView.barData;
        _chartView.xAxis.axisMinimum = startX;
        _chartView.xAxis.axisMaximum = [data groupWidthWithGroupSpace:groupSpace barSpace: barSpace] * groupCount + startX;
        [data groupBarsFromX: startX groupSpace: groupSpace barSpace: barSpace];
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [all_vals enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *label = [NSString stringWithFormat:@"第%lu条",(unsigned long)idx+1];
            BarChartDataSet *set = [[BarChartDataSet alloc] initWithValues:all_vals[idx] label:label];
            [set setColor:TJRandomColor];
            set.drawValuesEnabled = YES;//是否在柱形图上面显示数值，需要设置左侧Y轴axisMinimum，以及maxVisibleCount
            [dataSets addObject:set];
        }];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        data.barWidth = barWidth;
        _chartView.xAxis.axisMinimum = startX;
        _chartView.xAxis.axisMaximum = startX + [data groupWidthWithGroupSpace:groupSpace barSpace: barSpace] * groupCount;
        [data groupBarsFromX: startX groupSpace: groupSpace barSpace: barSpace];
        _chartView.data = data;
        
    }
    [_chartView animateWithYAxisDuration:1.5];
}


- (IBAction)reloadDataClick:(id)sender {
#if IS_MultipleChartData
    [self updateMultipleChartData];
#else
    [self updateChartData];
#endif
}





@end
