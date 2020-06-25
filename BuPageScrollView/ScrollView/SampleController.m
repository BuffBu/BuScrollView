//
//  SampleController.m
//  TestProj
//
//  Created by baffin on 2019/12/24.
//  Copyright © 2019 baffin. All rights reserved.
//

#import "SampleController.h"
#import "BuScrollView.h"
#import "BuViewController.h"
#import "CustomViewController.h"

#define  SSHeight [UIScreen mainScreen].bounds.size.height

@interface SampleController ()<BuViewControllerDelegate,BuViewControllerDataSource>

@property (nonatomic , strong) NSArray *pageArray;

@property (nonatomic, strong) NSMutableArray *originArray;

@property (nonatomic, strong) BuViewController *controller;

@property (nonatomic, strong) UIView *contentView;
@end

@implementation SampleController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    
    self.controller = [[BuViewController alloc] initWithPagingSizeArray:@[@(SSHeight),@(1.8 * SSHeight),@(2 * SSHeight),@(SSHeight),@(SSHeight * 2)] dataSource:self delegate:self];
    self.contentView = self.controller.view;
    self.contentView.frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:self.contentView];
    
}

- (NSInteger)numberOfControllersInPagerController {
    return 5;
}

- (UIViewController *)pagerController:(BuViewController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    
    CustomViewController *VC = [[CustomViewController alloc]init];
    VC.text = [@(index) stringValue];
    return VC;
}


#pragma mark - UIViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    
}
@end
