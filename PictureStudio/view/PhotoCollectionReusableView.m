//
//  PhotoCollectionReusableView.m
//  PictureStudio
//
//  Created by mickey on 2018/4/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "PhotoCollectionReusableView.h"
#import "UIView+HXExtension.h"

@interface PhotoCollectionReusableView ()
@property (strong, nonatomic) UILabel *titleLb;
@end

@implementation PhotoCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLb];
}
- (void)setVideoCount:(NSInteger)videoCount {
    _videoCount = videoCount;
    if (self.photoCount > 0 && videoCount > 0) {
        self.titleLb.text = [NSString stringWithFormat:@"%ld 张照片、%ld 个视频",self.photoCount,videoCount];
    }else if (self.photoCount > 0) {
        self.titleLb.text = [NSString stringWithFormat:@"%ld 张照片",self.photoCount];
    }else {
        self.titleLb.text = [NSString stringWithFormat:@"%ld 个视频",videoCount];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLb.frame = CGRectMake(0, 0, self.hx_w, 50);
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = [UIColor blackColor];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.font = [UIFont systemFontOfSize:15];
    }
    return _titleLb;
}
@end
