//
//  ToastView.h
//  PictureStudio
//
//  Created by Aaron Hou on 2018/6/14.
//  Copyright © 2018 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView
+ (ToastView *)shareToastViewInView:(UIView *)superView;
- (void)showToastWithString:(NSString *)text;
@end
