//
//  ViewController.m
//  RCPageControlExample
//
//  Created by Looping on 14/9/15.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "ViewController.h"
#import <RCPageControl.h>
#import <iCarousel.h>

@interface ViewController () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic) RCPageControl *pageControlRC;
@property (nonatomic) iCarousel *pageViews;
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) UIPageControl *pageControlUI;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];

    _numberOfPages = 6;
    
    [self.view addSubview:({
        if ( !_pageViews) {
            _pageViews = [[iCarousel alloc] initWithFrame:self.view.frame];
            _pageViews.dataSource = self;
            [_pageViews setPagingEnabled:YES];
            _pageViews.delegate = self;
        }
        _pageViews;
    })];
    
    [self.view addSubview:({
        if ( !_pageControlRC) {
            _pageControlRC = [[RCPageControl alloc] initWithNumberOfPages:_numberOfPages];
            
            [_pageControlRC setCenter:({
                CGPoint center = self.view.center;
                center.y = self.view.frame.size.height - 160.f;
                center;
            })];
            
            __weak ViewController *weakSelf = self;
            [_pageControlRC setCurrentPageChangedBlock:^(RCPageControl *pageControl) {
                [weakSelf.pageViews scrollToItemAtIndex:pageControl.currentPage animated:YES];
            }];
        }
        _pageControlRC;
    })];
    
    [self.view addSubview:({
        if ( !_pageControlUI) {
            _pageControlUI = [[UIPageControl alloc] init];
            
            [_pageControlUI setNumberOfPages:_numberOfPages];
            
            [_pageControlUI setCenter:({
                CGPoint center = self.view.center;
                center.y = 160.f;
                center;
            })];
            
            [_pageControlUI addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        }
        _pageControlUI;
    })];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _numberOfPages;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIView *theNewView = view ?: ({
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        
        [view addSubview:({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            [imageView setCenter:view.center];
            [imageView setImage:[UIImage imageNamed:@"avatar"]];
            [imageView.layer setCornerRadius:imageView.frame.size.height / 2];
            [imageView.layer setMasksToBounds:YES];
            imageView;
        })];
        
        view;
    });
    
    [theNewView setBackgroundColor:index % 3 ? index % 2 ? [[UIColor purpleColor] colorWithAlphaComponent:0.5] : [[UIColor blueColor] colorWithAlphaComponent:0.5] : [[UIColor cyanColor] colorWithAlphaComponent:0.5]];
    
    return theNewView;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {    
    [_pageControlRC setCurrentPage:carousel.currentItemIndex];
    [_pageControlUI setCurrentPage:carousel.currentItemIndex];
}

- (void)changePage:(id)sender {
    [_pageViews scrollToItemAtIndex:_pageControlUI.currentPage animated:YES];
}

@end
