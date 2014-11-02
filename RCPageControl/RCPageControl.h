//
//  RCPageControl.h
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

#import <UIKit/UIKit.h>

@class RCPageControl;

typedef void (^RCCurrentPageChangedBlock)(RCPageControl *pageControl);

@interface RCPageControl : UIControl

@property (nonatomic) NSInteger numberOfPages;  // default is 0
@property (nonatomic) NSInteger currentPage;    // default is 0. value pinned to 0 .. numberOfPages-1

@property (nonatomic) CGFloat indicatorDotGap;  // default is 10.f, min value is 2.f
@property (nonatomic) CGFloat indicatorDotWidth;    // default is 4.f, min value is 2.f

@property (nonatomic) CGFloat animationSpeed;   // default is 8.f
@property (nonatomic) CGFloat animationBounciness;  // default is 12.f
@property (nonatomic) CGFloat animationDuration;    // default is .6f
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

- (void)switchToPage:(NSInteger)page progress:(CGFloat)progress;    // default page animation progress is 1.f, value is between (0.01f 1.f]

@end
