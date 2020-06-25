//
//  BuScrollView.h
//  BuScrollView
//
//  Created by Martin on 02-04-13.
//  Copyright (c) 2013 Martin Metselaar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BuScrollHorizontal,
    BuScrollVertical
} BuScrollType;

@class BuScrollView;

@protocol BuScrollViewDelegate <NSObject>

- (void) scrollView:(BuScrollView *) scrollView willScrollToPage:(NSUInteger) toIndex fromPage:(NSUInteger)fromIndex;
- (void) scrollView:(BuScrollView *) scrollView didScrollToPage:(NSUInteger) toIndex fromPage:(NSUInteger)fromIndex;

@end

@interface BuScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic,assign) BuScrollType type;


// Time it takes to scroll to next page
@property (nonatomic) CGFloat scrollingTime;

@property (nonatomic) NSUInteger currentPage;

@property (nonatomic, weak) id<BuScrollViewDelegate> buDelegate;

@property (nonatomic, strong) NSArray *pageSizeArray;

@property (nonatomic, strong) NSMutableArray *pageOriginArray;


- (id)initWithFrame:(CGRect)frame andType:(BuScrollType) type;
- (void) scrollToPage:(NSInteger) index;

@end
