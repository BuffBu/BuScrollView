//
//  BuViewController.h
//  TestProj
//
//  Created by baffin on 2019/12/27.
//  Copyright © 2019 baffin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BuViewController;

NS_ASSUME_NONNULL_BEGIN



@protocol BuViewControllerDataSource <NSObject>

- (NSInteger)numberOfControllersInPagerController;

- (UIViewController *)pagerController:(BuViewController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching;


@end

@protocol BuViewControllerDelegate <NSObject>

@optional

- (void)pagerController:(BuViewController *)pagerController viewWillAppear:(UIViewController *)viewController forIndex:(NSInteger)index;
- (void)pagerController:(BuViewController *)pagerController viewDidAppear:(UIViewController *)viewController forIndex:(NSInteger)index;
- (void)pagerController:(BuViewController *)pagerController viewWillDisappear:(UIViewController *)viewController forIndex:(NSInteger)index;
- (void)pagerController:(BuViewController *)pagerController viewDidDisappear:(UIViewController *)viewController forIndex:(NSInteger)index;

@end


@interface BuViewController : UIViewController

@property (nonatomic, weak, nullable) id<BuViewControllerDataSource> dataSource;
@property (nonatomic, weak, nullable) id<BuViewControllerDelegate>   myDelegate;


@property (nonatomic, assign) BOOL automaticallySystemManagerViewAppearanceMethods;

- (instancetype)initWithPagingSizeArray:(NSArray *)pageSizeArray dataSource:(id<BuViewControllerDataSource>) datasource
 delegate:(id<BuViewControllerDelegate>) delegate;

@end

NS_ASSUME_NONNULL_END
