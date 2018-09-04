//
//  PhotoSaveBottomView.m
//  PictureStudio
//
//  Created by mickey on 2018/5/6.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "PhotoSaveBottomView.h"
#import "UIView+HXExtension.h"
#import "XDProgressView.h"


@interface PhotoSaveBottomView ()
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *saveBtn;
@property (strong, nonatomic) UIButton *shareBtn;
@property (strong, nonatomic) UIButton *closeBtn;
@property (strong, nonatomic) XDProgressView *progressView;
@property (strong, nonatomic) UILabel *saveLabel;
@property (assign, nonatomic) NSInteger length;
@property (strong, nonatomic) CALayer* segmentingLineFrist;
@property (strong, nonatomic) CALayer* segmentingLineSecond;
@end

@implementation PhotoSaveBottomView
#define ViewHeight 60*ScreenHeightRatio
#define BtnHeight  34*ScreenHeightRatio
#define BtnWidth   72*ScreenWidthRatio

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    
    
    
}
- (void)setupUI {
    [self setBackgroundColor:[UIColor barColor]];
    self.clipsToBounds = YES;
    //[self addSubview:self.bgView];
    [self addSubview:self.backBtn];
    [self addSubview:self.saveBtn];
    [self addSubview:self.shareBtn];
    [self addSubview:self.closeBtn];
    [self addSubview:self.progressView];
}



- (void)didBackClick
{
    if ([self.delegate respondsToSelector:@selector(savePhotoBottomViewDidBackBtn)]) {
        [self.delegate savePhotoBottomViewDidBackBtn];
    }
}
- (void)didShareClick {
    if ([self.delegate respondsToSelector:@selector(savePhotoBottomViewDidShareBtn)]) {
        [self.delegate savePhotoBottomViewDidShareBtn];
    }
}
- (void)didSaveClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(savePhotoBottomViewDidSaveBtn:)]) {
        [self.delegate savePhotoBottomViewDidSaveBtn:button];
    }
}

- (void)setSaveBtnsHiddenValue:(BOOL)value {

    self.backBtn.hidden = value;
    self.saveBtn.hidden = value;
    self.shareBtn.hidden = value;
    _segmentingLineSecond.hidden = value;
    _segmentingLineFrist.hidden = value;
    
}

- (void)setSaveLabelHidden:(BOOL)value {
    self.progressView.hidden = value;
    self.progressView.progress = 0;
}

- (void)setProgressLength:(NSInteger)length {
    self.length = length;
}

- (void)setProgressViewValue:(NSInteger)index {
    [_progressView setProgress:(index + 1) * (1.0/self.length)];
}

- (void)setSaveText:(NSString *)text {
    _progressView.text = text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    

    //CGFloat pointY = 0;//(self.bgView.size.height - btnHeight)/2;

    
    self.backBtn.frame = CGRectMake(22*ScreenWidthRatio, 19*ScreenHeightRatio, 22*ScreenWidthRatio, 22*ScreenHeightRatio);
    self.backBtn.backgroundColor = [UIColor clearColor];
    
    self.saveBtn.frame = CGRectMake(103*ScreenWidthRatio ,13*ScreenHeightRatio, BtnWidth, BtnHeight);
    self.saveBtn.backgroundColor = [UIColor clearColor];
    
    self.shareBtn.frame = CGRectMake(197*ScreenWidthRatio, 13*ScreenHeightRatio, BtnWidth, BtnHeight);
    self.shareBtn.backgroundColor = [UIColor clearColor];
    
    self.closeBtn.frame = CGRectMake(331*ScreenWidthRatio, 19*ScreenHeightRatio, 22*ScreenWidthRatio, 22*ScreenHeightRatio);
    self.closeBtn.backgroundColor = [UIColor clearColor];
    
    self.progressView.frame = CGRectMake(0, 0, SCREEN_W, ViewHeight);
    self.progressView.hidden = YES;
    

}
//- (UIToolbar *)bgView {
//    if (!_bgView) {
//
//        _bgView = [[UIToolbar alloc] init];
//
//    }
//    return _bgView;
//}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_backBtn setImage:[UIImage imageNamed:@"tool_back"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"tool_back"] forState:UIControlStateSelected];
        //_backBtn.imageView.contentMode = UIViewContentModeCenter;
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_backBtn addTarget:self action:@selector(didBackClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _backBtn;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setImage:[UIImage imageNamed:@"tool_save_u"] forState:UIControlStateNormal];
        [_saveBtn setImage:[UIImage imageNamed:@"tool_save_p"] forState:UIControlStateSelected];
        //_saveBtn.imageView.contentMode = UIViewContentModeCenter;
//        [_saveBtn setTitle:LocalString(@"save_image") forState:UIControlStateNormal];
//        [_saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //_saveBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_saveBtn addTarget:self action:@selector(didSaveClick:) forControlEvents:UIControlEventTouchUpInside];
//        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:11];
//        _saveBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//        _saveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//        _saveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

        
    }
    return _saveBtn;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_shareBtn setTintColor:[UIColor clearColor]];
        [_shareBtn setImage:[UIImage imageNamed:@"tool_share"] forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"tool_share_p"] forState:UIControlStateSelected];
        //_shareBtn.imageView.contentMode = UIViewContentModeCenter;
        _shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_shareBtn addTarget:self action:@selector(didShareClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _shareBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_shareBtn setTintColor:[UIColor clearColor]];
        [_closeBtn setImage:[UIImage imageNamed:@"tool_cancel"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"tool_cancel_p"] forState:UIControlStateSelected];
        //_closeBtn.imageView.contentMode = UIViewContentModeCenter;
        _closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_closeBtn addTarget:self action:@selector(didShareClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeBtn;
}

- (XDProgressView *)progressView {
    if (!_progressView) {
        
        _progressView = [[XDProgressView alloc]init];
        _progressView.progress = 0.0;
        _progressView.progressTintColor = [UIColor colorWithRed:22/255.0 green:167/255.0 blue:26/255.0 alpha:1];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.text = LocalString(@"save_ing");
        //    _customProgressView.trackImage = [UIImage imageNamed:@"progressImage"];
        //    _customProgressView.roundedCorner = YES;
        //    _customProgressView.animationDuration = 1.0;
        _progressView.textAlignment = NSTextAlignmentCenter;

    }
    return _progressView;
}



@end
