//
//  AssetTitleButton.m
//  PictureStudio
//
//  Created by mickey on 2018/8/26.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "AssetTitleButton.h"

@implementation AssetTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    [self setTitle:LocalString(@"all_photos") forState:UIControlStateNormal];
    //self.titleLabel.text = LocalString(@"all_photos");
    [self setTitleColor:UIColor.assetTitleColor forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
    self.titleLabel.contentMode = UIViewContentModeCenter;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = UIColor.assetBorderColor.CGColor;
//    CGSize ysize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(200,30000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}context:nil].size;
    //self.frame = CGSizeMake(ysize.width + 47, self.frame.size.height);
    //[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventHandler)]];
}

- (CGFloat)updateTitleConstraints:(BOOL)isFirst
{
    CGSize size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(200,30000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}context:nil].size;
    return 94 + size.width;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    [self setTitle:LocalString(@"all_photos") forState:UIControlStateNormal];
//    [self setTitleColor:UIColor.assetTitleColor forState:UIControlStateNormal];
//    [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
//    self.titleLabel.contentMode = UIViewContentModeCenter;
//    self.layer.cornerRadius = 5;
//    self.layer.masksToBounds = YES;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = UIColor.assetBorderColor.CGColor;
//    self.backgroundColor = UIColor.barColor;
//}


@end
