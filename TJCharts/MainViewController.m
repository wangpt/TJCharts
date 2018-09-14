//
//  MainViewController.m
//  TJCharts
//
//  Created by 王朋涛 on 17/2/7.
//  Copyright © 2017年 tao. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController * viewController = [segue destinationViewController];
    
    if ([segue.identifier isEqualToString:@"lineChart"]) {
        
        //Add line chart
        
        viewController.title = @"Line Chart";
        
    } else if ([segue.identifier isEqualToString:@"barChart"])
    {
        //Add bar chart
        
        viewController.title = @"Bar Chart";
    }else if ([segue.identifier isEqualToString:@"pieChart"])
    {
        //Add bar chart
        
        viewController.title = @"Pie Chart";
    }else if ([segue.identifier isEqualToString:@"scatterChart"])
    {
        //Add bar chart
        
        viewController.title = @"Scatter Chart";
    }else if ([segue.identifier isEqualToString:@"hbarChart"])
    {
        //Add bar chart
        
        viewController.title = @"Horizontalbar Chart";
    }else{
        
        viewController.title = @"Radar Chart";
        
    }
    
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
