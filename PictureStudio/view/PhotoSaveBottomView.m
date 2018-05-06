//
//  PhotoSaveBottomView.m
//  PictureStudio
//
//  Created by mickey on 2018/5/6.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "PhotoSaveBottomView.h"
#import "UIView+HXExtension.h"


@interface PhotoSaveBottomView ()
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *saveBtn;
@property (strong, nonatomic) UIButton *shareBtn;
@end

@implementation PhotoSaveBottomView
#define btnHeight 40

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
- (void)didSaveClick {
    if ([self.delegate respondsToSelector:@selector(savePhotoBottomViewDidSaveBtn)]) {
        [self.delegate savePhotoBottomViewDidSaveBtn];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = self.bounds;
    
    CGFloat btnWidth = self.bgView.frame.size.width/3;
    CGFloat pointY = (self.bgView.size.height - btnHeight)/2;
    
    self.backBtn.frame = CGRectMake(21.4, pointY, btnHeight, btnHeight);
    self.backBtn.backgroundColor = [UIColor clearColor];
    
    self.saveBtn.frame = CGRectMake(106, pointY, 165, btnHeight);
    
    
    self.shareBtn.frame = CGRectMake(self.hx_w - btnHeight - 20, (self.bgView.size.height - btnHeight*0.75)/2, btnHeight*0.75, btnHeight*0.75);
    
    CALayer* segmentingLineFrist = [CALayer layer];
    segmentingLineFrist.frame = CGRectMake(106, 13, 0.6, 18);
    segmentingLineFrist.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:segmentingLineFrist];
    
    CALayer* segmentingLineSecond = [CALayer layer];
    segmentingLineSecond.frame = CGRectMake(271, 13, 0.6, 18);
    segmentingLineSecond.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:segmentingLineSecond];
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

        [_saveBtn setTitle:@"Save image to album" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //_saveBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        //_saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_saveBtn addTarget:self action:@selector(didSaveClick) forControlEvents:UIControlEventTouchUpInside];
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
        [_shareBtn setImage:[UIImage imageNamed:@"share_more"] forState:UIControlStateNormal];


        _shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_shareBtn addTarget:self action:@selector(didShareClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _shareBtn;
}

@end
