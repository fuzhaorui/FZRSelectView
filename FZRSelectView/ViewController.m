//
//  ViewController.m
//  FZRSelectView
//
//  Created by fuzhaurui on 2017/3/29.
//  Copyright © 2017年 fuzhaurui. All rights reserved.
//

#import "ViewController.h"
#import "FZRSelectView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


-(IBAction)buttonAction:(UIButton *)sender
{
    NSArray *array;
    
    if (sender.tag == 1000) {
        array = @[@"这个是1",@"这个是2",@"这个是3"];
    }
    else if (sender.tag == 1001) {
        array = @[@"这个是1",@"这个是2",@"这个是3",@"这个是4",@"这个是5",@"这个是6"];
    }
    else if (sender.tag == 1002) {
        array = @[@"这个是1",@"这个是2",@"这个是3",@"这个是4",@"这个是5",@"这个是6",@"这个是7",@"这个是8",@"这个是9",@"这个是10"];
    }
    
    [[FZRSelectView sharedView] startChoiceTitle:@"这是我的选择" andSelect:array blockcompletion:^(NSInteger integer) {
        NSLog(@"%ld",(long)integer);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
