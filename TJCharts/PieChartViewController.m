//
//  PieChartViewController.m
//  TJCharts
//
//  Created by 王朋涛 on 17/2/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "PieChartViewController.h"
#import "TJCharts-Bridging-Header.h"
@interface PieChartViewController ()
@property (nonatomic, strong) PieChartView *chartView;

@end

@implementation PieChartViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建饼状图
    CGFloat chartW =[UIScreen mainScreen].bounds.size.width - 20;
    CGFloat chartH =[UIScreen mainScreen].bounds.size.height - 250;
    _chartView = ({
        //1.初始化对象
        PieChartView *pieChart = [PieChartView new];
        [self.view addSubview:pieChart];
        [pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(chartW, chartH));
            make.center.mas_equalTo(self.view);
        }];
        //2.设置交互样式
        [pieChart setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];//饼状图距离边缘的间隙
        pieChart.usePercentValuesEnabled = YES;//是否根据所提供的数据, 将显示数据转换为百分比格式
        pieChart.dragDecelerationEnabled = YES;//拖拽饼状图后是否有惯性效果
        pieChart.chartDescription.enabled = NO;//饼状图描述文字
        //空心圆样式(空心有两个圆组成, 一个是hole, 一个是transparentCircle, transparentCircle里面是hole, 所以饼状图中间的空心也就是一个同心圆)
        pieChart.drawHoleEnabled = YES;//饼状图是否是空心
        pieChart.rotationAngle = 0.0;//开始角度
        pieChart.rotationEnabled = YES;//是否可以旋转
        pieChart.highlightPerTapEnabled = NO;//是否可以点击
        pieChart.holeRadiusPercent = 0.38;//空心半径占比
        pieChart.holeColor = [UIColor clearColor];//空心颜色
        pieChart.transparentCircleRadiusPercent = 0.41;//半透明空心半径占比
        if (pieChart.isDrawHoleEnabled == YES) {
            pieChart.drawCenterTextEnabled = YES;//是否显示中间文字
            //普通文本
            pieChart.centerText = @"";//中间文字
            //富文本
            NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"饼状图"];
            [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                        NSForegroundColorAttributeName: [UIColor orangeColor]}
                                range:NSMakeRange(0, centerText.length)];
            pieChart.centerAttributedText = centerText;
        }
        //3.图例样式
        ChartLegend *l = pieChart.legend;
        l.enabled = YES;//隐藏描述
        l.form = ChartLegendFormCircle;//图示样式: 方形、线条、圆形
        l.formToTextSpace = 5;//文本间隔
        l.font = [UIFont systemFontOfSize:10];//字体大小
        l.textColor = [UIColor grayColor];//字体颜色
        pieChart;
    });

    [self updateChartData];

}

- (void)updateChartData
{
    int count = 5;
    double range = 100;
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
        
        double randomVal = arc4random_uniform(range) + range / 2;//产生 50~150 的随机数
        [entries addObject:[[PieChartDataEntry alloc] initWithValue:randomVal label:parties[i % parties.count]]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:entries label:@""];
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
    //添加折现
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
    [_chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];

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
