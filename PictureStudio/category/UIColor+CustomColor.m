//
//  UIColor+CustomColor.m
//  PictureStudio
//
//  Created by mickey on 2018/8/21.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "UIColor+CustomColor.h"

@implementation UIColor (CustomColor)

+ (UIColor *)barColor {
    return [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.98];
}

+ (UIColor *)assetTitleColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.68];
}

+ (UIColor *)assetBorderColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
}

+ (UIColor *)navShadowColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

@end
