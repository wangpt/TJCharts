//
//  TJBarValueFormatter.m
//  TJCharts
//
//  Created by tao on 2018/9/14.
//  Copyright © 2018年 tao. All rights reserved.
//

#import "TJBarValueFormatter.h"

@implementation TJBarValueFormatter
- (id)init
{
    self = [super init];
    if (self)
    {
        _months = @[@"第一资源数据",@"第二资源数据",@"第三资源数据",@"第四资源数据",@"第五资源数据",@"第六",@"第七"];
        
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    int index = (int)value;
    if (index < 0) {
        return @"";
    }
    return _months[index];
    
}
@end
