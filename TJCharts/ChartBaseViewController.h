//
//  ChartBaseViewController.h
//  TJCharts
//
//  Created by 王朋涛 on 17/2/8.
//  Copyright © 2017年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "TJCharts-Bridging-Header.h"

@interface ChartBaseViewController : UIViewController
- (CGSize)getScreenSize;
- (UIColor *)colorWithHexString:(NSString *)color ;
- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView;
- (void)setupPieChartView:(PieChartView *)chartView;
@end
