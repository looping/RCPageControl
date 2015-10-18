//
//  CustomIndicatorView.m
//  RCPageControlExample
//
//  Created by Simo ++ on 18/10/2015.
//  Copyright © 2015 RidgeCorn. All rights reserved.
//

#import "CustomIndicatorView.h"

@interface CustomIndicatorView()

@property (nonatomic) UIImageView *imageView;

@end

@implementation CustomIndicatorView

#pragma mark - Properties

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = (self.frame.size.width/2);
    self.imageView.frame = self.bounds;
}

- (void)updateState:(BOOL)isCurrent {

    //customize your indicator view here.
    
    UIImage *image = isCurrent ? [UIImage imageNamed:@"Happy"] : [UIImage imageNamed:@"Sad"];
    [self.imageView setImage:image];
}

@end
