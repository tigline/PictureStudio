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
@property (strong, nonatomic) XDProgressView *progressView;
@property (strong, nonatomic) UILabel *saveLabel;
@property (assign, nonatomic) NSInteger length;
@property (strong, nonatomic) CALayer* segmentingLineFrist;
@property (strong, nonatomic) CALayer* segmentingLineSecond;
@end

@implementation PhotoSaveBottomView
#define btnHeight 45*ScreenHeightRatio

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
    [self setBackgroundColor:[UIColor clearColor]];
    self.clipsToBounds = YES;
    [self addSubview:self.bgView];
    [self addSubview:self.backBtn];
    [self addSubview:self.saveBtn];
    [self addSubview:self.shareBtn];
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
    [_progressView setProgress:index * (1.0/self.length)];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = self.bounds;
    

    CGFloat pointY = 0;//(self.bgView.size.height - btnHeight)/2;
    
    self.backBtn.frame = CGRectMake(28.4*ScreenWidthRatio, pointY, btnHeight, btnHeight);
    self.backBtn.backgroundColor = [UIColor clearColor];
    
    self.saveBtn.frame = CGRectMake(106*ScreenWidthRatio, pointY, 165*ScreenWidthRatio, btnHeight);
    self.saveBtn.backgroundColor = [UIColor clearColor];
    
    self.shareBtn.frame = CGRectMake(self.hx_w - btnHeight - 20*ScreenWidthRatio, pointY, btnHeight, btnHeight);
    self.shareBtn.backgroundColor = [UIColor clearColor];
    
    self.progressView.frame = CGRectMake(0, 0, SCREEN_W, btnHeight);
    self.progressView.hidden = YES;
    
    _segmentingLineFrist = [CALayer layer];
    _segmentingLineFrist.frame = CGRectMake(106*ScreenWidthRatio, 14, 0.6, 18);
    _segmentingLineFrist.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:_segmentingLineFrist];
    
    _segmentingLineSecond = [CALayer layer];
    _segmentingLineSecond.frame = CGRectMake(271*ScreenWidthRatio, 14, 0.6, 18);
    _segmentingLineSecond.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:_segmentingLineSecond];
}
- (UIToolbar *)bgView {
    if (!_bgView) {
    
        _bgView = [[UIToolbar alloc] init];

    }
    return _bgView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.bgView.frame = self.bounds;
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];

        
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backBtn addTarget:self action:@selector(didBackClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _backBtn;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];

        [_saveBtn setTitle:LocalString(@"save_image") forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //_saveBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        //_saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_saveBtn addTarget:self action:@selector(didSaveClick:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _saveBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _saveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _saveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

        
    }
    return _saveBtn;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_shareBtn setTintColor:[UIColor clearColor]];
        [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];

        _shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //_shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_shareBtn addTarget:self action:@selector(didShareClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _shareBtn;
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
