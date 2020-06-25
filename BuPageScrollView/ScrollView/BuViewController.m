//
//  BuViewController.m
//  BuViewControllerDemo
//
//  Created by tanyang on 16/4/13.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import "BuViewController.h"
#import "BuScrollView.h"

@interface BuViewController ()<BuScrollViewDelegate>

@property (nonatomic, strong) BuScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *pageOriginArray;
@property (nonatomic, copy) NSArray *pageSizeArray;
@property (nonatomic,assign) NSUInteger numbersOfControllers;
//Cache
@property (nonatomic, assign) NSUInteger prefechCount;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,UIViewController *> *visibleIndexItems;

@end


@implementation BuViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _automaticallySystemManagerViewAppearanceMethods = YES;
        [self setUpData];
    }
    return self;
}

- (instancetype)initWithPagingSizeArray:(NSArray *)pageSizeArray dataSource:(id<BuViewControllerDataSource>) datasource
delegate:(id<BuViewControllerDelegate>) delegate {
    
    if (self = [super init]) {
        self.pageSizeArray = pageSizeArray;
        self.dataSource = datasource;
        self.myDelegate = delegate;
        [self setUpData];
    }
    return self;
    
}

- (void)setUpData {
    self.scrollView.buDelegate = self;
    self.automaticallySystemManagerViewAppearanceMethods = NO;
    self.numbersOfControllers = self.pageSizeArray.count;
    if (self.numbersOfControllers < 3) {
        self.prefechCount = self.numbersOfControllers;
    } else {
        self.prefechCount = 3;
    }
    self.visibleIndexItems = [NSMutableDictionary dictionary];
    NSMutableArray *sumArray = [NSMutableArray array];
     CGFloat origin = 0;
     for (int i =0 ;i <self.pageSizeArray.count;i++) {
         [sumArray addObject:@(origin)];
         origin += [self.pageSizeArray[i] floatValue];
     }
     self.pageOriginArray = sumArray;
     self.scrollView.frame = self.view.bounds;
     self.scrollView.pageSizeArray = self.pageSizeArray;
     self.scrollView.pageOriginArray = self.pageOriginArray;
     self.scrollView.contentSize =CGSizeMake([UIScreen mainScreen].bounds.size.width, [[self.pageOriginArray lastObject] floatValue] + [[self.pageSizeArray lastObject] floatValue]);
}

//first time preload data
- (void)preFetchData {
    for (int i = 0 ;i < self.prefechCount; i++) {
        [self preLoadDataWithIndex:i];
    }
}

//preload data after scroll
- (void)preLoadDataWithIndex:(NSUInteger)index {
    
    UIViewController *vc = [self.dataSource pagerController:self controllerForIndex:index prefetching:YES];
    CGRect frame = CGRectMake(0, [self.pageOriginArray[index] floatValue], [UIScreen mainScreen].bounds.size.width, [self.pageSizeArray[index] floatValue]);
    vc.view.frame = frame;
    [self.visibleIndexItems  setObject:vc forKey:@(index)];
    [self addVisibleItem:vc atIndex:index];
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self preFetchData];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark - getter && setter

- (void)setMyDelegate:(id<BuViewControllerDelegate>)delegate {
    _myDelegate = delegate;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return _automaticallySystemManagerViewAppearanceMethods;
}


#pragma mark - BuViewLayoutDataSource


- (void) addVisibleItem:(id)item atIndex:(NSInteger)index {
    UIViewController *viewController = item;
    // addChildViewController
    [self addChildViewController:viewController];
    [self.scrollView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
}

- (void)removeInVisibleItem:(id)item atIndex:(NSInteger)index {
    UIViewController *viewController = item;
    // removeChildViewController
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    
}



- (void)scrollView:(BuScrollView *)scrollView didScrollToPage:(NSUInteger)toIndex fromPage:(NSUInteger)fromIndex {
    if (toIndex + 1 < self.numbersOfControllers && ![self.visibleIndexItems.allKeys containsObject:@(toIndex + 1)]) {
        [self preLoadDataWithIndex:toIndex + 1];
    }
}



- (void)scrollView:(BuScrollView *)scrollView willScrollToPage:(NSUInteger)toIndex fromPage:(NSUInteger)fromIndex {
    self.currentPageIndex = toIndex;
    if ([self.visibleIndexItems.allKeys containsObject:@(toIndex)]) {
        
        UIViewController *vc = [self.visibleIndexItems objectForKey:@(toIndex)];
        [vc beginAppearanceTransition:YES animated:YES];
        [vc endAppearanceTransition];
        
    } else {
        UIViewController *vc = [_dataSource pagerController:self controllerForIndex:toIndex prefetching:YES];
                CGRect frame = CGRectMake(0, [self.pageOriginArray[toIndex] floatValue], [UIScreen mainScreen].bounds.size.width, [self.pageSizeArray[toIndex] floatValue]);
        vc.view.frame = frame;
        [self.visibleIndexItems  setObject:vc forKey:@(toIndex)];
        [self addVisibleItem:vc atIndex:toIndex];
        [vc beginAppearanceTransition:YES animated:YES];
        [vc endAppearanceTransition];
        
    }
    
     if ([self.visibleIndexItems.allKeys containsObject:@(fromIndex)]) {
         UIViewController *vc = [self.visibleIndexItems objectForKey:@(fromIndex)];
         [vc beginAppearanceTransition:NO animated:YES];
         [vc endAppearanceTransition];
     }
}


- (BuScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[BuScrollView alloc] init];
    }
    return _scrollView;
}


- (void)dealloc {
   
}

@end

