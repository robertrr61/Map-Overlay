//
//  ToastLabel.h
//  MapOverlayExample
//
//  Created by Roberto Rumbaut on 8/31/15.
//  Copyright (c) 2015 mobmedianet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastLabel : UILabel

@property (nonatomic) UIEdgeInsets edgeInsets;

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines;

- (void)drawTextInRect:(CGRect)rect;

- (void)showWithMessage:(NSString*)message andDelay:(float)delay onView:(UIView*)view;

@end
