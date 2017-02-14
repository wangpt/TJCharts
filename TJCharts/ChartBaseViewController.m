//
//  ChartBaseViewController.m
//  TJCharts
//
//  Created by 王朋涛 on 17/2/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "ChartBaseViewController.h"
@interface ChartBaseViewController ()

@end

@implementation ChartBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRed:230.0 / 255.0 green:253.0 / 255.0 blue:253.0 / 255.0 alpha:1.0f];
}
- (CGSize)getScreenSize{
    
    return [UIScreen mainScreen].bounds.size;
}
//将十六进制颜色转换为 UIColor 对象
- (UIColor *)colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip "0X" or "#" if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView{
    //设置基本样式
    chartView.chartDescription.enabled = NO;//是否显示图标描述
    chartView.drawGridBackgroundEnabled = NO;//是否绘制网格背景的标志
    chartView.noDataText = @"暂无数据";//没有数据时的文字提示
    chartView.dragEnabled = YES;//启用拖拽图表
    [chartView setScaleEnabled:YES];//图表是否可以进行缩放
    chartView.pinchZoomEnabled = NO;//缩放设置
    //设置交互样式
    chartView.scaleYEnabled = NO;//取消Y轴缩放
    chartView.doubleTapToZoomEnabled = NO;//取消双击缩放
    //设置x轴的样式
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;//x轴文字显示位置
    //    xAxis.drawGridLinesEnabled = NO;//不绘制网格线
    //右边Y轴样式
    chartView.rightAxis.enabled = NO;//不绘制右边轴

}

- (void)setupPieChartView:(PieChartView *)chartView
{
    //基础属性
    chartView.usePercentValuesEnabled = YES;//是否根据所提供的数据, 将显示数据转换为百分比格式
    chartView.dragDecelerationEnabled = YES;//拖拽饼状图后是否有惯性效果
    chartView.drawSliceTextEnabled = YES;//是否显示区块文本
    
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.58;//空心半径占比
    chartView.transparentCircleRadiusPercent = 0.61;//半透明空心半径占比
    chartView.chartDescription.enabled = NO;
    [chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];//饼状图距离边缘的间隙
    
    //设置饼状图中间的空心样式
    
    chartView.drawHoleEnabled = NO;//是否空心
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;
    
    if (chartView.isDrawHoleEnabled == YES) {
        chartView.drawCenterTextEnabled = YES;//是否显示中间文字
        //普通文本
        //  self.pieChartView.centerText = @"饼状图";//中间文字
        //富文本
        NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"个人旅游\n城市分布"];
        [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                    NSForegroundColorAttributeName: [UIColor orangeColor]}
                            range:NSMakeRange(0, centerText.length)];
        chartView.centerAttributedText = centerText;
    }
    //饼状图描述
    
    ChartLegend *l = chartView.legend;
    chartView.legend.enabled = NO;//隐藏描述
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    l.maxSizePercent = 1;//图例在饼状图中的大小占比, 这会影响图例的宽高
    l.formToTextSpace = 5;//文本间隔
    l.font = [UIFont systemFontOfSize:10];//字体大小
    l.textColor = [UIColor grayColor];//字体颜色
    l.position = ChartLegendPositionBelowChartCenter;//图例在饼状图中的位置
    l.form = ChartLegendFormCircle;//图示样式: 方形、线条、圆形
    l.formSize = 12;//图示大小
    
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
