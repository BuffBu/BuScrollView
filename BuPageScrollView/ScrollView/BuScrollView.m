//
//  BuScrollView.m
//  BuScrollView
//
//  Created by Martin on 02-04-13.
//  Copyright (c) 2013 Martin Metselaar. All rights reserved.
//

#import "BuScrollView.h"

#define  SHeight [UIScreen mainScreen].bounds.size.height


typedef NS_ENUM(NSUInteger,PagingScrollDirection) {
    
    PagingScrollDirectionUp,
    PagingScrollDierationDown
    
};

typedef NS_ENUM(NSUInteger,PagingScrollPosition) {
    
    PagingScrollPositionTop,
    PagingScrollPositionBottom
    
};

@interface  BuScrollView()

@property (nonatomic,assign) PagingScrollDirection slideDirection;

@property (nonatomic,assign) CGPoint endScrollingPoint;
@property (nonatomic,assign) CGPoint startDraggingPoint;
@property (nonatomic,assign) NSInteger pageToScroll;
@property (nonatomic,assign) NSInteger pageFrom;

@end

@implementation BuScrollView

@synthesize type = _type;

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame andType:BuScrollVertical];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andType:(BuScrollType) type {
    self = [super initWithFrame:frame];
    
    if (self) {
        _type = type;
        _scrollingTime = 0.35f;
        self.endScrollingPoint = CGPointZero;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = 0.1;
        self.delegate = self;
    }
    
    return self;
}

#pragma mark - ScrollView Position Helpers

- (CGFloat) CGPoint:(CGPoint) point {
    if (_type == BuScrollVertical)
        return point.y;
    else
        return point.x;
}

- (CGFloat) contentScrollOffset:(UIScrollView *) scrollView {
    if (_type == BuScrollVertical)
        return scrollView.contentOffset.y;
    else
        return scrollView.contentOffset.x;
}

- (CGFloat) contentScrollSize:(UIScrollView *) scrollView {
    if (_type == BuScrollVertical)
        return scrollView.contentSize.height;
    else
        return scrollView.contentSize.width;
}

- (CGFloat) contentSize:(CGSize) size {
    if (_type == BuScrollVertical)
        return size.height;
    else
        return size.width;
}

- (CGFloat) contentSizeReversed:(CGSize) size {
    if (_type == BuScrollVertical)
        return size.width;
    else
        return size.height;
}

- (CGFloat) frameSize:(UIView *) view {
    return [self CGRectSize:view.frame];
}

- (CGFloat) frameOrigin:(UIView *) view {
    return [self CGRectOrigin:view.frame];
}

- (CGFloat) CGRectOrigin:(CGRect) rect {
    if (_type == BuScrollVertical)
        return rect.origin.y;
    else
        return rect.origin.x;
}

- (CGFloat) CGRectSize:(CGRect) rect {
    if (_type == BuScrollVertical)
        return rect.size.height;
    else
        return rect.size.width;
}

- (CGSize) setCGSize:(CGSize) size withValue:(CGFloat) value {
    if (_type == BuScrollVertical)
        size.height = value;
    else
        size.width = value;
    
    return size;
}

- (CGSize) CGSizeMake:(CGFloat) value1 and:(CGFloat) value2 {
    if (_type == BuScrollVertical)
        return CGSizeMake(value1, value2);
    else
        return CGSizeMake(value2, value1);
}

#pragma mark - Custom ScrollView Helpers

- (BOOL) isScrollViewBouncing:(UIScrollView *) scrollView {
    if ([self contentScrollOffset:scrollView] < 0)
        return YES;
    
    if ([self contentScrollOffset:scrollView] > ([self contentScrollSize:scrollView] - [self frameSize:scrollView]))
        return YES;
    
    return NO;
}

- (void)setContentScrollOffset:(CGFloat) value {
    
    CGPoint contentOffset = CGPointZero;
    if (_type == BuScrollVertical) {
        contentOffset = CGPointMake(0, value);
    } else {
        contentOffset = CGPointMake(value, 0);
    }
    
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:_scrollingTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut
                     animations:^{ [self setContentOffset:contentOffset animated:NO]; }
                     completion:^(BOOL finished){
        [self.buDelegate scrollView:weakself didScrollToPage:weakself.pageToScroll fromPage:weakself.pageFrom];
    }];
    
}

#pragma mark - Scroll to pages

- (void) scrollToPage:(NSInteger) index {
    
    if (self.slideDirection == PagingScrollDirectionUp) {
        [self scrollToPage:index withPosition:PagingScrollPositionTop];
    } else {
        [self scrollToPage:index withPosition:PagingScrollPositionBottom];
    }
    
}

- (void) scrollToPage:(NSInteger) index withPosition:(PagingScrollPosition) position {
    self.pageFrom = self.currentPage;
    self.currentPage = index;
    CGFloat value = 0;
    if (position == PagingScrollPositionTop) {
        value = [self.pageOriginArray[index] floatValue];
    } else if (position == PagingScrollPositionBottom) {
        value = [self.pageOriginArray[index + 1] floatValue] - SHeight;
    }
    
    if (!(value + [self frameSize:self] < [self contentScrollSize:self])) {
        value = [self contentScrollSize:self] - [self frameSize:self];
    }
    
    [self setContentScrollOffset:value];

}

// Scroll to next page
- (void) scrollToNextPage {
    if (self.pageToScroll < self.pageOriginArray.count) {
          self.pageToScroll += 1;
      } else {
          self.pageToScroll = self.pageOriginArray.count -1;
      }
    [self scrollToPage:self.pageToScroll];
    
    if ([self.buDelegate respondsToSelector:@selector(scrollView:didScrollToPage:fromPage:)]) {
        [self.buDelegate scrollView:self willScrollToPage:self.pageToScroll fromPage:self.pageToScroll - 1];
    }
}

// Scroll to previous page
- (void) scrollToPreviousPage {
    
    if (self.pageToScroll > 0) {
        self.pageToScroll -= 1;
    } else {
        self.pageToScroll = 0;
    }
    [self scrollToPage:self.pageToScroll];
    
    if ([self.buDelegate respondsToSelector:@selector(scrollView:didScrollToPage:fromPage:)]) {
        [self.buDelegate scrollView:self willScrollToPage:self.pageToScroll fromPage:self.pageToScroll + 1];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // Keep track when started dragging
    self.startDraggingPoint = scrollView.contentOffset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // Check if the ScrollView is within his bounds
    if ([self isScrollViewBouncing:scrollView]){
        return;
    }
    
    if (!scrollView.isDragging) {
        
        if ([self contentScrollOffset:scrollView] < [self.pageOriginArray[_currentPage] floatValue] && [self contentScrollOffset:scrollView] + SHeight > [self.pageOriginArray[_currentPage] floatValue]) {
            
            if([self.pageOriginArray[_currentPage] floatValue] - [self contentScrollOffset:scrollView] < SHeight / 2) {
                [self scrollToPage:_currentPage withPosition:PagingScrollPositionTop];
            } else {
                [self scrollToPage:_currentPage - 1 withPosition:PagingScrollPositionBottom];
            }
            return;
            
        } else if(_currentPage + 1 <self.pageOriginArray.count &&[self contentScrollOffset:scrollView] < [self.pageOriginArray[_currentPage + 1] floatValue] && [self contentScrollOffset:scrollView] + SHeight > [self.pageOriginArray[_currentPage + 1] floatValue]) {
            
            if([self.pageOriginArray[_currentPage + 1] floatValue] - [self contentScrollOffset:scrollView] > SHeight / 2) {
                [self scrollToPage:_currentPage withPosition:PagingScrollPositionBottom];
            } else {
                 [self scrollToPage:_currentPage + 1 withPosition:PagingScrollPositionTop];
            }
            return;
        }
    }
    // Content Offset where the user did end dragging
    self.endScrollingPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // Check if the scrollview is not bouncing.
    if ([self isScrollViewBouncing:scrollView]) {
        return;
    }

    if (_currentPage >= self.pageSizeArray.count || _currentPage < 0) {
        return;
    }

    if (!CGPointEqualToPoint(self.endScrollingPoint, CGPointZero)) {

        int startPoint = [self CGPoint:self.endScrollingPoint];
        self.endScrollingPoint = CGPointZero;
        NSLog(@"--------->%f--------->%ld",scrollView.contentOffset.y,_currentPage);

        if (startPoint < [self contentScrollOffset:scrollView]) {
            self.slideDirection = PagingScrollDirectionUp;
            if(_currentPage + 1 <self.pageOriginArray.count && scrollView.contentOffset.y +SHeight > [self.pageOriginArray[_currentPage + 1] floatValue]) {
                NSLog(@"--------->%f-------> %f --------->%ld",scrollView.contentOffset.y,[self.pageOriginArray[_currentPage + 1] floatValue],_currentPage);
                 [self scrollToNextPage];
            }
        } else {
            self.slideDirection = PagingScrollDierationDown;
            NSLog(@"--------->%f--------->%ld",scrollView.contentOffset.y,_currentPage);
            if (scrollView.contentOffset.y <= [self.pageOriginArray[_currentPage] floatValue]) {
                [self scrollToPreviousPage];
            }
        }

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self isScrollViewBouncing:scrollView]) {
        return;
    }
    
    if (_currentPage >= self.pageSizeArray.count || _currentPage < 0) {
        return;
    }
    
    if (self.slideDirection == PagingScrollDirectionUp) {
        if(_currentPage + 1 <self.pageOriginArray.count && scrollView.contentOffset.y +SHeight > [self.pageOriginArray[_currentPage + 1] floatValue]) {
            [self scrollToNextPage];
        }
    } else {
        self.slideDirection = PagingScrollDierationDown;
        if (scrollView.contentOffset.y <= [self.pageOriginArray[_currentPage] floatValue]) {
            [self scrollToPreviousPage];
        }
    }
}


@end

