//
//  ToastView.m
//  PictureStudio
//
//  Created by Aaron Hou on 2018/6/14.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import "ToastView.h"
#import "HXPhotoTools.h"
static ToastView *shareToastView = nil;
@implementation ToastView
{
    UILabel *textLabel;
}

+ (ToastView *)shareToastViewInView:(UIView *)superView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareToastView = [[ToastView alloc] initWithFrame:CGRectMake(0, 0, 0, 42*ScreenHeightRatio)];
        shareToastView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height*0.85);
        [superView addSubview:shareToastView];
    });
    
    return shareToastView;
}

- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = 8;
    self.backgroundColor = [UIColor colorWithRed:189/255.0 green:221/255.0 blue:255/255.0 alpha:1];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:68/255.0 green:159/255.0 blue:255/255.0 alpha:1].CGColor;
    
}

- (void)showToastWithString:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor colorWithRed:68/255.0 green:159/255.0 blue:255/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    
    CGFloat hudW = [HXPhotoTools getTextWidth:text height:15 fontSize:18];
    CGFloat labelX = 10;
    CGFloat labelW = hudW;
    CGFloat labelH = [HXPhotoTools getTextHeight:text width:labelW fontSize:18];
    CGFloat labelY = (self.hx_h - labelH)/2;
    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    self.alpha = 0;
    shareToastView.hx_w = hudW+20;
    [self addSubview:label];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(handleGraceTimer) withObject:nil afterDelay:1.5f inModes:@[NSRunLoopCommonModes]];
    
}

- (void)handleGraceTimer {
    [UIView cancelPreviousPerformRequestsWithTarget:self];
    [self removeFromSuperview];
}



@end
