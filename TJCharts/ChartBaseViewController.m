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
