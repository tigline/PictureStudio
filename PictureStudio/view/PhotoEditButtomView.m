//
//  PhotoEditButtomView.m
//  PictureStudio
//
//  Created by mickey on 2018/4/7.
//  Copyright © 2018年 Aaron Hou. All rights reserved.
//

#import "PhotoEditButtomView.h"


@interface PhotoEditButtomView ()
@property (strong, nonatomic) UIButton *combineBtn;
@property (strong, nonatomic) UIButton *scrollBtn;
@property (strong, nonatomic) UIButton *editBtn;
@property (strong, nonatomic) UIButton *combineBtnH;
@property (strong, nonatomic) UIButton *clearBtn;
@property (strong, nonatomic) UILabel  *selectLabel;
@property (strong, nonatomic) CALayer* segmentingLineFrist;
@property (strong, nonatomic) CALayer* segmentingLineSecond;
@property (strong, nonatomic) CALayer* segmentingLineThird;
@property (strong, nonatomic) CALayer* segmentingLineFourth;
@end

@implementation PhotoEditButtomView
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
    [self addSubview:self.selectLabel];
    [self addSubview:self.clearBtn];
    [self addSubview:self.combineBtn];
    [self addSubview:self.scrollBtn];
    [self addSubview:self.combineBtnH];
    
}
- (void)setManager:(HXPhotoManager *)manager {
    _manager = manager;
    
    UIColor *themeColor = [UIColor colorWithRed:84/255.0 green:130/255.0 blue:1 alpha:1];
    [self.combineBtn setTitleColor:themeColor forState:UIControlStateNormal];
    [self.combineBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.scrollBtn setTitleColor:themeColor forState:UIControlStateNormal];
    [self.scrollBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.editBtn setTitleColor:themeColor forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.combineBtnH setTitleColor:themeColor forState:UIControlStateNormal];
    [self.combineBtnH setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    //[self.clearBtn setTitleColor:self.manager.configuration.themeColor forState:UIControlStateNormal];
    [self.clearBtn setTintColor:[UIColor grayColor]];

}
- (void)setSelectCount:(NSInteger)selectCount {
    _selectCount = selectCount;

    if (selectCount > 0) {
        self.clearBtn.hidden = NO;
    } else {
        self.clearBtn.hidden = YES;
    }
    
    if(selectCount > 1) {
        
        if (_manager.isAllScreenShotPhoto) {
            [self showAllButtons];
        } else {
            [self showCombineButtons];
        }
        
    } else {
        [self hideAllButtons];
    }
}



- (void)didCombineClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidCombineBtn)]) {
        [self.delegate datePhotoBottomViewDidCombineBtn];
    }
}
- (void)didEditClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidEditBtn)]) {
        [self.delegate datePhotoBottomViewDidEditBtn];
    }
}
- (void)didScrollClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidEditBtn)]) {
        [self.delegate datePhotoBottomViewDidScrollBtn];
    }
}
- (void)didClearClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidClearBtn)]) {
        [self.delegate datePhotoBottomViewDidClearBtn];
    }
}

- (void)didcombineBtnHClick {
    if ([self.delegate respondsToSelector:@selector(datePhotoBottomViewDidcombineBtnH)]) {
        [self.delegate datePhotoBottomViewDidcombineBtnH];
    }
}

- (void)showCombineButtons {
    
    _selectLabel.hidden = YES;
    _scrollBtn.hidden = YES;
    _combineBtn.hidden = NO;
    _combineBtnH.hidden = NO;
    self.segmentingLineFrist.hidden = NO;
    self.segmentingLineSecond.hidden = NO;
    _segmentingLineThird.hidden = YES;
    _segmentingLineFourth.hidden = YES;
    
    CGFloat btnWidth = self.bgView.hx_w/7;
    CGFloat pointY = 0;
    CGFloat combineBtnW = (self.bgView.hx_w - btnWidth)/2;

    self.combineBtn.frame = CGRectMake(btnWidth, pointY, combineBtnW, btnHeight);

    self.combineBtnH.frame = CGRectMake(btnWidth+combineBtnW, pointY, combineBtnW, btnHeight);

}

- (void)showAllButtons {
    _selectLabel.hidden = YES;
    _scrollBtn.hidden = NO;
    _combineBtn.hidden = NO;
    _combineBtnH.hidden = NO;
    self.segmentingLineFrist.hidden = NO;
    self.segmentingLineSecond.hidden = YES;
    _segmentingLineThird.hidden = NO;
    _segmentingLineFourth.hidden = NO;
    
    CGFloat btnWidth = self.bgView.hx_w/7;
    CGFloat pointY = 0;
    CGFloat combineBtnW = (self.bgView.hx_w - btnWidth)/3;

    self.combineBtn.frame = CGRectMake(btnWidth+combineBtnW, pointY, combineBtnW, btnHeight);
    
    self.combineBtnH.frame = CGRectMake(btnWidth+combineBtnW*2, pointY, combineBtnW, btnHeight);
}

- (void)hideAllButtons {
    _selectLabel.hidden = NO;
    _scrollBtn.hidden = YES;
    _combineBtn.hidden = YES;
    _combineBtnH.hidden = YES;
    _segmentingLineFrist.hidden = YES;
    _segmentingLineSecond.hidden = YES;
    _segmentingLineThird.hidden = YES;
    _segmentingLineFourth.hidden = YES;
}

- (void)showClearBtn {

    CGFloat btnWidth = self.bgView.frame.size.width/6;
    CGFloat pointY = 0;//(self.bgView.size.height - btnHeight)/2 - kBottomMargin/2;
    self.clearBtn.hidden = NO;
    
    self.combineBtn.frame = CGRectMake(btnWidth, pointY, btnWidth*5, btnHeight);
    

}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_selectCount > 0) {
        return;
    }
    
    
    self.bgView.frame = self.bounds;
    CGFloat btnWidth = self.bgView.hx_w/7;
    CGFloat pointY = 0;//(self.bgView.size.height - btnHeight)/2 - kBottomMargin/2;
    CGFloat combineBtnWAll = (self.bgView.hx_w - btnWidth)/3;
    CGFloat combineBtnWTwo = (self.bgView.hx_w - btnWidth)/2;
    self.selectLabel.frame = CGRectMake(btnWidth, pointY, SCREEN_W - btnWidth*2, btnHeight);
    
    self.clearBtn.frame = CGRectMake(0, pointY, btnWidth, btnHeight);
    self.clearBtn.hidden = YES;
    
    self.scrollBtn.frame = CGRectMake(btnWidth, pointY, combineBtnWAll, btnHeight);
    self.scrollBtn.hidden = YES;
    
    CGFloat offsetY = kDevice_Is_iPhoneX? 3.5:0 ;
    
    _segmentingLineFrist = [CALayer layer];
    _segmentingLineFrist.frame = CGRectMake(btnWidth, 13+offsetY, 0.6, 18);
    _segmentingLineFrist.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:_segmentingLineFrist];
    _segmentingLineFrist.hidden = YES;
    
    _segmentingLineSecond = [CALayer layer];
    _segmentingLineSecond.frame = CGRectMake(btnWidth+combineBtnWTwo, 13+offsetY, 0.6, 18);
    _segmentingLineSecond.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:_segmentingLineSecond];
    _segmentingLineSecond.hidden = YES;
    
    _segmentingLineThird = [CALayer layer];
    _segmentingLineThird.frame = CGRectMake(btnWidth+combineBtnWAll, 13+offsetY, 0.6, 18);
    _segmentingLineThird.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:_segmentingLineThird];
    _segmentingLineThird.hidden = YES;
    
    _segmentingLineThird = [CALayer layer];
    _segmentingLineThird.frame = CGRectMake(btnWidth+combineBtnWAll, 13+offsetY, 0.6, 18);
    _segmentingLineThird.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:_segmentingLineThird];
    _segmentingLineThird.hidden = YES;
    
    _segmentingLineFourth = [CALayer layer];
    _segmentingLineFourth.frame = CGRectMake(btnWidth+combineBtnWAll*2, 13+offsetY, 0.6, 18);
    _segmentingLineFourth.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f] CGColor];
    [self.bgView.layer addSublayer:_segmentingLineFourth];
    _segmentingLineFourth.hidden = YES;
    
    
}
- (UIToolbar *)bgView {
    if (!_bgView) {
        _bgView = [[UIToolbar alloc] init];
        
    }
    return _bgView;
}

- (UILabel *)selectLabel {
    if (!_selectLabel) {
        _selectLabel = [[UILabel alloc]init];
        _selectLabel.text = LocalString(@"operate_tips");
        _selectLabel.textAlignment = NSTextAlignmentCenter;
        _selectLabel.textColor = [UIColor lightGrayColor];
        _selectLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _selectLabel;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.bgView.frame = self.bounds;
        UIImage *image = [UIImage imageNamed:@"cancel-1"];
        [_clearBtn setImage:image forState:UIControlStateNormal];
        _clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_clearBtn addTarget:self action:@selector(didClearClick) forControlEvents:UIControlEventTouchUpInside];
        //_clearBtn.enabled = NO;
    }
    return _clearBtn;
}

- (UIButton *)combineBtn {
    if (!_combineBtn) {
        _combineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.bgView.frame = self.bounds;
        [_combineBtn setImage:[UIImage imageNamed:@"tab_combine_active"] forState:UIControlStateNormal];
        [_combineBtn setImage:[UIImage imageNamed:@"tab_combine"] forState:UIControlStateDisabled];
        [_combineBtn setTitle:LocalString(@"combine_v") forState:UIControlStateNormal];
        _combineBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _combineBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10*ScreenWidthRatio, 0, 0);
        _combineBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10*ScreenWidthRatio, 0, 0);
        _combineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_combineBtn addTarget:self action:@selector(didCombineClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _combineBtn;
}

- (UIButton *)scrollBtn {
    if (!_scrollBtn) {
        _scrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollBtn setImage:[UIImage imageNamed:@"tab_scroll_active"] forState:UIControlStateNormal];
        [_scrollBtn setImage:[UIImage imageNamed:@"tab_scroll"] forState:UIControlStateDisabled];
        [_scrollBtn setTitle:LocalString(@"scroll") forState:UIControlStateNormal];
        _scrollBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_scrollBtn addTarget:self action:@selector(didScrollClick) forControlEvents:UIControlEventTouchUpInside];
        _scrollBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _scrollBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10*ScreenWidthRatio, 0, 0);
        _scrollBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10*ScreenWidthRatio, 0, 0);
        //_scrollBtn.enabled = NO;

    }
    return _scrollBtn;
}
- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_editBtn setTintColor:[UIColor clearColor]];
        [_editBtn setImage:[UIImage imageNamed:@"tab_edit_active"] forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"tab_edit"] forState:UIControlStateDisabled];
        [_editBtn setTitle:LocalString(@"edit") forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30*ScreenWidthRatio, 0, 0);
        _editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 40*ScreenWidthRatio, 0, 0);
        _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_editBtn addTarget:self action:@selector(didEditClick) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.enabled = NO;
    }
    return _editBtn;
}
- (UIButton *)combineBtnH {
    if (!_combineBtnH) {
        _combineBtnH = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_editBtn setTintColor:[UIColor clearColor]];
        [_combineBtnH setImage:[UIImage imageNamed:@"tab_combine_active"] forState:UIControlStateNormal];
        [_combineBtnH setImage:[UIImage imageNamed:@"tab_combine"] forState:UIControlStateDisabled];
        [_combineBtnH setTitle:LocalString(@"combine_h") forState:UIControlStateNormal];
        _combineBtnH.titleLabel.font = [UIFont systemFontOfSize:12];
        _combineBtnH.imageEdgeInsets = UIEdgeInsetsMake(0, -10*ScreenWidthRatio, 0, 0);
        _combineBtnH.titleEdgeInsets = UIEdgeInsetsMake(0, 10*ScreenWidthRatio, 0, 0);
        _combineBtnH.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_combineBtnH addTarget:self action:@selector(didcombineBtnHClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _combineBtnH;
}

@end
