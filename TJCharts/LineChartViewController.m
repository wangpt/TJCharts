//
//  LineChartViewController.m
//  TJCharts
//
//  Created by 王朋涛 on 17/2/13.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "LineChartViewController.h"
#import "TJCharts-Bridging-Header.h"

@interface LineChartViewController ()<IChartAxisValueFormatter>
@property (nonatomic, strong)LineChartView *chartView;
@property (nonatomic, copy)NSArray *months;
@end

@implementation LineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _months = @[@"第一",@"第二",@"第三",@"第四",@"第五",@"第六",@"第七"];
    CGFloat width =[UIScreen mainScreen].bounds.size.width - 20;
    CGFloat height =[UIScreen mainScreen].bounds.size.height - 300;
    _chartView = ({
        //1.初始化对象
        
        LineChartView *lineChart = [[LineChartView alloc] init];
        [self.view addSubview:lineChart];
        [lineChart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.center.mas_equalTo(self.view);
        }];
        //2.设置交互样式
        
        lineChart.noDataText = @"暂无数据";//没有数据时的文字提示
        
        lineChart.rightAxis.enabled = NO;//不绘制右边轴
        
        lineChart.drawGridBackgroundEnabled = NO;//是否绘制网格背景的标志
        
        lineChart.chartDescription.enabled = NO;//是否显示图标描述
        
        lineChart.chartDescription.text = @"折现图";
        
        lineChart.scaleXEnabled = NO;//取消X轴缩放
        
        lineChart.scaleYEnabled = NO;//取消Y轴缩放
        
        lineChart.pinchZoomEnabled = NO;//XY轴是否同时缩放
        
        lineChart.doubleTapToZoomEnabled = NO;//取消双击缩放
        
        lineChart.dragEnabled = YES;//启用拖拽图表
        
        lineChart.dragDecelerationEnabled = YES;//拖拽饼状图后是否有惯性效果
        //3.设置x轴的样式
        
        ChartXAxis *xAxis = lineChart.xAxis;
        
        xAxis.drawGridLinesEnabled = NO;//不绘制网格线为NO 绘制为YES
        
        xAxis.axisLineWidth = 1.0/[UIScreen mainScreen].scale;//设置X轴线宽
        
        xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
        
        xAxis.labelTextColor = [UIColor blueColor];//label文字颜色
        
        xAxis.axisLineColor = [UIColor blueColor];//x轴线的颜色
        
        xAxis.valueFormatter = self;//用于设置x轴文字显示
        
        xAxis.spaceMin = 0.5;//设置坐标轴额外的最小空间
        
        xAxis.spaceMax = 0.5;//设置坐标轴额外的最大空间
        
        //4.设置y轴的样式
        
        ChartYAxis *leftAxis = lineChart.leftAxis;//获取左边Y轴
        
        leftAxis.drawGridLinesEnabled = NO;//不绘制网格线
        
        leftAxis.axisLineWidth = 1.0/[UIScreen mainScreen].scale;//Y轴线宽
        
        leftAxis.labelCount = 5;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        
        leftAxis.forceLabelsEnabled = NO;//不强制绘制指定数量的label
        
        //    leftAxis.axisMaximum = 150.0;//设置Y轴的最大值
        
        leftAxis.axisMinimum = 0.0;//设置Y轴的最小值
        
        leftAxis.drawZeroLineEnabled = NO;//从0开始绘画
        
        leftAxis.spaceTop = 0.05;//最大值到顶部的范围比
        
        leftAxis.drawLimitLinesBehindDataEnabled = YES;//设置限制线绘制在柱形图的后面
        
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
        
        leftAxis.labelTextColor =  [UIColor blueColor];//label文字颜色
        
        leftAxis.axisLineColor = [UIColor blueColor];//轴线的颜色
        
        leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
        //5.图例样式
        
        ChartLegend *l = lineChart.legend;//
       
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
        
        lineChart;
    });

    [self updateChartData];//添加数据
    
}
- (IBAction)reloadDataClick:(id)sender {
    [self updateChartData];
}

- (void)updateChartData
{
    double range = 100;//最大随机数
    NSInteger lineCount = 2;//条数
    //添加随机数据
    NSMutableArray *all_vals = @[].mutableCopy;
    for (int count = 0; count<lineCount; count++) {
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < _months.count; i++)
        {
            double val = arc4random_uniform(range) + 10;
            [yVals addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
        }
        [all_vals addObject:yVals];
    }
    
    if (_chartView.data.dataSetCount > 0)
    {//更新数据
        [all_vals enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LineChartDataSet *set = (LineChartDataSet *)_chartView.data.dataSets[idx];
            set.values = obj;
        }];
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    
    }else{
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];

        [all_vals enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *label = [NSString stringWithFormat:@"第%lu条",(unsigned long)idx+1];
            LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:all_vals[idx] label:label];
            [set setColor:TJRandomColor];
            set.lineWidth = 1.0;//线条宽度
            set.drawCircleHoleEnabled =NO;
            [set setCircleColor:UIColor.redColor];//拐点颜色
            set.circleRadius = 3.0;//拐点半径
            set.drawCirclesEnabled = NO;//是否绘制拐点
            set.drawCubicEnabled = YES;
            //填充色
//            NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
//                                        (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor];
//            CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
//            set.fillAlpha = 0.3f;//透明度
//            set.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];//赋值填充颜色对象
//            set.drawFilledEnabled = YES;//是否填充颜色
//            CGGradientRelease(gradient);
            [dataSets addObject:set];
        }];
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.blackColor];//文字颜色
        [data setValueFont:[UIFont systemFontOfSize:9.f]];//文字大小
        _chartView.data = data;
    }
    
    [_chartView animateWithXAxisDuration:0.5];
}


#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    NSInteger index = value;
    return _months[index];
}


@end
