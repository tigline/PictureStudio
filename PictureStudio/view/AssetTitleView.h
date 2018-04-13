//
//  AssetTitleView.h
//  PictureStudio
//
//  Created by mickey on 2018/4/8.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetTitleView : UIView
@property (nonatomic, strong) UILabel *titleButton;

@property (nonatomic, strong) UIImageView *arrowBtn;

@property (nonatomic, copy) void (^titleViewDidClick)(void);

- (CGFloat)updateTitleConstraints:(BOOL)isFirst;
@end
