//
//  UIColor+CustomColor.h
//  PictureStudio
//
//  Created by mickey on 2018/8/21.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CustomColor)
+ (UIColor *)barColor;
+ (UIColor *)assetTitleColor;
+ (UIColor *)assetBorderColor;
+ (UIColor *)navShadowColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)cellTitleNormalColor;

+ (UIColor *)cellTitleSelectedColor;

+ (UIColor *)cellCountColor;

+ (UIColor *)cellTimeColor;
@end
