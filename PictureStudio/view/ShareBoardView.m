//
//  ShareBoardView.m
//  PictureStudio
//
//  Created by mickey on 2018/5/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "ShareBoardView.h"
#import "UIView+HXExtension.h"

@interface ShareBoardView()
@property (strong, nonatomic) UIToolbar *bgView;
@property (strong, nonatomic) UIButton *weChatBtn;
@property (strong, nonatomic) UIButton *momentBtn;
@property (strong, nonatomic) UIButton *weiboBtn;
@property (strong, nonatomic) UIButton *moreBtn;

@end

@implementation ShareBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupUI {
    //[self setBackgroundColor:[UIColor clearColor]];
    self.clipsToBounds = YES;
    [self addSubview:self.bgView];
    [self addSubview:self.weChatBtn];
    [self addSubview:self.momentBtn];
    [self addSubview:self.weiboBtn];
    [self addSubview:self.moreBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    CGFloat maginLeft = 43*ScreenWidthRatio;
    CGFloat gapWidth = 35*ScreenWidthRatio;
    CGFloat btnWidth = 46*ScreenWidthRatio;
    CGFloat pointY = (self.hx_h - btnWidth)/2;
    
    _weChatBtn.frame = CGRectMake(maginLeft, pointY, btnWidth, btnWidth);
    _momentBtn.frame = CGRectMake(gapWidth + btnWidth + _weChatBtn.originX, pointY, btnWidth, btnWidth);
    _weiboBtn.frame = CGRectMake(gapWidth + btnWidth + _momentBtn.originX, pointY, btnWidth, btnWidth);
    _moreBtn.frame = CGRectMake(gapWidth + btnWidth + _weiboBtn.originX, pointY, btnWidth, btnWidth);
    
    
}

- (void)onShareWechatClicked:(id)sender {
    if ([self.shareDelegate respondsToSelector:@selector(shareBoardViewDidWeChatBtn)]) {
        [self.shareDelegate shareBoardViewDidWeChatBtn];
    }
}

- (void)onShareMomentClicked:(id)sender {
    if ([self.shareDelegate respondsToSelector:@selector(shareBoardViewDidMomentBtn)]) {
        [self.shareDelegate shareBoardViewDidMomentBtn];
    }
}

- (void)onShareWeiboClicked:(id)sender {
    if ([self.shareDelegate respondsToSelector:@selector(shareBoardViewDidWeiboBtn)]) {
        [self.shareDelegate shareBoardViewDidWeiboBtn];
    }
}

- (void)onShareMoreClicked:(id)sender {
    if ([self.shareDelegate respondsToSelector:@selector(shareBoardViewDidMoreBtn)]) {
        [self.shareDelegate shareBoardViewDidMoreBtn];
    }
}



- (UIToolbar *)bgView {
    if (!_bgView) {
        _bgView = [[UIToolbar alloc] init];
        
    }
    return _bgView;
}

- (UIButton *)weChatBtn {
    if (!_weChatBtn) {
        _weChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weChatBtn setBackgroundColor:UIColor.clearColor];
        [_weChatBtn setImage:[UIImage imageNamed:@"share_wechat"] forState:UIControlStateNormal];
        _weChatBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_weChatBtn addTarget:self action:@selector(onShareWechatClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _weChatBtn;
}

- (UIButton *)momentBtn {
    if (!_momentBtn) {
        _momentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_momentBtn setBackgroundColor:UIColor.clearColor];
        [_momentBtn setImage:[UIImage imageNamed:@"share_moments"] forState:UIControlStateNormal];
        _momentBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_momentBtn addTarget:self action:@selector(onShareMomentClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _momentBtn;
}

- (UIButton *)weiboBtn {
    if (!_weiboBtn) {
        _weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weiboBtn setBackgroundColor:UIColor.clearColor];
        [_weiboBtn setImage:[UIImage imageNamed:@"share_weibo"] forState:UIControlStateNormal];
        _weiboBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_weiboBtn addTarget:self action:@selector(onShareWeiboClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _weiboBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setBackgroundColor:UIColor.clearColor];
        [_moreBtn setImage:[UIImage imageNamed:@"share_more"] forState:UIControlStateNormal];
        _moreBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_moreBtn addTarget:self action:@selector(onShareMoreClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _moreBtn;
}

@end
