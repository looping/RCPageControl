//
//  RCPageControl.m
//  RCPageControlExample
//
//  Created by Looping on 14/9/15.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

/**
 The MIT License (MIT)
 
 Copyright (c) 2014 RidgeCorn
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "RCPageControl.h"
#import <POP.h>

#define RCDefaultIndicatorDotBaseTag 1009

#define RCDefaultIndicatorDotGapMinValue 2.f
#define RCDefaultIndicatorDotWidthMinValue 2.f

#define RCDefaultIndicatorDotAnimationDurationMinValue 0.01f
#define RCDefaultIndicatorDotScaleFactorMinValue 0

#define RCDefaultIndicatorDotIndexDisplayMinWidth 8.f

#define RCDefaultIndicatorDotChangeProgressMaxValue 1.f
#define RCDefaultIndicatorDotChangeProgressMinValue .01f

#define RCDefaultIndicatorScaleAnimationKey @"RCPageControlIndicatorScaleAnimation"
#define RCDefaultIndicatorColorAnimationKey @"RCPageControlIndicatorColorAnimation"
#define RCDefaultIndicatorIndexLabelAlphaAnimationKey @"RCDefaultIndicatorIndexLabelAlphaAnimationKey"

#define IsFloatZero(A) fabsf(A) < FLT_EPSILON
#define IsFloatEqualToFloat(A, B) IsFloatZero((A) - (B))

@interface RCPageControl ()

@property (nonatomic) NSInteger currentDisplayedPage;
@property (nonatomic) NSInteger previousDisplayPage;
@property (nonatomic) UILabel *indicatorIndexLabel;

@end

@implementation RCPageControl

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commConfig];
    }
    
    return self;
}

- (instancetype)initWithNumberOfPages:(NSInteger)pages {
    RCPageControl *pageControl = [self init];
    
    if (pageControl) {
        [pageControl setNumberOfPages:pages];
    }
    
    return pageControl;
}

- (void)awakeFromNib {
    [self commConfig];
}

- (void)commConfig {
    _currentDisplayedPage = 0;
    _previousDisplayPage = 0;
    
    _numberOfPages = 0;
    _currentPage = 0;
    
    _indicatorDotGap = 10.f;
    _indicatorDotWidth = 4.f;
    
    _animationSpeed = 8.f;
    _animationBounciness = 12.f;
    _animationDuration = .6f;
    _animationScaleFactor = 2;
    
    _hidesForSinglePage = NO;
    _defersCurrentPageDisplay = NO;
    _hideCurrentPageIndex = NO;
    _disableAnimation = NO;
    
    _pageIndicatorTintColor = [UIColor lightTextColor];
    _currentPageIndicatorTintColor = [UIColor whiteColor];
    _currentPageIndexTextTintColor = [UIColor darkTextColor];
    
    _currentPageIndexTextFont = [UIFont systemFontOfSize:0];
    
    [self loadIndicatorIndexLabel];
    
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)loadIndicatorIndexLabel {
    CGFloat width = MAX(RCDefaultIndicatorDotIndexDisplayMinWidth, [self _scaledDotMaxWidth]);
    
    if (_indicatorIndexLabel) {
        [_indicatorIndexLabel setFrame:CGRectMake(0, 0, width, width)];
    } else {
        _indicatorIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        
        [_indicatorIndexLabel setTextAlignment:NSTextAlignmentCenter];
        [_indicatorIndexLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    [_indicatorIndexLabel setTextColor:_currentPageIndexTextTintColor];
    
    [_indicatorIndexLabel setFont:[_currentPageIndexTextFont fontWithSize:[self _scaledDotMaxWidth] * 2 / 3]];
    
    [_indicatorIndexLabel setHidden:_hideCurrentPageIndex];

    UIView *dot = [self _currentDisplayedDot];
    
    if (dot) {
        [_indicatorIndexLabel setCenter:dot.center];
    } else {
        [_indicatorIndexLabel setHidden:YES];
    }
}

#pragma mark - Properties

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (numberOfPages >= 0 && numberOfPages != _numberOfPages) {
        _numberOfPages = numberOfPages;
        
        [self _refreshIndicator:YES];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage forceRefresh:(BOOL)forceRefresh {
    _previousDisplayPage = _currentPage;
    
    _currentPage = MIN(MAX(0, currentPage), _numberOfPages - 1);
    
    if ( !self.defersCurrentPageDisplay || forceRefresh) {
        _currentDisplayedPage = _currentPage;
        [self _animateIndicator:forceRefresh];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [self setCurrentPage:currentPage forceRefresh:NO];
}

- (void)setIndicatorDotGap:(CGFloat)indicatorDotGap {
    CGFloat gap = MAX(RCDefaultIndicatorDotGapMinValue, indicatorDotGap);
    
    if ( !IsFloatEqualToFloat(_indicatorDotGap, gap)) {
        _indicatorDotGap = gap;
        
        [self _refreshIndicator:YES];
    }
}

- (void)setIndicatorDotWidth:(CGFloat)indicatorDotWidth {
    CGFloat width = MAX(RCDefaultIndicatorDotWidthMinValue, indicatorDotWidth);
    
    if ( !IsFloatEqualToFloat(_indicatorDotWidth, width)) {
        _indicatorDotWidth = width;
        
        [self loadIndicatorIndexLabel];
        [self _refreshIndicator:YES];
    }
}

- (void)setAnimationScaleFactor:(NSInteger)animationScaleFactor {
    if ( _animationScaleFactor != animationScaleFactor) {
        _animationScaleFactor = MAX(RCDefaultIndicatorDotScaleFactorMinValue, animationScaleFactor);
        
        [self loadIndicatorIndexLabel];
        [self _dotScaleAnimationAtIndex:_currentDisplayedPage withProgress:RCDefaultIndicatorDotChangeProgressMaxValue];
    }
}

- (void)setFrame:(CGRect)frame {
    if ( !CGRectEqualToRect(self.frame, frame)) {
        [super setFrame:frame];
        [self _refreshIndicator:YES];
    }
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    if (_hidesForSinglePage != hidesForSinglePage) {
        _hidesForSinglePage = hidesForSinglePage;
        [self _refreshIndicator:YES];
    }
}

- (void)setHideCurrentPageIndex:(BOOL)hideCurrentPageIndex {
    if (_hideCurrentPageIndex != hideCurrentPageIndex) {
        _hideCurrentPageIndex = hideCurrentPageIndex;
        [self loadIndicatorIndexLabel];
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    if ( ![_pageIndicatorTintColor isEqual:pageIndicatorTintColor]) {
        _pageIndicatorTintColor = pageIndicatorTintColor;
        [self _refreshIndicator:YES];
    }
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    if ( ![_currentPageIndicatorTintColor isEqual:currentPageIndicatorTintColor]) {
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        [self _dotColorAnimationAtIndex:_currentDisplayedPage withProgress:RCDefaultIndicatorDotChangeProgressMaxValue];
    }
}

- (void)setCurrentPageIndexTintColor:(UIColor *)currentPageIndexTintColor {
    if ( ![_currentPageIndexTextTintColor isEqual:currentPageIndexTintColor]) {
        _currentPageIndexTextTintColor = currentPageIndexTintColor;
        [self loadIndicatorIndexLabel];
    }
}

- (void)setCurrentPageIndexTextFont:(UIFont *)currentPageIndexTextFont {
    if ( ![_currentPageIndexTextFont isEqual:currentPageIndexTextFont]) {
        _currentPageIndexTextFont = currentPageIndexTextFont;
        [self loadIndicatorIndexLabel];
    }
}

#pragma mark - Touch Event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] locationInView:self].x < [self positionForNumberOfPages:self.numberOfPages].x + [self sizeForNumberOfPages:self.currentDisplayedPage + 1].width - _indicatorDotWidth / 2) {
        [self setCurrentPage:self.currentPage - 1 forceRefresh:NO];
    } else {
        [self setCurrentPage:self.currentPage + 1 forceRefresh:NO];
    }
    
    if (_currentPageChangedBlock) {
        _currentPageChangedBlock(self);
    } else {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Public Methods
#pragma mark Frame Helper

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    return CGSizeMake((_indicatorDotGap + _indicatorDotWidth) * pageCount - _indicatorDotGap, _indicatorDotWidth);
}

- (CGPoint)positionForNumberOfPages:(NSInteger)pageCount {
    return CGPointMake((self.frame.size.width - (_indicatorDotGap + _indicatorDotWidth) * pageCount + _indicatorDotGap) / 2, (self.frame.size.height - _indicatorDotWidth) / 2);
}

#pragma mark Page Update

- (void)updateCurrentPageDisplay {
    _currentDisplayedPage = _currentPage;
    [self _animateIndicator:NO];
}

- (void)switchToPage:(NSInteger)page progress:(CGFloat)progress {
    [self _animationFromPage:_currentDisplayedPage toPage:page withProgress:progress];
}

#pragma mark - Private Methods

#pragma mark Common

- (NSInteger)_dotTagAtIndex:(NSInteger )index {
    return RCDefaultIndicatorDotBaseTag * (index + 1);
}

- (UIView *)_dotAtIndex:(NSInteger)index {
    return [self viewWithTag:[self _dotTagAtIndex:index]];
}

- (UIView *)_previousDisplayDot {
    return [self _dotAtIndex:_previousDisplayPage];
}

- (UIView *)_currentDisplayedDot {
    return [self _dotAtIndex:_currentDisplayedPage];
}

- (CGFloat)_scaledDotMaxWidth {
    return _indicatorDotWidth * (1 + _animationScaleFactor);
}

#pragma mark  Indicator Animation

- (void)_dotScaleAnimationAtIndex:(NSInteger)index toValue:(id)toValue {
    UIView *dot = [self _dotAtIndex:index];

    [dot pop_removeAnimationForKey:RCDefaultIndicatorScaleAnimationKey];
    
    POPPropertyAnimation *animation;
    
    if (_disableAnimation) {
        animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        ((POPBasicAnimation *)animation).duration = RCDefaultIndicatorDotAnimationDurationMinValue;
    } else {
        animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        ((POPSpringAnimation *)animation).springSpeed = _animationSpeed;
        ((POPSpringAnimation *)animation).springBounciness = _animationBounciness;
    }
    
    [animation setRemovedOnCompletion:YES];
    animation.toValue = toValue;
    
    [dot pop_addAnimation:animation forKey:RCDefaultIndicatorScaleAnimationKey];
}

- (void)_dotColorAnimationAtIndex:(NSInteger)index toValue:(id)toValue {
    UIView *dot = [self _dotAtIndex:index];

    [dot pop_removeAnimationForKey:RCDefaultIndicatorColorAnimationKey];
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    [animation setRemovedOnCompletion:YES];
    animation.toValue = toValue;
    animation.duration = _disableAnimation ? RCDefaultIndicatorDotAnimationDurationMinValue : _animationDuration;
    
    [dot pop_addAnimation:animation forKey:RCDefaultIndicatorColorAnimationKey];
}

- (void)_dotScaleAnimationAtIndex:(NSInteger)index withProgress:(CGFloat)progress {
    [self _dotScaleAnimationAtIndex:index toValue:[NSValue valueWithCGPoint:CGPointMake(1.f + _animationScaleFactor * progress, 1.f +_animationScaleFactor * progress)]];
}

- (void)_dotColorAnimationAtIndex:(NSInteger)index withProgress:(CGFloat)progress {
    [self _dotColorAnimationAtIndex:index toValue:(index == _currentDisplayedPage) ? _currentPageIndicatorTintColor : _pageIndicatorTintColor];
}

- (void)_animationFromPage:(NSInteger)fromPage toPage:(NSInteger)toPage withProgress:(CGFloat)progress {
    if (toPage >= 0 && fromPage >= 0) {
        [self _dotScaleAnimationAtIndex:fromPage withProgress:1 - progress];
        [self _dotScaleAnimationAtIndex:toPage withProgress:progress];
        
        [self _dotColorAnimationAtIndex:fromPage withProgress:1 - progress];
        [self _dotColorAnimationAtIndex:toPage withProgress:progress];
        
        BOOL hidden = ![self _dotAtIndex:toPage] || ([self _scaledDotMaxWidth] < RCDefaultIndicatorDotIndexDisplayMinWidth) || (progress < 1 - RCDefaultIndicatorDotChangeProgressMinValue) || _hideCurrentPageIndex;
        
        [_indicatorIndexLabel setHidden:hidden];
        
        if ( !hidden) {
            [self bringSubviewToFront:_indicatorIndexLabel];

            [_indicatorIndexLabel setCenter:[self _dotAtIndex:toPage].center];
            [_indicatorIndexLabel setText:[NSString stringWithFormat:@"%@", @(toPage + 1)]];
            
            POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            alphaAnimation.fromValue = @(0.f);
            alphaAnimation.toValue = @(1.f);
            alphaAnimation.duration = _disableAnimation ? 0 : _animationDuration;
            [_indicatorIndexLabel pop_addAnimation:alphaAnimation forKey:RCDefaultIndicatorIndexLabelAlphaAnimationKey];
        }
    }
}

- (void)_animateIndicator:(BOOL)forceAnimate {
    if (forceAnimate || _previousDisplayPage != _currentDisplayedPage) {
        [self _animationFromPage:_previousDisplayPage toPage:_currentDisplayedPage withProgress:1.f];
    }
}

#pragma mark Indicator Refresh

- (void)_refreshIndicator:(BOOL)forceRefresh {
    if ( !(_hidesForSinglePage && _numberOfPages <= 1)) {
        [self setHidden:NO];
        
        if (forceRefresh || self.subviews.count != _numberOfPages) {
            CGPoint position = [self positionForNumberOfPages:self.numberOfPages];
            
            NSInteger index = 0;

            for (; index < _numberOfPages; index ++) {
                CGRect frame = CGRectMake(position.x + index * (_indicatorDotGap + _indicatorDotWidth), position.y, _indicatorDotWidth, _indicatorDotWidth);
                UIView *dot = [self _dotAtIndex:index] ?: [[UIView alloc] initWithFrame:frame];
                
                if ([UIView respondsToSelector:@selector(performWithoutAnimation:)]) {
                    [UIView performWithoutAnimation:^{
                        [dot setTransform:CGAffineTransformIdentity];
                    }];
                } else {
                    BOOL reenableAnimations = [UIView areAnimationsEnabled];
                    [UIView setAnimationsEnabled:NO];
                    [dot setTransform:CGAffineTransformIdentity];
                    [UIView setAnimationsEnabled:reenableAnimations];
                }
                
                [dot setTag:[self _dotTagAtIndex:index]];
                [dot setBackgroundColor:_pageIndicatorTintColor];
                
                [dot.layer setMasksToBounds:YES];
                [dot.layer setCornerRadius:dot.frame.size.height / 2];
                
                if ( !dot.superview) {
                    [self addSubview:dot];
                } else {
                    [dot setFrame:frame];
                }
            }
            
            for (; self.subviews.count && index < self.subviews.count - 1; index ++) {
                [[self _dotAtIndex:index] removeFromSuperview];
            }
            
            [self _animateIndicator:forceRefresh];
        }
        
        if ( !_indicatorIndexLabel.superview) {
            [self addSubview:_indicatorIndexLabel];
        }
        
        [self bringSubviewToFront:_indicatorIndexLabel];
    } else {
        [self setHidden:YES];
    }
}

@end
