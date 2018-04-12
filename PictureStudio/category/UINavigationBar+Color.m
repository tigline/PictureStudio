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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.bounds.size.width, 64)];
    view.backgroundColor = color;
    [self setValue:view forKey:@"backgroundView"];
}

@end
