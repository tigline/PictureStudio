//
//  UINavigationBar+Color.m
//  PictureStudio
//
//  Created by mickey on 2018/4/12.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "UINavigationBar+Color.h"

@implementation UINavigationBar (Color)

- (void)setColor:(UIColor *)color {
    UIToolbar *view = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -20, self.bounds.size.width, kNavigationBarHeight)];
//    view.backgroundColor = color;
//    UIVisualEffectView *effectview;
//    if (@available(iOS 10.0, *)) {
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
//        effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    } else {
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    }
    [view setBackgroundColor:color];
    [self setValue:view forKey:@"backgroundView"];
}

@end
