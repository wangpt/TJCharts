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
    CGFloat width =[UIScreen mainScreen].bounds.size.width - 20;
    CGFloat height =[UIScreen mainScreen].bounds.size.height - 300;
    self.chartView = ({
        LineChartView *chartView = [[LineChartView alloc] init];
        [self.view addSubview:chartView];
        [chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.center.mas_equalTo(self.view);
        }];
        chartView;
    });
    //2.设置基本样式
    _chartView.noDataText = @"暂无数据";//没有数据时的文字提示
    _chartView.rightAxis.enabled = NO;//不绘制右边轴
    _chartView.drawGridBackgroundEnabled = NO;//是否绘制网格背景的标志
    _chartView.chartDescription.enabled = NO;//是否显示图标描述
    _chartView.chartDescription.text = @"折现图";
    //设置交互样式
    _chartView.scaleXEnabled = NO;//取消X轴缩放
    _chartView.scaleYEnabled = NO;//取消Y轴缩放
    _chartView.pinchZoomEnabled = NO;//XY轴是否同时缩放
    _chartView.doubleTapToZoomEnabled = NO;//取消双击缩放
    _chartView.dragEnabled = YES;//启用拖拽图表
    _chartView.dragDecelerationEnabled = YES;//拖拽饼状图后是否有惯性效果
    
    //3.设置x轴的样式
    ChartXAxis *xAxis = self.chartView.xAxis;
    xAxis.drawGridLinesEnabled = NO;//不绘制网格线为NO 绘制为YES
    xAxis.axisLineWidth = 1.0/[UIScreen mainScreen].scale;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis.labelTextColor = [UIColor blueColor];//label文字颜色
    xAxis.axisLineColor = [UIColor blueColor];//x轴线的颜色
    //4.设置y轴的样式
    ChartYAxis *leftAxis = self.chartView.leftAxis;//获取左边Y轴
    leftAxis.drawGridLinesEnabled = NO;//不绘制网格线
    leftAxis.axisLineWidth = 1.0/[UIScreen mainScreen].scale;//Y轴线宽
    leftAxis.labelCount = 5;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
    leftAxis.forceLabelsEnabled = NO;//不强制绘制指定数量的label
//    leftAxis.axisMaximum = 150.0;//设置Y轴的最大值
    leftAxis.axisMinimum = 0.0;//设置Y轴的最小值
    leftAxis.drawZeroLineEnabled = YES;//从0开始绘画
    leftAxis.spaceTop = 0.15;//最大值到顶部的范围比
    leftAxis.drawLimitLinesBehindDataEnabled = YES;//设置限制线绘制在柱形图的后面
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    leftAxis.labelTextColor =  [UIColor blueColor];//label文字颜色
    leftAxis.axisLineColor = [UIColor blueColor];//轴线的颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
//    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
//    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
//    leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
    //5.图例样式
    ChartLegend *l = _chartView.legend;//
    l.enabled = YES;//显示图例说明
    l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;//水平方向
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;//垂直方向
    l.orientation = ChartLegendOrientationHorizontal;//方向
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    l.formToTextSpace = 5;//文本间隔
    l.font = [UIFont systemFontOfSize:10];//字体大小
    l.form = ChartLegendFormCircle;//图示样式: 方形、线条、圆形
    l.formSize = 12;//图示大小
    l.textColor = [UIColor grayColor];//字体颜色
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
//count 总个数 range 数量
- (void)setLineDataCount:(int)count range:(double)range
{
    //添加随机数据
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        double val = arc4random_uniform(range) + 3;
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {//更新数据
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yVals1;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {//首次生成
        set1 = [[LineChartDataSet alloc] initWithValues:yVals1 label:@"第一条"];
        [set1 setColor:UIColor.redColor];
        [set1 setCircleColor:UIColor.redColor];//拐点颜色
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
//        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        set1.drawCircleHoleEnabled =NO;
        set1.drawCirclesEnabled = NO;//是否绘制拐点
        set1.drawCubicEnabled = YES;
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
        set1.drawValuesEnabled = NO;//是否在拐点处显示数据
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
