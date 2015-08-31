//
//  ToastLabel.m
//  MapOverlayExample
//
//  Created by Roberto Rumbaut on 8/31/15.
//  Copyright (c) 2015 mobmedianet. All rights reserved.
//

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
- (void)showWithMessage:(NSString *)message andDelay:(float)delay onView:(UIView *)view{
    [self setAttributedText:[[NSAttributedString alloc] initWithString:message attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}]];
    [self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    self.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [self sizeToFit];
    
    self.textAlignment = NSTextAlignmentCenter;
    
    [self setFrame:CGRectMake(view.frame.size.width/2-self.frame.size.width/2,
                              view.frame.size.height*3/4-self.frame.size.height+20,
                              self.frame.size.width,
                              self.frame.size.height+20)];
    
    if (self.frame.size.width > view.frame.size.width*0.8) {
        self.numberOfLines = 0;
        [self setFrame:CGRectMake(view.frame.size.width/2-view.frame.size.width*0.8/2,
                                  view.frame.size.height*3/4-self.frame.size.height/2,
                                  view.frame.size.width*0.8,
                                  self.frame.size.height+10)];
    }
    
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    [view addSubview:self];
    [self setAlpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1.0];
    }];
    [self performSelector:@selector(hideToastMessage:) withObject:self afterDelay:delay];
}

-(void)hideToastMessage:(ToastLabel*)messageLabel {
    [UIView animateWithDuration:0.3 animations:^{
        [messageLabel setAlpha:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [messageLabel removeFromSuperview];
        }
    }];
}



@end
