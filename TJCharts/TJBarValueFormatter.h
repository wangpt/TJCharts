//
//  TJBarValueFormatter.h
//  TJCharts
//
//  Created by tao on 2018/9/14.
//  Copyright © 2018年 tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJCharts-Bridging-Header.h"

@interface TJBarValueFormatter : NSObject<IChartAxisValueFormatter>
@property (nonatomic, copy)NSArray *months;

@end
