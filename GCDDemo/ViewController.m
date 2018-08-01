//
//  ViewController.m
//  GCDDemo
//
//  Created by 天空吸引我 on 2018/7/28.
//  Copyright © 2018年 天空吸引我. All rights reserved.
//
#define WeakSelf(type) __weak typeof(type) weak##type = type

#import "ViewController.h"
#import "View.h"
@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createContentView];
    
}
-(void)createContentView
{
    View *view = [[View alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
