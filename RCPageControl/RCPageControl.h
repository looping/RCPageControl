//
//  RCPageControl.h
//  RCPageControl
//
//  Created by Looping on 14/9/15.
//  Copyright (c) 2017 Looping. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCPageControl;

typedef void (^RCCurrentPageChangedBlock)(RCPageControl *pageControl);

@interface RCPageControl : UIControl

@property (nonatomic) NSInteger numberOfPages;  // default is 0
@property (nonatomic) NSInteger currentPage;    // default is 0. value pinned to 0 .. numberOfPages-1

@property (nonatomic) CGFloat indicatorDotGap;  // default is 10.0, min value is 2.0
@property (nonatomic) CGFloat indicatorDotWidth;    // default is 4.0, min value is 2.0

@property (nonatomic) CGFloat animationSpeed;   // default is 8.0
@property (nonatomic) CGFloat animationBounciness;  // default is 12.0
@property (nonatomic) CGFloat animationDuration;    // default is 0.6
@property (nonatomic) NSInteger animationScaleFactor;   // default is 2

@property (nonatomic) BOOL hidesForSinglePage;  // hide the indicator if there is only one page, default is NO
@property (nonatomic) BOOL defersCurrentPageDisplay;    // if set, clicking to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called, default is NO
@property (nonatomic) BOOL hideCurrentPageIndex;    // hide the indicator dot index display label, default is NO
@property (nonatomic) BOOL disableAnimation;    // disable all the indicator dot changing animation, default is NO

@property(nonatomic) UIColor *pageIndicatorTintColor;   // default is [UIColor lightTextColor]
@property(nonatomic) UIColor *currentPageIndicatorTintColor;    // default is [UIColor whiteColor]
@property(nonatomic) UIColor *currentPageIndexTextTintColor;    // default is [UIColor darkTextColor]

@property(nonatomic) UIFont *currentPageIndexTextFont;    // default is [UIFont systemFontOfSize:0], the font size is automatically adjusts by the value of indicatorDotWidth and animationScaleFactor

@property (nonatomic, copy) RCCurrentPageChangedBlock currentPageChangedBlock;   // if set, -sendActionsForControlEvents will never be called, only available for 'Touch Event' in page control, it also means you need to set non-zero frame for page control to activate 'Touch Event'

- (instancetype)initWithNumberOfPages:(NSInteger)pages; // if you want 'currentPageChanged' block available, call -setFrame: after initialization

- (void)updateCurrentPageDisplay;   // update page display to match the currentPage, ignored if defersCurrentPageDisplay is NO, setting the page value directly will update immediately

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;    // returns size required to display dots for given page count. can be used to size control if page count could change
- (CGPoint)positionForNumberOfPages:(NSInteger)pageCount;   // returns position to display dots for defined control frame and given page count. can be used to size control if control frame or page count could change

- (void)switchToPage:(NSInteger)page progress:(CGFloat)progress;    // default page animation progress is 1.0, value is between (0.01 1.0]

@end
