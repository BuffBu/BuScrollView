//
//  CustomViewController.m
//  TYPagerControllerDemo
//
//  Created by tany on 16/4/20.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPageLabel];
}


- (void)addPageLabel {
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:arc4random()%255/255.0];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 - 50 ,CGRectGetHeight(self.view.frame)/2, 100, 50)];
    self.label.text = _text;
    self.label.font = [UIFont systemFontOfSize:32];
    self.label.textColor = [UIColor blackColor];
     self.label .textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [UIColor blackColor].CGColor;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear index %@",_text);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewDidAppear index %@",_text);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear index %@",_text);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewDidDisappear index %@",_text);
}

-(void)setText:(NSString *)text {
    _text = text;
    self.label.text = text;
    [self.view layoutIfNeeded];
}

@end
