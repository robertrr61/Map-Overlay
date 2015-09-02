//
//  ToastLabel.m
//  MapOverlayExample
//
//  Created by Roberto Rumbaut on 8/31/15.
//  Copyright (c) 2015 mobmedianet. All rights reserved.
//

#define VERTICAL_POSITION 2/3 // Vertical Position of Toast

#import "ToastLabel.h"

@implementation ToastLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    UIEdgeInsets insets = self.edgeInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

#pragma mark - Show Toast
+(void)showToastWithMessage:(NSString*)message andDelay:(float)delay onView:(UIView*)view {
    // init
    ToastLabel *toastLabel = [[ToastLabel alloc] init];
    
    // setting text and background
    [toastLabel setAttributedText:[[NSAttributedString alloc] initWithString:message attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}]];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    [toastLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]];
    
    // size and insets
    toastLabel.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [toastLabel sizeToFit];
    [toastLabel setFrame:CGRectMake(view.frame.size.width/2-toastLabel.frame.size.width/2,
                              view.frame.size.height*VERTICAL_POSITION-toastLabel.frame.size.height+20,
                              toastLabel.frame.size.width,
                              toastLabel.frame.size.height+20)];
    
    // size adjustment
    if (toastLabel.frame.size.width > view.frame.size.width*0.8) {
        toastLabel.numberOfLines = 0;
        [toastLabel setFrame:CGRectMake(view.frame.size.width/2-view.frame.size.width*0.8/2,
                                  view.frame.size.height*VERTICAL_POSITION-toastLabel.frame.size.height/2,
                                  view.frame.size.width*0.8,
                                  toastLabel.frame.size.height+10)];
    }
    
    // rounded corners
    toastLabel.layer.cornerRadius = 5.0;
    toastLabel.layer.masksToBounds = YES;
    
    // add to view with fade in animation
    [view addSubview:toastLabel];
    [toastLabel setAlpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        [toastLabel setAlpha:1.0];
    }];
    
    // hide after delay
    [self performSelector:@selector(hideToastMessage:) withObject:toastLabel afterDelay:delay];
}

+(void)hideToastMessage:(ToastLabel*)messageLabel {
    [UIView animateWithDuration:0.3 animations:^{
        [messageLabel setAlpha:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [messageLabel removeFromSuperview];
        }
    }];
}



@end
