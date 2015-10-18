//
//  RCAbstractIndicatorView.m
//  Pods
//
//  Created by Simo ++ on 18/10/2015.
//
//

#import "RCAbstractIndicatorView.h"

@implementation RCAbstractIndicatorView

- (instancetype)init {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                 userInfo:nil];
}

- (void)updateState:(BOOL)isCurrent {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in %@", NSStringFromSelector(_cmd), self.class]
                                 userInfo:nil];
}

@end
