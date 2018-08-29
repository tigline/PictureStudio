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

+ (UIColor *)backgroundColor {
    return [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
}

+ (UIColor *)cellTitleNormalColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.68];
}

+ (UIColor *)cellTitleSelectedColor {
    return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.87];
}

+ (UIColor *)cellCountColor {
    return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6];
}

+ (UIColor *)cellTimeColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
}
@end
