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
#define TJRandomColor      [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f]

@interface ChartBaseViewController : UIViewController
- (CGSize)getScreenSize;
- (UIColor *)colorWithHexString:(NSString *)color ;
- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView;
@end
