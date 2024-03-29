//
//  AssetTitleView.m
//  PictureStudio
//
//  Created by mickey on 2018/4/8.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "AssetTitleView.h"
#import "UIView+HXExtension.h"

@implementation AssetTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}


- (void)buildUI
{

    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventHandler)]];
}

- (CGFloat)updateTitleConstraints:(BOOL)isFirst
{
    [self.titleButton sizeToFit];
    
    CGFloat width = CGRectGetWidth(self.titleButton.frame)/2 + 2 + CGRectGetWidth(self.arrowBtn.frame) + 15*ScreenWidthRatio;

    self.size = CGSizeMake(width * 2, self.frame.size.height);
    if (isFirst) {
        self.titleButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 20*ScreenHeightRatio);
    } else {
        self.titleButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }

    self.arrowBtn.originX = self.titleButton.rightTop.x + 10*ScreenWidthRatio;

    self.arrowBtn.center = CGPointMake(self.arrowBtn.center.x, self.titleButton.center.y);

    //self.arrowBtn.transform = CGAffineTransformRotate(self.arrowBtn.transform, M_PI);

    return CGRectGetMaxX(self.arrowBtn.frame) + 10*ScreenWidthRatio;

}


- (void)eventHandler
{
    if (self.titleViewDidClick) {
        self.titleViewDidClick();
    }
}


#pragma mark - Lazy Load
- (UILabel *)titleButton{
    if (!_titleButton) {
        _titleButton = [[UILabel alloc] init];
        _titleButton.text = LocalString(@"all_photos");
        _titleButton.font = [UIFont systemFontOfSize:17.];
        _titleButton.textColor = [UIColor blackColor];
        [self addSubview:_titleButton];
    }
    return _titleButton;
}

- (UIImageView *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"album_button"]];
        [self addSubview:_arrowBtn];
    }
    return _arrowBtn;
}

@end
